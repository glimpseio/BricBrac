//
//  Brac.swift
//  Bric-à-brac
//
//  Created by Marc Prud'hommeaux on 6/20/15.
//  Copyright © 2015 io.glimpse. All rights reserved.
//


/// Adoption of Bracable signals that the type can be instantiated from some Bric
public protocol Bracable {
    /// Try to construct an instance of the type from the `Bric` parameter
    static func brac(bric: Bric) throws -> Self
}

extension Bric : Bracable {
    /// Bric always bracs to itself
    public static func brac(bric: Bric) throws -> Bric {
        return bric
    }
}

extension String: Bracable {
    /// A String is Brac'd to a `Bric.str` or else throws an error
    public static func brac(bric: Bric) throws -> String {
        if case .str(let str) = bric {
            return str
        } else {
            return try bric.invalidType()
        }
    }
}

extension Bool: Bracable {
    /// A Bool is Brac'd to a `Bric.bol` or else throws an error
    public static func brac(bric: Bric) throws -> Bool {
        if case .bol(let bol) = bric {
            return bol
        } else {
            return try bric.invalidType()
        }
    }
}


/// Covenience extension for String so either strings or enum strings can be used to bric and brac
extension String : RawRepresentable {
    public typealias RawValue = String
    public init?(rawValue: String) { self = rawValue }
    public var rawValue: String { return self }
}


public extension Bric {
    /// Bracs this type as Void, throwing an error if the underlying type is not null
    public func bracNul() throws -> Bric.NulType {
        guard case .nul = self else { return try invalidType() }
        return Bric.NulType()
    }

    /// Bracs this type as Number, throwing an error if the underlying type is not a number
    public func bracNum() throws -> Bric.NumType {
        guard case .num(let x) = self else { return try invalidType() }
        return x
    }

    /// Bracs this type as String, throwing an error if the underlying type is not a string
    public func bracStr() throws -> Bric.StrType {
        guard case .str(let x) = self else { return try invalidType() }
        return x
    }

    /// Bracs this type as Bool, throwing an error if the underlying type is not a boolean
    public func bracBol() throws -> Bric.BolType {
        guard case .bol(let x) = self else { return try invalidType() }
        return x
    }

    /// Bracs this type as an Object, throwing an error if the underlying type is not an object
    public func bracObj() throws -> Bric.ObjType {
        guard case .obj(let x) = self else { return try invalidType() }
        return x
    }

    /// Bracs this type as an Array, throwing an error if the underlying type is not an array
    public func bracArr() throws -> Bric.ArrType {
        guard case .arr(let x) = self else { return try invalidType() }
        return x
    }

}

/// Extensions for Bracing instances by key and inferred return type
public extension Bric {

    internal func objectKey<R: RawRepresentable where R.RawValue == String>(key: R) throws -> Optional<Bric> {
        guard case .obj(let dict) = self else {
            throw BracError.keyWithoutObject(key: key.rawValue, path: [])
        }
        return dict[key.rawValue]
    }

    /// Reads a required Bric instance from the given key in an object bric
    public func bracKey<T: Bracable, R: RawRepresentable where R.RawValue == String>(key: R) throws -> T {
        if let value = try objectKey(key) {
            return try bracPath(key, T.brac(value))
        } else {
            throw BracError.missingRequiredKey(type: T.self, key: key.rawValue, path: [])
        }
    }

    /// Reads one level of wrapped instance(s) from the given key in an object bric
    public func bracKey<T: BracLayer, R: RawRepresentable where R.RawValue == String, T.BracSub : Bracable>(key: R) throws -> T {
        return try bracPath(key, T.brac(objectKey(key) ?? nil))
    }

    /// Reads two levels of wrapped instance(s) from the given key in an object bric
    public func bracKey<T: BracLayer, R: RawRepresentable where R.RawValue == String, T.BracSub : BracLayer, T.BracSub.BracSub : Bracable>(key: R) throws -> T {
        return try bracPath(key, T.brac(objectKey(key) ?? nil))
    }

