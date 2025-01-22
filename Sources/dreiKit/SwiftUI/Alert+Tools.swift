//
//  Alert+Tools.swift
//  dreiKit
//
//  Created by Laila Becker on 22.01.2025.
//

import SwiftUI

public extension View {
    func alert<T, Message, Actions>(presenting: Binding<T?>,
                                    title: (T) -> LocalizedStringKey,
                                    @ViewBuilder message: (T) -> Message,
                                    @ViewBuilder actions: (T) -> Actions) -> some View where Actions: View, Message: View {
        let isPresentedBinding = Binding(get: { presenting.wrappedValue != nil }, set: { newValue in
            guard !newValue else {
                return
            }

            presenting.wrappedValue = nil
        })

        return self
            .alert(presenting.wrappedValue.map { title($0) } ?? "",
                   isPresented: isPresentedBinding,
                   presenting: presenting.wrappedValue,
                   actions: actions,
                   message: message)
    }

    func alert<T, Message, Actions>(presenting: Binding<T?>,
                                    title: (T) -> String,
                                    @ViewBuilder message: (T) -> Message,
                                    @ViewBuilder actions: (T) -> Actions) -> some View where Actions: View, Message: View {
        let isPresentedBinding = Binding(get: { presenting.wrappedValue != nil }, set: { newValue in
            guard !newValue else {
                return
            }

            presenting.wrappedValue = nil
        })

        return self
            .alert(presenting.wrappedValue.map { title($0) } ?? "",
                   isPresented: isPresentedBinding,
                   presenting: presenting.wrappedValue,
                   actions: actions,
                   message: message)
    }

    func alert<T, Actions>(presenting: Binding<T?>,
                           title: (T) -> LocalizedStringKey,
                           message: (T) -> LocalizedStringKey,
                           @ViewBuilder actions: (T) -> Actions) -> some View where Actions: View {
        alert(presenting: presenting, title: title, message: { Text(message($0)) }, actions: actions)
    }

    func alert<T, Actions>(presenting: Binding<T?>,
                           title: (T) -> LocalizedStringKey,
                           message: (T) -> String,
                           @ViewBuilder actions: (T) -> Actions) -> some View where Actions: View {
        alert(presenting: presenting, title: title, message: { Text(message($0)) }, actions: actions)
    }

    func alert<T, Actions>(presenting: Binding<T?>,
                           title: (T) -> String,
                           message: (T) -> LocalizedStringKey,
                           @ViewBuilder actions: (T) -> Actions) -> some View where Actions: View {
        alert(presenting: presenting, title: title, message: { Text(message($0)) }, actions: actions)
    }

    func alert<T, Actions>(presenting: Binding<T?>,
                           title: (T) -> String,
                           message: (T) -> String,
                           @ViewBuilder actions: (T) -> Actions) -> some View where Actions: View {
        alert(presenting: presenting, title: title, message: { Text(message($0)) }, actions: actions)
    }
}
