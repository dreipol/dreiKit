//
//  ControlDelegate.swift
//  dreiKit
//
//  Created by Samuel Bichsel on 21.07.20.
//

import Foundation

public typealias Action<Delegate> = (_ delegate: Delegate) -> Void

public struct ControlAction<D: AnyObject> {
    weak var delegate: D?
    let action: Action<D>

    public init(delegate: D, action: @escaping Action<D>) {
        self.delegate = delegate
        self.action = action
    }

    public func tapped() {
        guard let delegate = delegate else {
            return
        }
        action(delegate)
    }
}
