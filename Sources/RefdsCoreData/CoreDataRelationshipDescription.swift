import CoreData

public struct CoreDataRelationshipDescription {
    public static func relationship(
        name: String,
        destination: String,
        optional: Bool = true,
        toMany: Bool = false,
        deleteRule: NSDeleteRule = .nullifyDeleteRule,
        inverse: String? = nil,
        ordered: Bool = false
    ) -> CoreDataRelationshipDescription {
        let maxCount = toMany ? 0 : 1
        return CoreDataRelationshipDescription(
            name: name,
            destination: destination,
            optional: optional,
            maxCount: maxCount,
            minCount: 0,
            deleteRule: deleteRule,
            inverse: inverse,
            ordered: ordered
        )
    }
    
    public var name: String
    public var destination: String
    public var optional: Bool
    public var maxCount: Int
    public var minCount: Int
    public var deleteRule: NSDeleteRule
    public var inverse: String?
    public var ordered: Bool
}

extension CoreDataRelationshipDescription {
    public static func relationship<Root, Value, InverseRoot, InverseValue>(
        _ keyPath: KeyPath<Root, Value>,
        inverse: KeyPath<InverseRoot, InverseValue>,
        deleteRule: NSDeleteRule = .nullifyDeleteRule
    ) -> CoreDataRelationshipDescription where Root: NSManagedObject, InverseRoot: NSManagedObject {
        assert(keyPath.destinationType is NSManagedObject.Type)
        assert(inverse.destinationType is NSManagedObject.Type)
        
        return relationship(
            name: keyPath.stringValue,
            destination: "\(keyPath.destinationType)",
            optional: keyPath.isOptional,
            toMany: keyPath.isToMany,
            deleteRule: deleteRule,
            inverse: inverse.stringValue
        )
    }
    
    public static func relationship<Root, Value>(
        _ keyPath: KeyPath<Root, Value>,
        deleteRule: NSDeleteRule = .nullifyDeleteRule
    ) -> CoreDataRelationshipDescription where Root: NSManagedObject {
        assert(keyPath.destinationType is NSManagedObject.Type)
        return relationship(
            name: keyPath.stringValue,
            destination: "\(keyPath.destinationType)",
            optional: keyPath.isOptional,
            toMany: keyPath.isToMany,
            deleteRule: deleteRule,
            inverse: nil
        )
    }
}
