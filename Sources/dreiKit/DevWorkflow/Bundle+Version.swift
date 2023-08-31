//
//  Bundle+Version.swift
//
//
//  Created by Samuel Bichsel on 31.08.23.
//

import Foundation

public extension Bundle {
    var buildNumber: Int? {
        infoDictionary?["CFBundleVersion"] as? Int
    }

    var versionString: String? {
        infoDictionary?["CFBundleShortVersionString"] as? String
    }
}
