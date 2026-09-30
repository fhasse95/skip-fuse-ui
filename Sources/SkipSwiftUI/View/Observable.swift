// Copyright 2026 Skip
// SPDX-License-Identifier: MPL-2.0
import SkipUI

#if canImport(Combine)
import Combine
#elseif canImport(SkipModel)
import SkipModel
#endif

extension View {

    /// Subscribes to a publisher and runs an action when the publisher emits a value.
    ///
    /// - Parameters:
    ///   - publisher: The publisher that emits values for the view.
    ///   - action: The action to run for each emitted value.
    /// - Returns: The view with the subscription attached.
    nonisolated public func onReceive<P>(
        _ publisher: P,
        perform action: @escaping (P.Output) -> Void
    ) -> some View where P: Publisher {
        ModifierView(target: self) {
            $0.Java_viewOrEmpty.onReceive(publisher, perform: action)
        }
    }
}
