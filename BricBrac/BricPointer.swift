//
//  BricPointer.swift
//  Bric-à-brac
//
//  Created by Marc Prud'hommeaux on 8/24/15.
//  Copyright © 2015 io.glimpse. All rights reserved.
//



/// Extension to Bric that supports JSON Pointers and JSON References
public extension Bric {
    public enum BricReferenceError : ErrorType, CustomDebugStringConvertible {
        case invalidReferenceURI(String)
        case unresolvableReferenceRoot(String)
        case referenceToNonObject(String)
        case objectKeyNotFound(String)
        case arrayIndexNotFound(String)

        public var debugDescription : String {
            switch self {
            case invalidReferenceURI(let x): return "InvalidReferenceURI: \(x)"
            case unresolvableReferenceRoot(let x): return "UnresolvableReferenceRoot: \(x)"
            case referenceToNonObject(let x): return "ReferenceToNonObject: \(x)"
            case objectKeyNotFound(let x): return "ObjectKeyNotFound: \(x)"
            case arrayIndexNotFound(let x): return "ArrayIndexNotFound: \(x)"
            }
        }
    }

    public typealias Pointer = Array<Bric.Ref>


    /// A reference in a JSON Pointer as per http://tools.ietf.org/html/draft-ietf-appsawg-json-pointer-04
    public enum Ref: CustomStringConvertible {
        case key(String)
        case index(Int)

        public init<R: RawRepresentable where R.RawValue == String>(key: R) {
            self = .key(key.rawValue)
        }

        public init(key: String) {
            self = .key(key)
        }

        public init<R: RawRepresentable where R.RawValue == Int>(index: R) {
            self = .index(index.rawValue)
        }

        public init(index: Int) {
            self = .index(index)
        }

        public var description: String {
            switch self {
            case .key(let key): return key
            case .index(let idx): return String(idx)
            }
        }
    }

    public func resolve() throws -> [String : Bric] {
        return try resolve([:], resolver: { ref in
            if ref == "" { return self }
            throw BricReferenceError.unresolvableReferenceRoot(ref)
        })
    }

    /// Returns a map of all references in the Bric
    /// See: <http://tools.ietf.org/html/draft-pbryan-zyp-json-ref-03>
    public func resolve(obj: [String : Bric] = [:], resolver: (String) throws -> Bric) throws -> [String : Bric] {
        var rmap = obj
        switch self {
        case .arr(let arr):
            for a in arr {
                rmap = try a.resolve(rmap, resolver: resolver)
            }
            return rmap

        case .obj(var dict):
            // { "$ref": "http://example.com/example.json#/foo/bar" }
            if case .Some(.str(let ref)) = dict["$ref"] {
                var parts = ref.characters.split(allowEmptySlices: true, isSeparator: { $0 == "#" }).map({ String($0) })
                if parts.count != 2 { throw BricReferenceError.unresolvableReferenceRoot(ref) }

                // resolve the absolute root: "http://example.com/example.json"
                rmap[ref] = try resolver(parts[0]).reference(parts[1])
            }

            // recurse into the sub-values and resolve all their values
            for (_, value) in dict {
                rmap = try value.resolve(rmap, resolver: resolver)
            }

            return rmap

        default:
            return rmap
        }
    }

    public func find(pointer: Pointer) throws -> Bric {
        var node: Bric = self
        for ref in pointer {
            if case .arr(let arr) = node {
                if case .index(let index) = ref {
                    if index < arr.count && index >= 0 {
                        node = arr[index]
                    } else {
                        throw BricReferenceError.arrayIndexNotFound("\(index)")
                    }
                } else {
                    throw BricReferenceError.arrayIndexNotFound("")
                }
            } else if case .obj(let obj) = node {
                if case .key(let key) = ref {
                    if let found = obj[key] {
                        node = found
                    } else {
                        throw BricReferenceError.objectKeyNotFound(key)
                    }
                } else {
                    throw BricReferenceError.objectKeyNotFound("")
                }
            } else {
                throw BricReferenceError.referenceToNonObject("")
            }
        }
        return node
    }