    /// Reads three levels of wrapped instance(s) from the given key in an object bric
    public func bracKey<T: BracLayer, R: RawRepresentable where R.RawValue == String, T.BracSub : BracLayer, T.BracSub.BracSub : BracLayer, T.BracSub.BracSub.BracSub : Bracable>(key: R) throws -> T {
        return try bracPath(key, T.brac(objectKey(key) ?? nil))
    }

    /// Reads four levels of wrapped instance(s) from the given key in an object bric
    public func bracKey<T: BracLayer, R: RawRepresentable where R.RawValue == String, T.BracSub : BracLayer, T.BracSub.BracSub : BracLayer, T.BracSub.BracSub.BracSub : BracLayer, T.BracSub.BracSub.BracSub.BracSub : Bracable>(key: R) throws -> T {
        return try bracPath(key, T.brac(objectKey(key) ?? nil))
    }

    /// Reads five levels of wrapped instance(s) from the given key in an object bric
    public func bracKey<T: BracLayer, R: RawRepresentable where R.RawValue == String, T.BracSub : BracLayer, T.BracSub.BracSub : BracLayer, T.BracSub.BracSub.BracSub : BracLayer, T.BracSub.BracSub.BracSub.BracSub : BracLayer, T.BracSub.BracSub.BracSub.BracSub.BracSub : Bracable>(key: R) throws -> T {
        return try bracPath(key, T.brac(objectKey(key) ?? nil))
    }

    /// Reads any one of the given Brics, throwing an error if the successful number of instances is outside of the given range of acceptable passes
    public func bracRange<T: Bracable>(range: Range<Int>, bracers: [() throws -> T]) throws -> [T] {
        var values: [T] = []
        var errors: [ErrorType] = []
        for f in bracers {
            do {
                values.append(try f())
            } catch {
                errors.append(error)
            }
        }

        if values.count < range.startIndex {
            throw BracError.multipleErrors(errors: errors, path: [])
        } else if values.count > range.endIndex  {
            throw BracError.multipleMatches(type: T.self, path: [])
        } else {
            return values
        }
    }

    /// Reads any one of the given Brics, throwing an error if all of the closures also threw an error or more than one succeeded
    public func bracOne<T: Bracable>(oneOf: [() throws -> T]) throws -> T {
        return try bracRange(1...1, bracers: oneOf)[0]
    }

    /// Reads at least one of the given Brics, throwing an error if none of the brics passed
    public func bracAny<T1, T2>(b1: Bric throws -> T1, _ b2: Bric throws -> T2) throws -> (T1?, T2?) {
        var errs: [ErrorType] = []

        var t1: T1?
        do { t1 = try b1(self) } catch { errs.append(error) }
        var t2: T2?
        do { t2 = try b2(self) } catch { errs.append(error) }

        if t1 == nil && t2 == nil {
            throw BracError.multipleErrors(errors: errs, path: [])
        } else {
            return (t1, t2)
        }
    }

    /// Reads at least one of the given Brics, throwing an error if none of the brics passed
    public func bracAny<T1, T2, T3>(b1: Bric throws -> T1, _ b2: Bric throws -> T2, _ b3: Bric throws -> T3) throws -> (T1?, T2?, T3?) {
        var errs: [ErrorType] = []

        var t1: T1?
        do { t1 = try b1(self) } catch { errs.append(error) }
        var t2: T2?
        do { t2 = try b2(self) } catch { errs.append(error) }
        var t3: T3?
        do { t3 = try b3(self) } catch { errs.append(error) }

        if t1 == nil && t2 == nil && t3 == nil {
            throw BracError.multipleErrors(errors: errs, path: [])
        } else {
            return (t1, t2, t3)
        }
    }

    /// Reads at least one of the given Brics, throwing an error if none of the brics passed
    public func bracAny<T1, T2, T3, T4>(b1: Bric throws -> T1, _ b2: Bric throws -> T2, _ b3: Bric throws -> T3, _ b4: Bric throws -> T4) throws -> (T1?, T2?, T3?, T4?) {
        var errs: [ErrorType] = []

        var t1: T1?
        do { t1 = try b1(self) } catch { errs.append(error) }
        var t2: T2?
        do { t2 = try b2(self) } catch { errs.append(error) }
        var t3: T3?
        do { t3 = try b3(self) } catch { errs.append(error) }
        var t4: T4?
        do { t4 = try b4(self) } catch { errs.append(error) }

        if t1 == nil && t2 == nil && t3 == nil && t4 == nil {
            throw BracError.multipleErrors(errors: errs, path: [])
        } else {
            return (t1, t2, t3, t4)
        }
    }

