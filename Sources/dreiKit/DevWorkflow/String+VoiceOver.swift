//
//  String+VoiceOver.swift
//
//
//  Created by Samuel Bichsel on 18.07.23.
//

import Foundation
import UIKit

public extension String {
    func forVoiceOver(languageCode: String? = nil) -> NSAttributedString {
        let language = languageCode ?? UIView.defaultAccessibilityLanguage
        return NSMutableAttributedString(string: self, attributes: [.accessibilitySpeechLanguage: language as Any])
            .applyPronunciationGuide(pronunciationGuide: UIView.pronunciationGuide(language),
                                     abbreviations: UIView.abbreviations(language))
    }
}
