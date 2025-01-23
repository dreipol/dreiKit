//
//  CancellableSheet.swift
//  dreiKit
//
//  Created by Laila Becker on 22.01.2025.
//

import SwiftUI

@available(iOS 16.0, *)
private struct CancellableSheetContent: ViewModifier {
    let cancelButtonLabel: LocalizedStringKey
    let placement: ToolbarItemPlacement

    @Environment(\.dismiss) private var dismiss

    func body(content: Content) -> some View {
        NavigationStack {
            content
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(cancelButtonLabel) {
                            dismiss()
                        }
                    }
                }
        }
    }
}

public extension View {
    @available(iOS 16.0, *)
    func cancellableSheet<Content>(isPresented: Binding<Bool>,
                                   cancelButtonLabel: LocalizedStringKey,
                                   cancelPlacement: ToolbarItemPlacement = .topBarLeading,
                                   @ViewBuilder content: @escaping () -> Content) -> some View where Content : View {
        sheet(isPresented: isPresented) {
            content()
                .modifier(CancellableSheetContent(cancelButtonLabel: cancelButtonLabel, placement: cancelPlacement))
        }
    }
}
