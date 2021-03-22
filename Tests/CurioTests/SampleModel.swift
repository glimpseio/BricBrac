import BricBrac

public struct SampleModel : Equatable, Hashable, Codable, KeyedCodable {
    public var allOfField: AllOfField
    public var anyOfField: AnyOfFieldChoice
    public var oneOfField: OneOfFieldChoice
    /// Should not escape keyword arguments
    public var keywordFields: KeywordFields?
    public var list: [ListItem]?
    public var nested1: Nested1?
    /// Should generate a simple OneOf enum
    public var simpleOneOf: SimpleOneOfChoice?
    public static let codingKeyPaths = (\Self.allOfField as KeyPath, \Self.anyOfField as KeyPath, \Self.oneOfField as KeyPath, \Self.keywordFields as KeyPath, \Self.list as KeyPath, \Self.nested1 as KeyPath, \Self.simpleOneOf as KeyPath)
    public static let codableKeys: Dictionary<PartialKeyPath<Self>, CodingKeys> = [\Self.allOfField as KeyPath : CodingKeys.allOfField, \Self.anyOfField as KeyPath : CodingKeys.anyOfField, \Self.oneOfField as KeyPath : CodingKeys.oneOfField, \Self.keywordFields as KeyPath : CodingKeys.keywordFields, \Self.list as KeyPath : CodingKeys.list, \Self.nested1 as KeyPath : CodingKeys.nested1, \Self.simpleOneOf as KeyPath : CodingKeys.simpleOneOf]

    public init(allOfField: AllOfField, anyOfField: AnyOfFieldChoice, oneOfField: OneOfFieldChoice, keywordFields: KeywordFields? = nil, list: [ListItem]? = nil, nested1: Nested1? = nil, simpleOneOf: SimpleOneOfChoice? = nil) {
        self.allOfField = allOfField 
        self.anyOfField = anyOfField 
        self.oneOfField = oneOfField 
        self.keywordFields = keywordFields 
        self.list = list 
        self.nested1 = nested1 
        self.simpleOneOf = simpleOneOf 
    }

    public init(from decoder: Decoder) throws {
        try decoder.forbidAdditionalProperties(notContainedIn: CodingKeys.allCases) 
        let values = try decoder.container(keyedBy: CodingKeys.self) 
        self.allOfField = try values.decode(AllOfField.self, forKey: .allOfField) 
        self.anyOfField = try values.decode(AnyOfFieldChoice.self, forKey: .anyOfField) 
        self.oneOfField = try values.decode(OneOfFieldChoice.self, forKey: .oneOfField) 
        self.keywordFields = try values.decodeOptional(KeywordFields.self, forKey: .keywordFields) 
        self.list = try values.decodeOptional([ListItem].self, forKey: .list) 
        self.nested1 = try values.decodeOptional(Nested1.self, forKey: .nested1) 
        self.simpleOneOf = try values.decodeOptional(SimpleOneOfChoice.self, forKey: .simpleOneOf) 
    }

    public typealias AllOfField = AllOfFieldTypes.Sum
    public enum AllOfFieldTypes {

        public typealias Sum = AllOf2<FirstAll, SecondAll>

        /// FirstAll
        public struct FirstAll : Equatable, Hashable, Codable, KeyedCodable {
            public var a1: Int
            public var a2: String
            public static let codingKeyPaths = (\Self.a1 as KeyPath, \Self.a2 as KeyPath)
            public static let codableKeys: Dictionary<PartialKeyPath<Self>, CodingKeys> = [\Self.a1 as KeyPath : CodingKeys.a1, \Self.a2 as KeyPath : CodingKeys.a2]

            public init(a1: Int, a2: String) {
                self.a1 = a1 
                self.a2 = a2 
            }

            public init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self) 
                self.a1 = try values.decode(Int.self, forKey: .a1) 
                self.a2 = try values.decode(String.self, forKey: .a2) 
            }

            public enum CodingKeys : String, CodingKey, Hashable, Codable, CaseIterable {
                case a1
                case a2
                public var keyDescription: String? {
                    switch self {
                    case .a1: return nil
                    case .a2: return nil
                     } 
                }