    /// Reads at least one of the given Brics, throwing an error if none of the brics passed
    public func bracAny<T1, T2, T3, T4, T5>(b1: Bric throws -> T1, _ b2: Bric throws -> T2, _ b3: Bric throws -> T3, _ b4: Bric throws -> T4, _ b5: Bric throws -> T5) throws -> (T1?, T2?, T3?, T4?, T5?) {
        var errs: [ErrorType] = []

        var t1: T1?
        do { t1 = try b1(self) } catch { errs.append(error) }
        var t2: T2?
        do { t2 = try b2(self) } catch { errs.append(error) }
        var t3: T3?
        do { t3 = try b3(self) } catch { errs.append(error) }
        var t4: T4?
        do { t4 = try b4(self) } catch { errs.append(error) }
        var t5: T5?
        do { t5 = try b5(self) } catch { errs.append(error) }

        if t1 == nil && t2 == nil && t3 == nil && t4 == nil && t5 == nil {
            throw BracError.multipleErrors(errors: errs, path: [])
        } else {
            return (t1, t2, t3, t4, t5)
        }
    }

    public func bracAny<T: Bracable>(anyOf: [() throws -> T]) throws -> NonEmptyCollection<T, [T]> {
        let elements = try bracRange(1...anyOf.count, bracers: anyOf)
        return NonEmptyCollection(elements[0], tail: Array(elements.dropFirst()))
    }

    /// Reads all of the given Brics, throwing an error if any of the closures threw an error
    public func bracAll<T: Bracable>(allOf: [() throws -> T]) throws -> [T] {
        return try bracRange(allOf.count...allOf.count, bracers: allOf)
    }

    /// Bracs the T with the given factory
    public func brac2<T1, T2>(t1: Bric throws -> T1, _ t2: Bric throws -> T2) throws -> (T1, T2) {
        return try (t1(self), t2(self))
    }

    /// Returns a dictionary of keys to raw Brics for all keys that are not present in the given RawType (e.g., an enum of keys)
    /// This is useful for maintaining the underlying Brics of any object keys that are not strictly enumerated
    public func bracDisjoint<R: RawRepresentable where R.RawValue == String>(keys: R.Type) throws -> Dictionary<String, Bric> {
        guard case .obj(let d) = self else { return try invalidType() }
        var dict = d
        for key in dict.keys {
            if R(rawValue: key) != nil {
                dict.removeValueForKey(key)
            }
        }
        return dict
    }

    /// Validates that only the given keys exists in the current dictionary bric; useful for forbidding additionalProperties
    public func exclusiveKeys<T>(keys: [String], @autoclosure _ f: () throws -> T) throws -> T {
        guard case .obj(let dict) = self else { return try invalidType() }
        let unrecognized = Set(dict.keys).subtract(keys)
        if !unrecognized.isEmpty {
            let errs: [ErrorType] = Array(unrecognized).map({ BracError.unrecognizedKey(key: $0, path: []) })
            if errs.count == 1 {
                throw errs[0]
            } else {
                throw BracError.multipleErrors(errors: errs, path: [])
            }
        }
        return try f()
    }


    /// Validates that only the given keys exists in the current dictionary bric; useful for forbidding additionalProperties
    public func prohibitExtraKeys<R: RawRepresentable where R.RawValue == String>(keys: R.Type) throws {
        guard case .obj(let dict) = self else { return try invalidType() }
        var errs: [ErrorType] = []
        for key in dict.keys {
            if keys.init(rawValue: key) == nil {
                errs.append(BracError.unrecognizedKey(key: key, path: []))
            }
        }
        if errs.count == 1 {
            throw errs[0]
        } else if errs.count > 1 {
            throw BracError.multipleErrors(errors: errs, path: [])
        }
    }

    // TODO: remove

    public func assertNoAdditionalProperties<R: RawRepresentable where R.RawValue == String>(keys: R.Type) throws {
        return try prohibitExtraKeys(keys)
    }

}

// MARK: BracLayer wrapper Brac


