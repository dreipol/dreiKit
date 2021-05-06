//
//  DisabledPageControl.swift
//  dreiKit
//
//  Created by Nils Becker on 06.05.21.
//

import UIKit

public class DisabledPageControl: UIPageControl {
    public override var accessibilityTraits: UIAccessibilityTraits {
        get { [] }
        set {}
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)

        isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
