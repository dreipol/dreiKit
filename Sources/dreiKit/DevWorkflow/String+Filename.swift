//
//  String+Filename.swift
//
//
//  Created by Samuel Bichsel on 10.11.2023.
//

import Foundation

public extension String {
    func fileName() -> String {
        return URL(fileURLWithPath: self).deletingPathExtension().lastPathComponent
    }

    func fileExtension() -> String {
        return URL(fileURLWithPath: self).pathExtension
    }
}
