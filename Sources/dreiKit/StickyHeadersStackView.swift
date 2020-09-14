//
//  StickyHeadersStackView.swift
//  dreiKit
//
//  Created by Nils Becker on 14.09.20.
//

import UIKit

private let headerTag = 0x4eade9

public class StickyHeadersStackView: UIScrollView {
    let stackView = UIStackView.autoLayout(axis: .vertical)

    public init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false

        delegate = self
        addSubview(stackView)
        stackView.fitVerticalScrollView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func addArrangedSubview(_ view: UIView) {
        stackView.addArrangedSubview(view)
    }

    public func addHeader(_ header: UIView) {
        header.tag = headerTag
        stackView.addArrangedSubview(header)
    }

    public func addSpace(_ height: CGFloat) {
        stackView.addSpace(height)
    }
}

extension StickyHeadersStackView: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var lastHeader: UIView?
        var pushingHeader: UIView?
        var height: CGFloat = 0

        for subview in stackView.arrangedSubviews {
            if subview.tag == headerTag {
                if height <= scrollView.contentOffset.y || scrollView.contentOffset.y < 0 {
                    lastHeader = subview
                } else {
                    pushingHeader = subview
                }
            }

            height += subview.frame.size.height
            if height > scrollView.contentOffset.y + (lastHeader?.frame.size.height ?? 0) {
                break
            }
        }

        if let lastHeader = lastHeader {
            stackView.bringSubviewToFront(lastHeader)
            if let pushingHeader = pushingHeader, lastHeader != pushingHeader {
                lastHeader.frame.origin.y = pushingHeader.frame.origin.y - lastHeader.frame.size.height
            } else {
                lastHeader.frame.origin.y = max(scrollView.contentOffset.y, 0)
            }
        }
    }
}
