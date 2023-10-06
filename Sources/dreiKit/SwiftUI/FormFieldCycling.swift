//
//  FormFieldCycling.swift
//  Foodnow
//
//  Created by Laila Becker on 06.10.23.
//  Copyright © 2023 Foodnow AG. All rights reserved.
//

import SwiftUI

public protocol FormFieldCyclable: Equatable, CaseIterable, Hashable where AllCases.Index == Int {
    var next: Self { get }
    var previous: Self { get }
}

public extension FormFieldCyclable {
    var next: Self {
        // swiftlint:disable:next force_unwrapping
        let index = (Self.allCases.firstIndex(of: self)! + 1) % Self.allCases.count
        return Self.allCases[index]
    }

    var previous: Self {
        // swiftlint:disable:next force_unwrapping
        let index = (Self.allCases.firstIndex(of: self)! + Self.allCases.count - 1) % Self.allCases.count
        return Self.allCases[index]
    }
}

public extension View {
    func cycleFormFields<Field: FormFieldCyclable>(focused: FocusState<Field?>.Binding,
                                                   doneTitle: LocalizedStringKey,
                                                   color: Color = .accentColor) -> some View {
        toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                // Make sure we only show the toolbar for our own text fields
                if focused.wrappedValue != nil {
                    Button {
                        focused.wrappedValue = focused.wrappedValue?.previous
                    } label: {
                        Image(systemName: "chevron.up")
                    }
                    .foregroundColor(color)
                    Button {
                        focused.wrappedValue = focused.wrappedValue?.next
                    } label: {
                        Image(systemName: "chevron.down")
                    }
                    .foregroundColor(color)
                    Spacer()
                    Button(doneTitle) {
                        focused.wrappedValue = nil
                    }
                    .foregroundColor(color)
                }
            }
        }
    }

    func doneBar<Field: Hashable>(focused: FocusState<Field?>.Binding,
                                  doneTitle: LocalizedStringKey,
                                  color: Color = .accentColor) -> some View {
        toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                // Make sure we only show the toolbar for our own text fields
                if focused.wrappedValue != nil {
                    Spacer()
                    Button(doneTitle) {
                        focused.wrappedValue = nil
                    }
                    .foregroundColor(color)
                }
            }
        }
    }

    func doneBar(focused: FocusState<Bool>.Binding, doneTitle: LocalizedStringKey, color: Color = .accentColor) -> some View {
        toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                // Make sure we only show the toolbar for our own text fields
                if focused.wrappedValue {
                    Spacer()
                    Button(doneTitle) {
                        focused.wrappedValue = false
                    }
                    .foregroundColor(color)
                }
            }
        }
    }
}