/// A BracLayer can wrap around some instances; it is used to allow brac'ing from an arbitrarily nested container types
/// This allows us to have a single handlers for multiple permutations of wrappers, such as
/// Array<String>, Optional<Array<Bool>>, Array<Optional<Bool>>, and Array<Optional<Set<CollectionOfOne<Int>>>>
public protocol BracLayer {
    /// The type that is being wrapped by this layer
    associatedtype BracSub

    /// Construct an instance of self by invoking the function on the given bric
    static func bracMap(bric: Bric, f: Bric throws -> BracSub) throws -> Self
}

public extension BracLayer where Self.BracSub : Bracable {
    /// Try to construct an instance of the wrapped type from the `Bric` parameter
    public static func brac(bric: Bric) throws -> Self {
        return try Self.bracMap(bric, f: Self.BracSub.brac)
    }
}

public extension BracLayer where Self.BracSub : BracLayer, Self.BracSub.BracSub : Bracable {
    /// Try to construct an instance of the twofold-wrapped type from the `Bric` parameter
    public static func brac(bric: Bric) throws -> Self {
        return try Self.bracMap(bric) {
            try Self.BracSub.bracMap($0, f: Self.BracSub.BracSub.brac)
        }
    }
}

public extension BracLayer where Self.BracSub : BracLayer, Self.BracSub.BracSub : BracLayer, Self.BracSub.BracSub.BracSub : Bracable {
    /// Try to construct an instance of the threefold-wrapped type from the `Bric` parameter
    public static func brac(bric: Bric) throws -> Self {
        return try Self.bracMap(bric) {
            try Self.BracSub.bracMap($0) {
                try Self.BracSub.BracSub.bracMap($0,
                    f: Self.BracSub.BracSub.BracSub.brac)
            }
        }
    }
}

public extension BracLayer where Self.BracSub : BracLayer, Self.BracSub.BracSub : BracLayer, Self.BracSub.BracSub.BracSub : BracLayer, Self.BracSub.BracSub.BracSub.BracSub : Bracable {
    /// Try to construct an instance of the fourfold-wrapped type from the `Bric` parameter
    public static func brac(bric: Bric) throws -> Self {
        return try Self.bracMap(bric) {
            try Self.BracSub.bracMap($0) {
                try Self.BracSub.BracSub.bracMap($0) {
                    try Self.BracSub.BracSub.BracSub.bracMap($0,
                        f: Self.BracSub.BracSub.BracSub.BracSub.brac)
                }
            }
        }
    }
}

public extension BracLayer where Self.BracSub : BracLayer, Self.BracSub.BracSub : BracLayer, Self.BracSub.BracSub.BracSub : BracLayer, Self.BracSub.BracSub.BracSub.BracSub : BracLayer, Self.BracSub.BracSub.BracSub.BracSub.BracSub : Bracable {
    /// Try to construct an instance of the fivefold-wrapped type from the `Bric` parameter
    public static func brac(bric: Bric) throws -> Self {
        return try Self.bracMap(bric) {
            try Self.BracSub.bracMap($0) {
                try Self.BracSub.BracSub.bracMap($0) {
                    try Self.BracSub.BracSub.BracSub.bracMap($0) {
                        try Self.BracSub.BracSub.BracSub.BracSub.bracMap($0,
                            f: Self.BracSub.BracSub.BracSub.BracSub.BracSub.brac)
                    }
                }
            }
        }
    }
}

extension Wrappable {
    /// Returns this wrapper around the bracMap, or returns `.None` if the parameter is `Bric.nul`
    public static func bracMap(bric: Bric, f: Bric throws -> Wrapped) throws -> Self {
        if case .nul = bric { return nil } // an optional is allowed to be nil
        return Self(try f(bric))
    }
}

#if !os(Linux) // sadly, this crashes the swift-DEVELOPMENT-SNAPSHOT-2016-02-25-a-ubuntu14.04 compiler
extension Optional : BracLayer {
    public typealias BracSub = Wrapped // inherits bracMap via Wrappable conformance
}
#endif

extension Indirect : BracLayer {
    public typealias BracSub = Wrapped // inherits bracMap via Wrappable conformance
}