                public typealias CodingOwner = FirstAll
            }
        }

        /// SecondAll
        public struct SecondAll : Equatable, Hashable, Codable, KeyedCodable {
            public var a3: Bool
            public var a4: Double
            public static let codingKeyPaths = (\Self.a3 as KeyPath, \Self.a4 as KeyPath)
            public static let codableKeys: Dictionary<PartialKeyPath<Self>, CodingKeys> = [\Self.a3 as KeyPath : CodingKeys.a3, \Self.a4 as KeyPath : CodingKeys.a4]

            public init(a3: Bool, a4: Double) {
                self.a3 = a3 
                self.a4 = a4 
            }

            public init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self) 
                self.a3 = try values.decode(Bool.self, forKey: .a3) 
                self.a4 = try values.decode(Double.self, forKey: .a4) 
            }

            public enum CodingKeys : String, CodingKey, Hashable, Codable, CaseIterable {
                case a3
                case a4
                public var keyDescription: String? {
                    switch self {
                    case .a3: return nil
                    case .a4: return nil
                     } 
                }

                public typealias CodingOwner = SecondAll
            }
        }
    }

    public typealias AnyOfFieldChoice = AnyOfFieldTypes.Choice
    public enum AnyOfFieldTypes {

        public typealias Choice = OneOf<FirstAny>.Or<SecondAny>

        /// FirstAny
        public struct FirstAny : Equatable, Hashable, Codable, KeyedCodable {
            public var b1: Int
            public var b2: String
            public static let codingKeyPaths = (\Self.b1 as KeyPath, \Self.b2 as KeyPath)
            public static let codableKeys: Dictionary<PartialKeyPath<Self>, CodingKeys> = [\Self.b1 as KeyPath : CodingKeys.b1, \Self.b2 as KeyPath : CodingKeys.b2]

            public init(b1: Int, b2: String) {
                self.b1 = b1 
                self.b2 = b2 
            }

            public init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self) 
                self.b1 = try values.decode(Int.self, forKey: .b1) 
                self.b2 = try values.decode(String.self, forKey: .b2) 
            }

            public enum CodingKeys : String, CodingKey, Hashable, Codable, CaseIterable {
                case b1
                case b2
                public var keyDescription: String? {
                    switch self {
                    case .b1: return nil
                    case .b2: return nil
                     } 
                }

                public typealias CodingOwner = FirstAny
            }
        }

        /// SecondAny
        public struct SecondAny : Equatable, Hashable, Codable, KeyedCodable {
            public var b3: Bool
            public var b4: Double
            public static let codingKeyPaths = (\Self.b3 as KeyPath, \Self.b4 as KeyPath)
            public static let codableKeys: Dictionary<PartialKeyPath<Self>, CodingKeys> = [\Self.b3 as KeyPath : CodingKeys.b3, \Self.b4 as KeyPath : CodingKeys.b4]

            public init(b3: Bool, b4: Double) {
                self.b3 = b3 
                self.b4 = b4 
            }

            public init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self) 
                self.b3 = try values.decode(Bool.self, forKey: .b3) 
                self.b4 = try values.decode(Double.self, forKey: .b4) 
            }

            public enum CodingKeys : String, CodingKey, Hashable, Codable, CaseIterable {
                case b3
                case b4
                public var keyDescription: String? {
                    switch self {
                    case .b3: return nil
                    case .b4: return nil
                     } 
                }

                public typealias CodingOwner = SecondAny
            }
        }
    }

    public typealias OneOfFieldChoice = OneOfFieldTypes.Choice
    public enum OneOfFieldTypes {

        public typealias Choice = OneOf<FirstOne>.Or<SecondOne>

        /// FirstOne
        public struct FirstOne : Equatable, Hashable, Codable, KeyedCodable {
            public var c1: Int
            public var c2: String
            public static let codingKeyPaths = (\Self.c1 as KeyPath, \Self.c2 as KeyPath)
            public static let codableKeys: Dictionary<PartialKeyPath<Self>, CodingKeys> = [\Self.c1 as KeyPath : CodingKeys.c1, \Self.c2 as KeyPath : CodingKeys.c2]

            public init(c1: Int, c2: String) {
                self.c1 = c1 
                self.c2 = c2 
            }

            public init(from decoder: Decoder) throws {
                try decoder.forbidAdditionalProperties(notContainedIn: CodingKeys.allCases) 
                let values = try decoder.container(keyedBy: CodingKeys.self) 
                self.c1 = try values.decode(Int.self, forKey: .c1) 
                self.c2 = try values.decode(String.self, forKey: .c2) 
            }

            public enum CodingKeys : String, CodingKey, Hashable, Codable, CaseIterable {
                case c1
                case c2
                public var keyDescription: String? {
                    switch self {
                    case .c1: return nil
                    case .c2: return nil
                     } 
                }

                public typealias CodingOwner = FirstOne
            }
        }

        /// SecondOne
        public struct SecondOne : Equatable, Hashable, Codable, KeyedCodable {
            public var c3: Bool
            public var c4: Double
            public static let codingKeyPaths = (\Self.c3 as KeyPath, \Self.c4 as KeyPath)
            public static let codableKeys: Dictionary<PartialKeyPath<Self>, CodingKeys> = [\Self.c3 as KeyPath : CodingKeys.c3, \Self.c4 as KeyPath : CodingKeys.c4]

            public init(c3: Bool, c4: Double) {
                self.c3 = c3 
                self.c4 = c4 
            }

            public init(from decoder: Decoder) throws {
                try decoder.forbidAdditionalProperties(notContainedIn: CodingKeys.allCases) 
                let values = try decoder.container(keyedBy: CodingKeys.self) 
                self.c3 = try values.decode(Bool.self, forKey: .c3) 
                self.c4 = try values.decode(Double.self, forKey: .c4) 
            }

            public enum CodingKeys : String, CodingKey, Hashable, Codable, CaseIterable {
                case c3
                case c4
                public var keyDescription: String? {
                    switch self {
                    case .c3: return nil
                    case .c4: return nil
                     } 
                }

                public typealias CodingOwner = SecondOne
            }
        }
    }

    /// Should generate a simple OneOf enum
    public typealias SimpleOneOfChoice = OneOf<String>.Or<Double>

    public enum CodingKeys : String, CodingKey, Hashable, Codable, CaseIterable {
        case allOfField
        case anyOfField
        case oneOfField
        case keywordFields
        case list
        case nested1
        case simpleOneOf
        public var keyDescription: String? {
            switch self {
            case .allOfField: return nil
            case .anyOfField: return nil
            case .oneOfField: return nil
            case .keywordFields: return "Should not escape keyword arguments"
            case .list: return nil
            case .nested1: return nil
            case .simpleOneOf: return "Should generate a simple OneOf enum"
             } 
        }

        public typealias CodingOwner = SampleModel
    }

    /// Should not escape keyword arguments
    public struct KeywordFields : Equatable, Hashable, Codable, KeyedCodable {
        public var `case`: String?
        public var `for`: String?
        public var `in`: String?
        public var `inout`: String?
        public var `let`: String?
        public var `var`: String?
        public var `while`: String?
        public static let codingKeyPaths = (\Self.`case` as KeyPath, \Self.`for` as KeyPath, \Self.`in` as KeyPath, \Self.`inout` as KeyPath, \Self.`let` as KeyPath, \Self.`var` as KeyPath, \Self.`while` as KeyPath)
        public static let codableKeys: Dictionary<PartialKeyPath<Self>, CodingKeys> = [\Self.`case` as KeyPath : CodingKeys.`case`, \Self.`for` as KeyPath : CodingKeys.`for`, \Self.`in` as KeyPath : CodingKeys.`in`, \Self.`inout` as KeyPath : CodingKeys.`inout`, \Self.`let` as KeyPath : CodingKeys.`let`, \Self.`var` as KeyPath : CodingKeys.`var`, \Self.`while` as KeyPath : CodingKeys.`while`]

        public init(`case`: String? = nil, `for`: String? = nil, `in`: String? = nil, `inout`: String? = nil, `let`: String? = nil, `var`: String? = nil, `while`: String? = nil) {
            self.`case` = `case` 
            self.`for` = `for` 
            self.`in` = `in` 
            self.`inout` = `inout` 
            self.`let` = `let` 
            self.`var` = `var` 
            self.`while` = `while` 
        }

        public init(from decoder: Decoder) throws {
            try decoder.forbidAdditionalProperties(notContainedIn: CodingKeys.allCases) 
            let values = try decoder.container(keyedBy: CodingKeys.self) 
            self.`case` = try values.decodeOptional(String.self, forKey: .`case`) 
            self.`for` = try values.decodeOptional(String.self, forKey: .`for`) 
            self.`in` = try values.decodeOptional(String.self, forKey: .`in`) 
            self.`inout` = try values.decodeOptional(String.self, forKey: .`inout`) 
            self.`let` = try values.decodeOptional(String.self, forKey: .`let`) 
            self.`var` = try values.decodeOptional(String.self, forKey: .`var`) 
            self.`while` = try values.decodeOptional(String.self, forKey: .`while`) 
        }

        public enum CodingKeys : String, CodingKey, Hashable, Codable, CaseIterable {
            case `case`
            case `for`
            case `in`
            case `inout`
            case `let`
            case `var`
            case `while`
            public var keyDescription: String? {
                switch self {
                case .`case`: return nil
                case .`for`: return nil
                case .`in`: return nil
                case .`inout`: return nil
                case .`let`: return nil
                case .`var`: return nil
                case .`while`: return nil
                 } 
            }

            public typealias CodingOwner = KeywordFields
        }
    }

    public struct ListItem : Equatable, Hashable, Codable, KeyedCodable {
        public var prop: LiteralValue
        public static let codingKeyPaths = (\Self.prop as KeyPath)
        public static let codableKeys: Dictionary<PartialKeyPath<Self>, CodingKeys> = [\Self.prop as KeyPath : CodingKeys.prop]

        public init(prop: LiteralValue = .value) {
            self.prop = prop 
        }

        public init(from decoder: Decoder) throws {
            try decoder.forbidAdditionalProperties(notContainedIn: CodingKeys.allCases) 
            let values = try decoder.container(keyedBy: CodingKeys.self) 
            self.prop = try values.decode(LiteralValue.self, forKey: .prop) 
        }

        public enum CodingKeys : String, CodingKey, Hashable, Codable, CaseIterable {
            case prop
            public var keyDescription: String? {
                switch self {
                case .prop: return nil
                 } 
            }

            public typealias CodingOwner = ListItem
        }

        public enum LiteralValue : String, Equatable, Hashable, Codable, CaseIterable {
            case value
        }
    }

    public struct Nested1 : Equatable, Hashable, Codable, KeyedCodable {
        public var nested2: Nested2
        public static let codingKeyPaths = (\Self.nested2 as KeyPath)
        public static let codableKeys: Dictionary<PartialKeyPath<Self>, CodingKeys> = [\Self.nested2 as KeyPath : CodingKeys.nested2]

        public init(nested2: Nested2) {
            self.nested2 = nested2 
        }

        public init(from decoder: Decoder) throws {
            try decoder.forbidAdditionalProperties(notContainedIn: CodingKeys.allCases) 
            let values = try decoder.container(keyedBy: CodingKeys.self) 
            self.nested2 = try values.decode(Nested2.self, forKey: .nested2) 
        }

        public enum CodingKeys : String, CodingKey, Hashable, Codable, CaseIterable {
            case nested2
            public var keyDescription: String? {
                switch self {
                case .nested2: return nil
                 } 
            }

            public typealias CodingOwner = Nested1
        }

        public struct Nested2 : Equatable, Hashable, Codable, KeyedCodable {
            public var nested3: Nested3
            public static let codingKeyPaths = (\Self.nested3 as KeyPath)
            public static let codableKeys: Dictionary<PartialKeyPath<Self>, CodingKeys> = [\Self.nested3 as KeyPath : CodingKeys.nested3]

            public init(nested3: Nested3) {
                self.nested3 = nested3 
            }

            public init(from decoder: Decoder) throws {
                try decoder.forbidAdditionalProperties(notContainedIn: CodingKeys.allCases) 
                let values = try decoder.container(keyedBy: CodingKeys.self) 
                self.nested3 = try values.decode(Nested3.self, forKey: .nested3) 
            }

            public enum CodingKeys : String, CodingKey, Hashable, Codable, CaseIterable {
                case nested3
                public var keyDescription: String? {
                    switch self {
                    case .nested3: return nil
                     } 
                }

                public typealias CodingOwner = Nested2
            }

            public struct Nested3 : Equatable, Hashable, Codable, KeyedCodable {
                public var nested4: Nested4
                public static let codingKeyPaths = (\Self.nested4 as KeyPath)
                public static let codableKeys: Dictionary<PartialKeyPath<Self>, CodingKeys> = [\Self.nested4 as KeyPath : CodingKeys.nested4]

                public init(nested4: Nested4) {
                    self.nested4 = nested4 
                }

                public init(from decoder: Decoder) throws {
                    try decoder.forbidAdditionalProperties(notContainedIn: CodingKeys.allCases) 
                    let values = try decoder.container(keyedBy: CodingKeys.self) 
                    self.nested4 = try values.decode(Nested4.self, forKey: .nested4) 
                }

                public enum CodingKeys : String, CodingKey, Hashable, Codable, CaseIterable {
                    case nested4
                    public var keyDescription: String? {
                        switch self {
                        case .nested4: return nil
                         } 
                    }

                    public typealias CodingOwner = Nested3
                }

                public struct Nested4 : Equatable, Hashable, Codable, KeyedCodable {
                    public var nested5: Nested5
                    public static let codingKeyPaths = (\Self.nested5 as KeyPath)
                    public static let codableKeys: Dictionary<PartialKeyPath<Self>, CodingKeys> = [\Self.nested5 as KeyPath : CodingKeys.nested5]

                    public init(nested5: Nested5) {
                        self.nested5 = nested5 
                    }

                    public init(from decoder: Decoder) throws {
                        try decoder.forbidAdditionalProperties(notContainedIn: CodingKeys.allCases) 
                        let values = try decoder.container(keyedBy: CodingKeys.self) 
                        self.nested5 = try values.decode(Nested5.self, forKey: .nested5) 
                    }

                    public enum CodingKeys : String, CodingKey, Hashable, Codable, CaseIterable {
                        case nested5
                        public var keyDescription: String? {
                            switch self {
                            case .nested5: return nil
                             } 
                        }

                        public typealias CodingOwner = Nested4
                    }

                    public struct Nested5 : Equatable, Hashable, Codable, KeyedCodable {
                        public var single: LiteralValue
                        public static let codingKeyPaths = (\Self.single as KeyPath)
                        public static let codableKeys: Dictionary<PartialKeyPath<Self>, CodingKeys> = [\Self.single as KeyPath : CodingKeys.single]

                        public init(single: LiteralValue = .value) {
                            self.single = single 
                        }

                        public init(from decoder: Decoder) throws {
                            try decoder.forbidAdditionalProperties(notContainedIn: CodingKeys.allCases) 
                            let values = try decoder.container(keyedBy: CodingKeys.self) 
                            self.single = try values.decode(LiteralValue.self, forKey: .single) 
                        }

                        public enum CodingKeys : String, CodingKey, Hashable, Codable, CaseIterable {
                            case single
                            public var keyDescription: String? {
                                switch self {
                                case .single: return nil
                                 } 
                            }

                            public typealias CodingOwner = Nested5
                        }

                        public enum LiteralValue : String, Equatable, Hashable, Codable, CaseIterable {
                            case value
                        }
                    }
                }
            }
        }
    }
}
