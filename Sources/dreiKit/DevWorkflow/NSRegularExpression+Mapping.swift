//
//  NSRegularExpression+Mapping.swift
//  dreiKit
//
//  Created by Nils Becker on 05.10.21.
//

import Foundation

extension NSRegularExpression {
    func mapMatches(onString string: String, mapper: ((String, [String]) -> String)) -> String {
        var current = string
        var range = NSRange(current.startIndex ..< current.endIndex, in: current)

        while let match = firstMatch(in: current, options: [], range: range) {
            let matchRange = match.range
            let fullMatch = (current as NSString).substring(with: matchRange) as String
            let captureGroups = (1 ..< match.numberOfRanges).map { index -> String in
                let matchRange = match.range(at: index)
                return (current as NSString).substring(with: matchRange) as String
            }

            let replacement = mapper(fullMatch, captureGroups)
            current = (current as NSString).replacingCharacters(in: matchRange, with: replacement)

            range = NSRange(current.startIndex ..< current.endIndex, in: current)
        }

        return current
    }

    func mapMatches(onString string: NSMutableAttributedString, mapper: ((String, [String]) -> NSAttributedString)) {
        var range = NSRange(location: 0, length: string.mutableString.length)
        while let match = firstMatch(in: String(string.mutableString), options: [], range: range) {
            let matchRange = match.range
            let fullMatch = string.mutableString.substring(with: matchRange)
            let captureGroups = (1 ..< match.numberOfRanges).map { index -> String in
                let matchRange = match.range(at: index)
                return string.mutableString.substring(with: matchRange)
            }

            let replacement = mapper(fullMatch, captureGroups)
            string.replaceCharacters(in: matchRange, with: replacement)

            let offset = match.range.lowerBound + replacement.length
            range = NSRange(location: offset, length: string.mutableString.length - offset)
        }
    }
}
