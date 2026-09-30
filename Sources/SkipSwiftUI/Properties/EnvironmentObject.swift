// Copyright 2026 Skip
// SPDX-License-Identifier: MPL-2.0
import SkipBridge
import SkipUI

@dynamicMemberLookup
@propertyWrapper public struct EnvironmentObject<ObjectType> : DynamicProperty where ObjectType : AnyObject {
    private let valueBox: Box<Box<ObjectType>?> = Box(nil)

    /// Initializes a new instance of the `EnvironmentObject` property wrapper.
    public init() {
        self.key = EnvironmentValues.key(forEnvironmentObject: ObjectType.self)
    }

    public var wrappedValue: ObjectType {
        return valueBox.value!.value
    }

    public var projectedValue: Self {
        return self
    }

    public let key: String

    /// Returns a binding for the specified writable property on the environment object.
    ///
    /// - Parameter keyPath: The writable key path to bind.
    /// - Returns: A binding to the specified property.
    public subscript<Subject>(dynamicMember keyPath: ReferenceWritableKeyPath<ObjectType, Subject>) -> Binding<Subject> {
        return Binding<Subject>(
            get: { wrappedValue[keyPath: keyPath] },
            set: { wrappedValue[keyPath: keyPath] = $0 }
        )
    }

    /// Synchronizes the environment support value from the bridged view tree.
    ///
    /// - Parameter support: The bridge support object containing the environment object value.
    public func Java_syncEnvironmentSupport(_ support: EnvironmentSupport?) {
        if let support {
            let valueHolder = support.valueHolder
            if valueHolder != SwiftObjectNil {
                valueBox.value = valueHolder.pointee()!
            }
        }
    }
}
