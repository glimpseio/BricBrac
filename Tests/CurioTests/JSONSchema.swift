import BricBrac

/// Core schema meta-schema
public typealias JSONSchemaOrBool = OneOf<JSONSchema>.Or<Bool>
/// Core schema meta-schema
public struct JSONSchema : Equatable, Hashable, Codable, KeyedCodable {
    public var comment: String?
    public var id: String?
    public var ref: String?
    public var schema: String?
    public var additionalItems: JSONSchemaOrBool?
    public var additionalProperties: JSONSchemaOrBool?
    public var allOf: SchemaArray?
    public var anyOf: SchemaArray?
    public var const: Const?
    public var contains: JSONSchemaOrBool?
    public var contentEncoding: String?
    public var contentMediaType: String?
    public var `default`: Default?
    public var definitions: Definitions?
    public var dependencies: Dependencies?
    public var description: String?
    public var `else`: JSONSchemaOrBool?
    public var `enum`: [EnumItem]?
    public var examples: [ExamplesItem]?
    public var exclusiveMaximum: Double?
    public var exclusiveMinimum: Double?
    public var format: String?
    public var `if`: JSONSchemaOrBool?
    public var items: ItemsChoice?
    public var maxItems: NonNegativeInteger?
    public var maxLength: NonNegativeInteger?
    public var maxProperties: NonNegativeInteger?
    public var maximum: Double?
    public var minItems: NonNegativeIntegerDefault0?
    public var minLength: NonNegativeIntegerDefault0?
    public var minProperties: NonNegativeIntegerDefault0?
    public var minimum: Double?
    public var multipleOf: Double?
    public var not: JSONSchemaOrBool?
    public var oneOf: SchemaArray?
    public var pattern: String?
    public var patternProperties: PatternProperties?
    public var properties: Properties?
    public var propertyNames: JSONSchemaOrBool?
    public var propertyOrder: [PropertyOrderItem]?
    public var readOnly: Bool?
    public var `required`: StringArray?
    public var then: JSONSchemaOrBool?
    public var title: String?
    public var type: TypeChoice?
    public var uniqueItems: Bool?
    public var writeOnly: Bool?
    public static let codingKeyPaths = (\Self.comment as KeyPath, \Self.id as KeyPath, \Self.ref as KeyPath, \Self.schema as KeyPath, \Self.additionalItems as KeyPath, \Self.additionalProperties as KeyPath, \Self.allOf as KeyPath, \Self.anyOf as KeyPath, \Self.const as KeyPath, \Self.contains as KeyPath, \Self.contentEncoding as KeyPath, \Self.contentMediaType as KeyPath, \Self.`default` as KeyPath, \Self.definitions as KeyPath, \Self.dependencies as KeyPath, \Self.description as KeyPath, \Self.`else` as KeyPath, \Self.`enum` as KeyPath, \Self.examples as KeyPath, \Self.exclusiveMaximum as KeyPath, \Self.exclusiveMinimum as KeyPath, \Self.format as KeyPath, \Self.`if` as KeyPath, \Self.items as KeyPath, \Self.maxItems as KeyPath, \Self.maxLength as KeyPath, \Self.maxProperties as KeyPath, \Self.maximum as KeyPath, \Self.minItems as KeyPath, \Self.minLength as KeyPath, \Self.minProperties as KeyPath, \Self.minimum as KeyPath, \Self.multipleOf as KeyPath, \Self.not as KeyPath, \Self.oneOf as KeyPath, \Self.pattern as KeyPath, \Self.patternProperties as KeyPath, \Self.properties as KeyPath, \Self.propertyNames as KeyPath, \Self.propertyOrder as KeyPath, \Self.readOnly as KeyPath, \Self.`required` as KeyPath, \Self.then as KeyPath, \Self.title as KeyPath, \Self.type as KeyPath, \Self.uniqueItems as KeyPath, \Self.writeOnly as KeyPath)
    public static let codableKeys: Dictionary<PartialKeyPath<Self>, CodingKeys> = [\Self.comment as KeyPath : CodingKeys.comment, \Self.id as KeyPath : CodingKeys.id, \Self.ref as KeyPath : CodingKeys.ref, \Self.schema as KeyPath : CodingKeys.schema, \Self.additionalItems as KeyPath : CodingKeys.additionalItems, \Self.additionalProperties as KeyPath : CodingKeys.additionalProperties, \Self.allOf as KeyPath : CodingKeys.allOf, \Self.anyOf as KeyPath : CodingKeys.anyOf, \Self.const as KeyPath : CodingKeys.const, \Self.contains as KeyPath : CodingKeys.contains, \Self.contentEncoding as KeyPath : CodingKeys.contentEncoding, \Self.contentMediaType as KeyPath : CodingKeys.contentMediaType, \Self.`default` as KeyPath : CodingKeys.`default`, \Self.definitions as KeyPath : CodingKeys.definitions, \Self.dependencies as KeyPath : CodingKeys.dependencies, \Self.description as KeyPath : CodingKeys.description, \Self.`else` as KeyPath : CodingKeys.`else`, \Self.`enum` as KeyPath : CodingKeys.`enum`, \Self.examples as KeyPath : CodingKeys.examples, \Self.exclusiveMaximum as KeyPath : CodingKeys.exclusiveMaximum, \Self.exclusiveMinimum as KeyPath : CodingKeys.exclusiveMinimum, \Self.format as KeyPath : CodingKeys.format, \Self.`if` as KeyPath : CodingKeys.`if`, \Self.items as KeyPath : CodingKeys.items, \Self.maxItems as KeyPath : CodingKeys.maxItems, \Self.maxLength as KeyPath : CodingKeys.maxLength, \Self.maxProperties as KeyPath : CodingKeys.maxProperties, \Self.maximum as KeyPath : CodingKeys.maximum, \Self.minItems as KeyPath : CodingKeys.minItems, \Self.minLength as KeyPath : CodingKeys.minLength, \Self.minProperties as KeyPath : CodingKeys.minProperties, \Self.minimum as KeyPath : CodingKeys.minimum, \Self.multipleOf as KeyPath : CodingKeys.multipleOf, \Self.not as KeyPath : CodingKeys.not, \Self.oneOf as KeyPath : CodingKeys.oneOf, \Self.pattern as KeyPath : CodingKeys.pattern, \Self.patternProperties as KeyPath : CodingKeys.patternProperties, \Self.properties as KeyPath : CodingKeys.properties, \Self.propertyNames as KeyPath : CodingKeys.propertyNames, \Self.propertyOrder as KeyPath : CodingKeys.propertyOrder, \Self.readOnly as KeyPath : CodingKeys.readOnly, \Self.`required` as KeyPath : CodingKeys.`required`, \Self.then as KeyPath : CodingKeys.then, \Self.title as KeyPath : CodingKeys.title, \Self.type as KeyPath : CodingKeys.type, \Self.uniqueItems as KeyPath : CodingKeys.uniqueItems, \Self.writeOnly as KeyPath : CodingKeys.writeOnly]

