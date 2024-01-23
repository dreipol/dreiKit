//
//  ForegroundObserverModifier.swift
//  
//
//  Created by Samuel Bichsel on 23.01.2024.
//

import SwiftUI


struct ForegroundObserverModifier: ViewModifier {
    @Environment(\.scenePhase) var scenePhase
    let action: () -> Void

    func body(content: Content) -> some View {
        content.onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                action()
            }
        }
    }
}

public extension View {
    func onEnterForeground(action: @escaping () -> Void) -> some View {
        modifier(ForegroundObserverModifier(action: {
            action()
        }))
    }
}
