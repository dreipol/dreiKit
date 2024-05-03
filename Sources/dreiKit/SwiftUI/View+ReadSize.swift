//
//  View+ReadSize.swift
//
//  Created by Laila Becker on 02.05.2024.
//  Copyright © 2024 dreipol GmbH. All rights reserved.
//

import SwiftUI

public extension View {
    func readSize(into binding: Binding<CGSize>) -> some View {
        background {
            GeometryReader { geo in
                Color.clear
                    .onAppear {
                        binding.wrappedValue = geo.size
                    }
                    .onChange(of: geo.size) { newValue in
                        binding.wrappedValue = newValue
                    }
            }
        }
    }

    func readHeight(into binding: Binding<CGFloat>) -> some View {
        background {
            GeometryReader { geo in
                Color.clear
                    .onAppear {
                        binding.wrappedValue = geo.size.height
                    }
                    .onChange(of: geo.size.height) { newValue in
                        binding.wrappedValue = newValue
                    }
            }
        }
    }

    func readWidth(into binding: Binding<CGFloat>) -> some View {
        background {
            GeometryReader { geo in
                Color.clear
                    .onAppear {
                        binding.wrappedValue = geo.size.width
                    }
                    .onChange(of: geo.size.width) { newValue in
                        binding.wrappedValue = newValue
                    }
            }
        }
    }
}
