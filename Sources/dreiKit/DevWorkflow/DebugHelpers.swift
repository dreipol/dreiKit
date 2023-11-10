//
//  File.swift
//
//
//  Created by Samuel Bichsel on 10.11.2023.
//

import Foundation

public enum DebugHelpers {
    public static func printSimulatorDocumentsPath() {
        #if targetEnvironment(simulator)
        if let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.path {
            print("Documents Directory: \(documentsPath)")
        }
        #endif
    }
}
