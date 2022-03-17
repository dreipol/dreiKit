//
//  Locale+Tools.swift
//  dreiKit
//
//  Created by Nils Becker on 17.03.22.
//

import Foundation

public extension Locale {
    func appTranslationLanguageCode(defaultLanguage: String = "en") -> String {
        guard let languageCode = languageCode,
              Bundle.main.localizations.contains(languageCode) else {
                  return defaultLanguage
              }

        return languageCode
    }
}