extension RawRepresentable where RawValue : Bracable {

    /// Returns this RawRepresentable around the brac, or throws an error if the parameter cannot be used to create the RawRepresentable
    public static func brac(bric: Bric) throws -> Self {
        let rawValue = try RawValue.brac(bric)
        if let x = Self(rawValue: rawValue) {
            return x
        } else {
            return try bric.invalidRawValue(rawValue)
        }
    }

}

extension RangeReplaceableCollectionType {
    /// Returns this collection around the bracMaps, or throws an error if the parameter is not `Bric.arr`
    public static func bracMap(bric: Bric, f: Bric throws -> Generator.Element) throws -> Self {
        if case .arr(let arr) = bric {
            var ret = Self()
            for (i, x) in arr.enumerate() {
                ret.append(try bracIndex(i, f(x)))
            }
            return ret
        }
        return try bric.invalidType()
    }
}

extension Array : BracLayer {
    public typealias BracSub = Element // inherits bracMap via default RangeReplaceableCollectionType conformance
}

extension ArraySlice : BracLayer {
    public typealias BracSub = Element // inherits bracMap via default RangeReplaceableCollectionType conformance
}

extension ContiguousArray : BracLayer {
    public typealias BracSub = Element // inherits bracMap via default RangeReplaceableCollectionType conformance
}

extension CollectionOfOne : BracLayer {
    public typealias BracSub = Element

    public static func bracMap(bric: Bric, f: Bric throws -> BracSub) throws -> CollectionOfOne {
        if case .arr(let x) = bric {
            if x.count != 1 { throw BracError.invalidArrayLength(required: 1...1, actual: x.count, path: []) }
            return CollectionOfOne(try f(x[0]))
        }
        return try bric.invalidType()
    }
}

extension EmptyCollection : BracLayer {
    public typealias BracSub = Element

    public static func bracMap(bric: Bric, f: Bric throws -> BracSub) throws -> EmptyCollection {
        if case .arr(let x) = bric {
            // really kind of pointless: why would anyone mandate an array size zero?
            if x.count != 0 { throw BracError.invalidArrayLength(required: 0...0, actual: x.count, path: []) }
            return EmptyCollection()
        }
        return try bric.invalidType()
    }
}

extension NonEmptyCollection : BracLayer {
    public typealias BracSub = Element

    /// Returns this collection around the bracMaps, or throws an error if the parameter is not `Bric.arr` or the array does not have at least a single element
    public static func bracMap(bric: Bric, f: Bric throws -> Element) throws -> NonEmptyCollection {
        if case .arr(let arr) = bric {
            guard let first = arr.first else {
                throw BracError.invalidArrayLength(required: 1..<Int.max, actual: 0, path: [])
            }
            return try NonEmptyCollection(f(first), tail: Tail.bracMap(Bric.arr(Array(arr.dropFirst())), f: f))
        }
        return try bric.invalidType()
    }
}


extension Dictionary : BracLayer {
    public typealias BracSub = Value

    public static func bracMap(bric: Bric, f: Bric throws -> BracSub) throws -> Dictionary {
        if case .obj(let x) = bric {
            var d = Dictionary()
            for (k, v) in x {
                if let k = k as? Dictionary.Key {
                    d[k] = try f(v) // keys need to be Strings
                } else {
                    return try bric.invalidType()
                }
            }
            return d
        }
        return try bric.invalidType()
    }
}

extension Set : BracLayer {
    public typealias BracSub = Generator.Element

    public static func bracMap(bric: Bric, f: Bric throws -> BracSub) throws -> Set {
        if case .arr(let x) = bric { return Set(try x.map(f)) }
        return try bric.invalidType()
    }
}


// MARK: Numeric Brac



/// A BracableNumberConvertible is any numeric type that can be converted into a Double
public protocol BracableNumberConvertible : Bracable {
    /// Converts the given Double to the type, throwing an error on overflow
    static func fromBricNum(num: Double) throws -> Self
}

extension BracableNumberConvertible {
    /// Converts the given numeric bric to this numeric type, throwing an error if the Bric was not a number or overflows the bounds
    public static func brac(bric: Bric) throws -> Self {
        if case .num(let num) = bric {
            return try fromBricNum(num)
        } else {
            return try bric.invalidType()
        }
    }

