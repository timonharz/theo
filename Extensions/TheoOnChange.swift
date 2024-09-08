//
//  File.swift
//  
//
//  Created by Timon Harz on 11.02.24.
//

import Foundation
import SwiftUI
import Combine
import UIKit

extension View {
    func onChange<Value>(of value: Value, perform action: @escaping (Value) -> Void) -> some View {
        self.modifier(ValueChangeObserverModifier(value: value, action: action))
    }
}

struct ValueChangeObserverModifier<Value>: ViewModifier {
    var value: Value
    var action: (Value) -> Void

    func body(content: Content) -> some View {
        content.onAppear {
            self.action(self.value)
        }
    }
}

extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        return Binding(
            get: { self.wrappedValue },
            set: { selection in
                self.wrappedValue = selection
                handler(selection)
        })
    }
}