    /// Resolve the relative part "/foo/bar" as per http://tools.ietf.org/html/draft-ietf-appsawg-json-pointer-04
    public func reference(pointer: String) throws -> Bric {
        // Note: this logic is somewhat duplicated in find(), but when parsing a string we don't know if "1" means object key or array index until we resolve it against the Bric, so we cannot first parse it into a Bric.Pointer before we resolve it
        let frags = pointer.characters.split(allowEmptySlices: false, isSeparator: { $0 == "/" }).map({ String($0) })
        var node = self
        for var frag in frags {
            // funky JSON pointer escaping scheme (section 4)
            frag = frag.replace("~1", replacement: "/")
            frag = frag.replace("~0", replacement: "~")

            if case .arr(let arr) = node {
                if let index = Int(frag) where index < arr.count && index >= 0 {
                    node = arr[index]
                } else {
                    throw BricReferenceError.arrayIndexNotFound(frag)
                }
            } else if case .obj(let obj) = node {
                if let found = obj[frag] {
                    node = found
                } else {
                    throw BricReferenceError.objectKeyNotFound(frag)
                }
            }
        }

        // special case: trailing slashes will map to the "" key of an object
        if case .obj(let obj) = node where pointer.characters.last == "/" {
            node = obj[""] ?? node
        }

        return node
    }
}

extension Bric.Ref : Equatable { }

extension Bric.Ref : StringLiteralConvertible {
    public init(stringLiteral value: String) {
        self = .key(value)
    }

    public init(extendedGraphemeClusterLiteral value: StringLiteralType) {
        self = .key(value)
    }

    public init(unicodeScalarLiteral value: StringLiteralType) {
        self = .key(value)
    }
}

extension Bric.Ref : IntegerLiteralConvertible {
    public init(integerLiteral value: Int) {
        self = .index(value)
    }
}

public func == (br1: Bric.Ref, br2: Bric.Ref) -> Bool {
    switch (br1, br2) {
    case (.index(let i1), .index(let i2)): return i1 == i2
    case (.key(let k1), .key(let k2)): return k1 == k2
    default: return false
    }
}

extension Bric.Ref : Hashable {
    public var hashValue : Int {
        switch self {
        case .index(let index): return index.hashValue
        case .key(let key): return key.hashValue
        }
    }
}

public extension Bric {
    /// Updated the bric at the given existant path and sets the specified value
    @warn_unused_result public func update(value: Bric, pointer: Bric.Ref...) -> Bric {
        return alter { return $0 == pointer ? value : $1 }
    }

    /// Recursively visits each node in this Bric and performs the alteration specified by the mutator
    @warn_unused_result public func alter(mutator: (Pointer, Bric) throws -> Bric) rethrows -> Bric {
        return try alterPath([], mutator)
    }

    @warn_unused_result private func alterPath(path: Pointer = [], _ mutator: (Pointer, Bric) throws -> Bric) rethrows -> Bric {
        switch self {
        case .arr(var values):
            for (i, v) in values.enumerate() {
                let p = path + [.index(i)]
                values[i] = try mutator(p, v.alterPath(p, mutator))
            }
            return try mutator(path, .arr(values))
        case .obj(var dict):
            for (k, v) in dict {
                let p = path + [.key(k)]
                dict[k] = try mutator(p, v.alterPath(p, mutator))
            }
            return try mutator(path, .obj(dict))
        default:
            return try mutator(path, self)
        }
    }
}

public extension String {
    /// Returns a list of non-overlapping ranges of substring indices that equal the given find string in ascending order
    private func rangesOfString(find: String) -> [Range<Index>] {
        var ranges : [Range<String.Index>] = []
        let flen = find.startIndex.distanceTo(find.endIndex)
        let end = self.endIndex
        var i1 = self.startIndex
        var i2 = self.startIndex.advancedBy(flen-1, limit: end)
        let chars = self.characters

        while i2 != end {
            if String(chars[i1...i2]) == find {
                ranges.append(i1...i2)
                i1 = i1.advancedBy(flen, limit: end)
                i2 = i2.advancedBy(flen, limit: end)
            } else {
                i1 = i1.advancedBy(1, limit: end)
                i2 = i2.advancedBy(1, limit: end)
            }
        }
        return ranges
    }

    @warn_unused_result
    public func replace(find: String, replacement: String) -> String {
        var replaced = self
        for range in self.rangesOfString(find).reverse() {
            replaced.replaceRange(range, with: replacement)
        }
        return replaced
    }

    public func replace(find: Character, replacement: String) -> String {
        // when replacing a single character, optimize by doing a faster check
        if !self.characters.contains(find) {
            return self
        }

        return replace(String(find), replacement: replacement)
    }

    public mutating func replaceInPlace(find: String, replacement: String) {
        self = self.replace(find, replacement: replacement)
    }

    /// Quotes the given string with the specified quote string and the given escape
    public func enquote(c: String, escape: String? = "\\") -> String {
        if !c.isEmpty {
            if let escape = escape {
                return c + self.replace(c, replacement: escape + c) + c
            } else {
                return c + self + c
            }
        } else {
            return self
        }
    }
}
