//
//  WrapContent.swift
//
//
//  Created by Samuel Bichsel on 24.07.23.
//

import Foundation
import SwiftUI

private struct InnerHeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) { value = nextValue() }
}

@available(iOS 16.0, *)
public extension View {
    /**
     struct ExampleView: View {
         @State private var showSheet = false
         @State private var sheetHeight: CGFloat = .zero

         var body: some View {
             Button("Open sheet") {
                 showSheet = true
             }
             .sheet(isPresented: $showSheet) {
                 VStack {
                     Text("Title")
                     Text("Some very long text ...")
                 }
                 .fixedInnerHeight($sheetHeight)
             }
         }
     }
     */
    func sheetWrappingContent(_ sheetHeight: Binding<CGFloat>) -> some View {
        padding()
            .overlay {
                GeometryReader { proxy in
                    Color.clear.preference(key: InnerHeightPreferenceKey.self, value: proxy.size.height)
                }
            }
            .onPreferenceChange(InnerHeightPreferenceKey.self) { newHeight in sheetHeight.wrappedValue = newHeight }
            .presentationDetents([.height(sheetHeight.wrappedValue)])
    }
}
