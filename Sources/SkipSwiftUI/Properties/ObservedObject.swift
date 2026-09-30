// Copyright 2026 Skip
// SPDX-License-Identifier: MPL-2.0

@dynamicMemberLookup
@propertyWrapper public struct ObservedObject<ObjectType> where ObjectType : AnyObject {
    public var wrappedValue: ObjectType

    /// Initializes a new instance of the `ObservedObject` property wrapper.
    ///
    /// - Parameter wrappedValue: The object observed by the wrapper.
    public init(wrappedValue: ObjectType) {
        self.wrappedValue = wrappedValue
    }

    public var projectedValue: ObservedObject<ObjectType> {
        return self
    }

    /// Returns a binding for the specified writable property on the observed object.
    ///
    /// - Parameter keyPath: The writable key path to bind.
    /// - Returns: A binding to the specified property.
    public subscript<Subject>(dynamicMember keyPath: ReferenceWritableKeyPath<ObjectType, Subject>) -> Binding<Subject> {
        return Binding<Subject>(
            get: { wrappedValue[keyPath: keyPath] },
            set: { wrappedValue[keyPath: keyPath] = $0 }
        )
    }
}

public typealias StateObject<T> = State<T>