    public init(comment: String? = nil, id: String? = nil, ref: String? = nil, schema: String? = nil, additionalItems: JSONSchemaOrBool? = nil, additionalProperties: JSONSchemaOrBool? = nil, allOf: SchemaArray? = nil, anyOf: SchemaArray? = nil, const: Const? = nil, contains: JSONSchemaOrBool? = nil, contentEncoding: String? = nil, contentMediaType: String? = nil, `default`: Default? = nil, definitions: Definitions? = nil, dependencies: Dependencies? = nil, description: String? = nil, `else`: JSONSchemaOrBool? = nil, `enum`: [EnumItem]? = nil, examples: [ExamplesItem]? = nil, exclusiveMaximum: Double? = nil, exclusiveMinimum: Double? = nil, format: String? = nil, `if`: JSONSchemaOrBool? = nil, items: ItemsChoice? = nil, maxItems: NonNegativeInteger? = nil, maxLength: NonNegativeInteger? = nil, maxProperties: NonNegativeInteger? = nil, maximum: Double? = nil, minItems: NonNegativeIntegerDefault0? = nil, minLength: NonNegativeIntegerDefault0? = nil, minProperties: NonNegativeIntegerDefault0? = nil, minimum: Double? = nil, multipleOf: Double? = nil, not: JSONSchemaOrBool? = nil, oneOf: SchemaArray? = nil, pattern: String? = nil, patternProperties: PatternProperties? = nil, properties: Properties? = nil, propertyNames: JSONSchemaOrBool? = nil, propertyOrder: [PropertyOrderItem]? = nil, readOnly: Bool? = nil, `required`: StringArray? = nil, then: JSONSchemaOrBool? = nil, title: String? = nil, type: TypeChoice? = nil, uniqueItems: Bool? = nil, writeOnly: Bool? = nil) {
        self.comment = comment 
        self.id = id 
        self.ref = ref 
        self.schema = schema 
        self.additionalItems = additionalItems 
        self.additionalProperties = additionalProperties 
        self.allOf = allOf 
        self.anyOf = anyOf 
        self.const = const 
        self.contains = contains 
        self.contentEncoding = contentEncoding 
        self.contentMediaType = contentMediaType 
        self.`default` = `default` 
        self.definitions = definitions 
        self.dependencies = dependencies 
        self.description = description 
        self.`else` = `else` 
        self.`enum` = `enum` 
        self.examples = examples 
        self.exclusiveMaximum = exclusiveMaximum 
        self.exclusiveMinimum = exclusiveMinimum 
        self.format = format 
        self.`if` = `if` 
        self.items = items 
        self.maxItems = maxItems 
        self.maxLength = maxLength 
        self.maxProperties = maxProperties 
        self.maximum = maximum 
        self.minItems = minItems 
        self.minLength = minLength 
        self.minProperties = minProperties 
        self.minimum = minimum 
        self.multipleOf = multipleOf 
        self.not = not 
        self.oneOf = oneOf 
        self.pattern = pattern 
        self.patternProperties = patternProperties 
        self.properties = properties 
        self.propertyNames = propertyNames 
        self.propertyOrder = propertyOrder 
        self.readOnly = readOnly 
        self.`required` = `required` 
        self.then = then 
        self.title = title 
        self.type = type 
        self.uniqueItems = uniqueItems 
        self.writeOnly = writeOnly 
    }