    private static func overflow<T>(value: Double) throws -> T {
        throw BracError.numericOverflow(type: T.self, value: value, path: [])
    }
}


/// RawRepresentable Bric methods that enable an Double value to automatically bric & brac
extension Double : BracableNumberConvertible {
    public static func fromBricNum(num: Double) -> Double { return Double(num) }
}

/// RawRepresentable Bric methods that enable an Float value to automatically bric & brac
extension Float : BracableNumberConvertible {
    public static func fromBricNum(num: Double) -> Float { return Float(num) }
}

/// RawRepresentable Bric methods that enable an Int value to automatically bric & brac
extension Int : BracableNumberConvertible {
    public static func fromBricNum(num: Double) throws -> Int {
        return num >= Double(Int.max) || num <= Double(Int.min) ? try overflow(num) : Int(num)
    }
}

/// RawRepresentable Bric methods that enable an Int8 value to automatically bric & brac
extension Int8 : BracableNumberConvertible {
    public static func fromBricNum(num: Double) throws -> Int8 {
        return num >= Double(Int8.max) || num <= Double(Int8.min) ? try overflow(num) : Int8(num)
    }
}

/// RawRepresentable Bric methods that enable an Int16 value to automatically bric & brac
extension Int16 : BracableNumberConvertible {
    public static func fromBricNum(num: Double) throws -> Int16 {
        return num >= Double(Int16.max) || num <= Double(Int16.min) ? try overflow(num) : Int16(num)
    }
}

/// RawRepresentable Bric methods that enable an Int32 value to automatically bric & brac
extension Int32 : BracableNumberConvertible {
    public static func fromBricNum(num: Double) throws -> Int32 {
        return num >= Double(Int32.max) || num <= Double(Int32.min) ? try overflow(num) : Int32(num)
    }
}

/// RawRepresentable Bric methods that enable an Int64 value to automatically bric & brac
extension Int64 : BracableNumberConvertible {
    public static func fromBricNum(num: Double) throws -> Int64 {
        return num >= Double(Int64.max) || num <= Double(Int64.min) ? try overflow(num) : Int64(num)
    }
}

/// RawRepresentable Bric methods that enable an UInt value to automatically bric & brac
extension UInt : BracableNumberConvertible {
    public static func fromBricNum(num: Double) throws -> UInt {
        return num >= Double(UInt.max) || num <= Double(UInt.min) ? try overflow(num) : UInt(num)
    }
}

/// RawRepresentable Bric methods that enable an UInt8 value to automatically bric & brac
extension UInt8 : BracableNumberConvertible {
    public static func fromBricNum(num: Double) throws -> UInt8 {
        return num >= Double(UInt8.max) || num <= Double(UInt8.min) ? try overflow(num) : UInt8(num)
    }
}

/// RawRepresentable Bric methods that enable an UInt16 value to automatically bric & brac
extension UInt16 : BracableNumberConvertible {
    public static func fromBricNum(num: Double) throws -> UInt16 {
        return num >= Double(UInt16.max) || num <= Double(UInt16.min) ? try overflow(num) : UInt16(num)
    }
}

/// RawRepresentable Bric methods that enable an UInt32 value to automatically bric & brac
extension UInt32 : BracableNumberConvertible {
    public static func fromBricNum(num: Double) throws -> UInt32 {
        return num >= Double(UInt32.max) || num <= Double(UInt32.min) ? try overflow(num) : UInt32(num)
    }
}

/// RawRepresentable Bric methods that enable an UInt64 value to automatically bric & brac
extension UInt64 : BracableNumberConvertible {
    public static func fromBricNum(num: Double) throws -> UInt64 {
        return num >= Double(UInt64.max) || num <= Double(UInt64.min) ? try overflow(num) : UInt64(num)
    }
}



// MARK: Error Handling


public enum BracError: ErrorType, CustomDebugStringConvertible {
    /// A required key was not found in the given instance
    case missingRequiredKey(type: Any.Type, key: String, path: Bric.Pointer)

    /// The type of the given Bric was invalid
    case invalidType(type: Any.Type, actual: String, path: Bric.Pointer)

