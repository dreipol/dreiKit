//
//  Array+filterDuplicates.swift
//  dreiKit
//
//  Created by Samuel Bichsel on 15.10.2024.
//


public extension Array {
    func filterDuplicates<T: Hashable>(_ key: (Element) -> T) -> [Element] {
        var seen = [T: Bool]()
        return filter {
            seen.updateValue(true, forKey: key($0)) == nil
        }
    }
}