    public init(from decoder: Decoder) throws {
        try decoder.forbidAdditionalProperties(notContainedIn: CodingKeys.allCases) 
        let values = try decoder.container(keyedBy: CodingKeys.self) 
        self.comment = try values.decodeOptional(String.self, forKey: .comment) 
        self.id = try values.decodeOptional(String.self, forKey: .id) 
        self.ref = try values.decodeOptional(String.self, forKey: .ref) 
        self.schema = try values.decodeOptional(String.self, forKey: .schema) 
        self.additionalItems = try values.decodeOptional(JSONSchemaOrBool.self, forKey: .additionalItems) 
        self.additionalProperties = try values.decodeOptional(JSONSchemaOrBool.self, forKey: .additionalProperties) 
        self.allOf = try values.decodeOptional(SchemaArray.self, forKey: .allOf) 
        self.anyOf = try values.decodeOptional(SchemaArray.self, forKey: .anyOf) 
        self.const = try values.decodeOptional(Const.self, forKey: .const) 
        self.contains = try values.decodeOptional(JSONSchemaOrBool.self, forKey: .contains) 
        self.contentEncoding = try values.decodeOptional(String.self, forKey: .contentEncoding) 
        self.contentMediaType = try values.decodeOptional(String.self, forKey: .contentMediaType) 
        self.`default` = try values.decodeOptional(Default.self, forKey: .`default`) 
        self.definitions = try values.decodeOptional(Definitions.self, forKey: .definitions) 
        self.dependencies = try values.decodeOptional(Dependencies.self, forKey: .dependencies) 
        self.description = try values.decodeOptional(String.self, forKey: .description) 
        self.`else` = try values.decodeOptional(JSONSchemaOrBool.self, forKey: .`else`) 
        self.`enum` = try values.decodeOptional([EnumItem].self, forKey: .`enum`) 
        self.examples = try values.decodeOptional([ExamplesItem].self, forKey: .examples) 
        self.exclusiveMaximum = try values.decodeOptional(Double.self, forKey: .exclusiveMaximum) 
        self.exclusiveMinimum = try values.decodeOptional(Double.self, forKey: .exclusiveMinimum) 
        self.format = try values.decodeOptional(String.self, forKey: .format) 
        self.`if` = try values.decodeOptional(JSONSchemaOrBool.self, forKey: .`if`) 
        self.items = try values.decodeOptional(ItemsChoice.self, forKey: .items) 
        self.maxItems = try values.decodeOptional(NonNegativeInteger.self, forKey: .maxItems) 
        self.maxLength = try values.decodeOptional(NonNegativeInteger.self, forKey: .maxLength) 
        self.maxProperties = try values.decodeOptional(NonNegativeInteger.self, forKey: .maxProperties) 
        self.maximum = try values.decodeOptional(Double.self, forKey: .maximum) 
        self.minItems = try values.decodeOptional(NonNegativeIntegerDefault0.self, forKey: .minItems) 
        self.minLength = try values.decodeOptional(NonNegativeIntegerDefault0.self, forKey: .minLength) 
        self.minProperties = try values.decodeOptional(NonNegativeIntegerDefault0.self, forKey: .minProperties) 
        self.minimum = try values.decodeOptional(Double.self, forKey: .minimum) 
        self.multipleOf = try values.decodeOptional(Double.self, forKey: .multipleOf) 
        self.not = try values.decodeOptional(JSONSchemaOrBool.self, forKey: .not) 
        self.oneOf = try values.decodeOptional(SchemaArray.self, forKey: .oneOf) 
        self.pattern = try values.decodeOptional(String.self, forKey: .pattern) 
        self.patternProperties = try values.decodeOptional(PatternProperties.self, forKey: .patternProperties) 
        self.properties = try values.decodeOptional(Properties.self, forKey: .properties) 
        self.propertyNames = try values.decodeOptional(JSONSchemaOrBool.self, forKey: .propertyNames) 
        self.propertyOrder = try values.decodeOptional([PropertyOrderItem].self, forKey: .propertyOrder) 
        self.readOnly = try values.decodeOptional(Bool.self, forKey: .readOnly) 
        self.`required` = try values.decodeOptional(StringArray.self, forKey: .`required`) 
        self.then = try values.decodeOptional(JSONSchemaOrBool.self, forKey: .then) 
        self.title = try values.decodeOptional(String.self, forKey: .title) 
        self.type = try values.decodeOptional(TypeChoice.self, forKey: .type) 
        self.uniqueItems = try values.decodeOptional(Bool.self, forKey: .uniqueItems) 
        self.writeOnly = try values.decodeOptional(Bool.self, forKey: .writeOnly) 
    }