    /// The value of the RawValue could not be converted
    case invalidRawValue(type: Any.Type, value: Any, path: Bric.Pointer)

    /// The numeric value overflows the storage of the target number
    case numericOverflow(type: Any.Type, value: Double, path: Bric.Pointer)

    /// The array required a certain element but contained the wrong number
    case invalidArrayLength(required: Range<Int>, actual: Int, path: Bric.Pointer)

    /// The type needed to be an object
    case keyWithoutObject(key: String, path: Bric.Pointer)

    /// The enumeration value of the Bric could not be found
    case badEnum(bric: Bric, path: Bric.Pointer)

    /// An unrecognized key was found in the input dictionary
    case unrecognizedKey(key: String, path: Bric.Pointer)

    /// An unrecognized key was found in the input dictionary
    case shouldNotBracError(type: Any.Type, path: Bric.Pointer)

    /// Too many matches were found for the given schema
    case multipleMatches(type: Any.Type, path: Bric.Pointer)

    /// An unrecognized key was found in the input dictionary
    case multipleErrors(errors: Array<ErrorType>, path: Bric.Pointer)

    public var debugDescription: String {
        return describeErrors(space: 2)
    }

    public func describeErrors(space space: Int = 0) -> String {
        func atPath(path: Bric.Pointer) -> String {
            if path.isEmpty {
                return ""
            }

            let parts: [String] = path.map {
                switch $0 {
                case .key(let key): return key.replace("~", replacement: "~0").replace("/", replacement: "~1")
                case .index(let idx): return String(idx)
                }
            }

            return " at #/" + parts.joinWithSeparator("/")
        }

        switch self {
        case .missingRequiredKey(let type, let key, let path):
            return "Missing required property «\(key)» of type \(_typeName(type))\(atPath(path))"
        case .unrecognizedKey(let key, let path):
            return "Unrecognized key «\(key)»\(atPath(path))"
        case .invalidType(let type, let actual, let path):
            return "Invalid type\(atPath(path)): expected \(_typeName(type)), found \(_typeName(actual.dynamicType))"
        case .invalidRawValue(let type, let value, let path):
            return "Invalid value “\(value)”\(atPath(path)) of type \(_typeName(type))"
        case .numericOverflow(let type, let value, let path):
            return "Numeric overflow\(atPath(path)): \(_typeName(type)) cannot contain \(value)"
        case .invalidArrayLength(let range, let actual, let path):
            return "Invalid array length \(actual)\(atPath(path)) expected \(range)"
        case .keyWithoutObject(let key, let path):
            return "Object key «\(key)» requested in non-object\(atPath(path))"
        case .badEnum(let bric, let path):
            return "Invalid enum value “\(bric)”\(atPath(path))"
        case .shouldNotBracError(let type, let path):
            return "Data matches schema from 'not'\(atPath(path)) of type \(_typeName(type)))"
        case .multipleMatches(let type, let path):
            return "Too many matches\(atPath(path)): «\(_typeName(type))»"
        case .multipleErrors(let errs, let path):
            let nberrs: [String] = errs.filter({ !($0 is BracError) }).map({ String($0) })
            let brerrs: [String] = errs.map({ $0 as? BracError }).flatMap({ $0?.prependPath(path) }).map({ $0.describeErrors(space: space == 0 ? 0 : space + 2) })

            return "\(errs.count) errors\(atPath(path)):" + ([""] + nberrs + brerrs).joinWithSeparator("\n" + String(count: space, repeatedValue: Character(" ")))
        }
    }

    /// The RFC 6901 JSON Pointer path to where the error occurred in the source JSON
    public var path: Bric.Pointer {
        get {
            switch self {
            case .missingRequiredKey(_, _, let path): return path
            case .invalidType(_, _, let path): return path
            case .invalidRawValue(_, _, let path): return path
            case .numericOverflow(_, _, let path): return path
            case .invalidArrayLength( _, _, let path): return path
            case .keyWithoutObject(_, let path): return path
            case .badEnum(_, let path): return path
            case .unrecognizedKey(_, let path): return path
            case .shouldNotBracError(_, let path): return path
            case .multipleMatches(_, let path): return path
            case .multipleErrors(_, let path): return path
            }
        }

        set {
            switch self {
            case .missingRequiredKey(let type, let key, _):
                self = .missingRequiredKey(type: type, key: key, path: newValue)
            case .invalidType(let type, let actual, _):
                self = .invalidType(type: type, actual: actual, path: newValue)
            case .invalidRawValue(let type, let value, _):
                self = .invalidRawValue(type: type, value: value, path: newValue)
            case .numericOverflow(let type, let value, _):
                self = .numericOverflow(type: type, value: value, path: newValue)
            case .invalidArrayLength(let range, let actual, _):
                self = .invalidArrayLength(required: range, actual: actual, path: newValue)
            case .keyWithoutObject(let key, _):
                self = .keyWithoutObject(key: key, path: newValue)
            case .badEnum(let bric, _):
                self = .badEnum(bric: bric, path: newValue)
            case .unrecognizedKey(let key, _):
                self = .unrecognizedKey(key: key, path: newValue)
            case .shouldNotBracError(let type, _):
                self = .shouldNotBracError(type: type, path: newValue)
            case .multipleMatches(let count, _):
                self = .multipleMatches(type: count, path: newValue)
            case .multipleErrors(let errors, _):
                self = .multipleErrors(errors: errors, path: newValue)
            }
        }
    }

    /// Returns the same error with the given path prepended
    public func prependPath(prepend: Bric.Pointer) -> BracError {
        var err = self
        err.path = prepend + err.path
        return err
    }
}

public extension Bric {
    /// Utility function that simply throws an BracError.InvalidType
    public func invalidType<T>() throws -> T {
        switch self {
        case .nul: throw BracError.invalidType(type: T.self, actual: "nil", path: [])
        case .arr: throw BracError.invalidType(type: T.self, actual: "Array", path: [])
        case .obj: throw BracError.invalidType(type: T.self, actual: "Object", path: [])
        case .str: throw BracError.invalidType(type: T.self, actual: "String", path: [])
        case .num: throw BracError.invalidType(type: T.self, actual: "Double", path: [])
        case .bol: throw BracError.invalidType(type: T.self, actual: "Bool", path: [])
        }
    }

    /// Utility function that simply throws an BracError.InvalidType
    public func invalidRawValue<T>(value: Any) throws -> T {
        throw BracError.invalidRawValue(type: T.self, value: value, path: [])
    }

}


/// Invokes the given autoclosure and returns the value, pre-pending the given path to any BracError
private func bracPath<T, R: RawRepresentable where R.RawValue == String>(key: R, @autoclosure _ f: () throws -> T) throws -> T {
    do {
        return try f()
    } catch let err as BracError {
        throw err.prependPath([Bric.Ref(key: key)])
    } catch {
        throw error
    }
}

/// Invokes the given autoclosure and returns the value, pre-pending the given path to any BracError
private func bracIndex<T>(index: Int, @autoclosure _ f: () throws -> T) throws -> T {
    do {
        return try f()
    } catch let err as BracError {
        throw err.prependPath([Bric.Ref(index: index)])
    } catch {
        throw error
    }
}

/// Swaps the values of two Bricable & Bracable instances, throwing an error if any of the Brac fails.
///
/// - Requires: The two types be bric-serialization compatible.
///
/// - SeeAlso: `AnyObject`
public func bracSwap<B1, B2 where B1 : Bricable, B2: Bricable, B1: Bracable, B2: Bracable>(inout b1: B1, inout _ b2: B2) throws {
    let (brac1, brac2) = try (B1.brac(b2.bric()), B2.brac(b1.bric()))
    (b1, b2) = (brac1, brac2) // only perform the assignment if both the bracs succeed
}

/// Swaps the values of two optional Bricable & Bracable instances, throwing an error if any of the Brac fails
///
/// - Requires: The two types be bric-serialization compatible.
///
/// - SeeAlso: `AnyObject`
public func bracSwap<B1, B2 where B1 : Bricable, B2: Bricable, B1: Bracable, B2: Bracable>(inout b1: Optional<B1>, inout _ b2: Optional<B2>) throws {
    let (brac1, brac2) = try (B1.brac(b2.bric()), B2.brac(b1.bric()))
    (b1, b2) = (brac1, brac2) // only perform the assignment if both the bracs succeed
}