    public typealias Const = Bric

    public typealias Default = Bric

    public typealias Definitions = Dictionary<String, DefinitionsValue>
    public typealias DefinitionsValue = JSONSchemaOrBool

    public typealias Dependencies = Dictionary<String, DependenciesValueChoice>
    public typealias DependenciesValueChoice = OneOf<JSONSchemaOrBool>.Or<StringArray>

    public typealias EnumItem = Bric

    public typealias ExamplesItem = Bric

    public typealias ItemsChoice = OneOf<JSONSchemaOrBool>.Or<SchemaArray>

    public typealias PatternProperties = Dictionary<String, PatternPropertiesValue>
    public typealias PatternPropertiesValue = JSONSchemaOrBool

    public typealias Properties = Dictionary<String, PropertiesValue>
    public typealias PropertiesValue = JSONSchemaOrBool

    public typealias PropertyOrderItem = String

    public typealias TypeChoice = OneOrMany<SimpleTypes>

    public enum CodingKeys : String, CodingKey, Hashable, Codable, CaseIterable {
        case comment = "$comment"
        case id = "$id"
        case ref = "$ref"
        case schema = "$schema"
        case additionalItems
        case additionalProperties
        case allOf
        case anyOf
        case const
        case contains
        case contentEncoding
        case contentMediaType
        case `default`
        case definitions
        case dependencies
        case description
        case `else`
        case `enum`
        case examples
        case exclusiveMaximum
        case exclusiveMinimum
        case format
        case `if`
        case items
        case maxItems
        case maxLength
        case maxProperties
        case maximum
        case minItems
        case minLength
        case minProperties
        case minimum
        case multipleOf
        case not
        case oneOf
        case pattern
        case patternProperties
        case properties
        case propertyNames
        case propertyOrder
        case readOnly
        case `required`
        case then
        case title
        case type
        case uniqueItems
        case writeOnly

        public typealias CodingOwner = JSONSchema
    }
}

public typealias NonNegativeInteger = Int

public typealias NonNegativeIntegerDefault0 = NonNegativeIntegerDefault0Types.Sum
public enum NonNegativeIntegerDefault0Types {

    public typealias P1 = Bric

    public typealias Sum = AllOf2<NonNegativeInteger, P1>
}

public typealias SchemaArray = [JSONSchemaOrBool]

public typealias StringArray = [String]

public enum SimpleTypes : String, Equatable, Hashable, Codable, CaseIterable {
    case array
    case boolean
    case integer
    case null
    case number
    case object
    case string
}