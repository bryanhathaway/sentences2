//
//  BoxCell.swift
//  Boxes
//
//  Created by Bryan Hathaway on 4/10/18.
//  Copyright © 2018 Bryan Hathaway. All rights reserved.
//

import Foundation
import UIKit

class BoxCell: UICollectionViewCell {
    private let label = UILabel()
    private let verticalPadding: CGFloat = 8.0
    private let horizontalPadding: CGFloat = 6.0

    var onDoubleTap: ((BoxCell) -> ())?

    var text: String? {
        get {
            return label.text
        }

        set {
            label.text = newValue
            invalidateIntrinsicContentSize()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = Theme.Box.background

        label.font = Box.compactFont
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = Theme.Box.text
        contentView.addSubview(label)

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: verticalPadding),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: horizontalPadding),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -horizontalPadding),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -verticalPadding),
            ])

        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        doubleTapGesture.numberOfTapsRequired = 2
        addGestureRecognizer(doubleTapGesture)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        let isCompactWidth = traitCollection.horizontalSizeClass == .compact
        label.font = isCompactWidth ? Box.compactFont : Box.regularFont

        invalidateIntrinsicContentSize()
    }

    override var intrinsicContentSize: CGSize {
        var size = label.intrinsicContentSize
        size.width += horizontalPadding * 2.0
        size.height += verticalPadding * 2.0

        return size
    }

    @objc func doubleTapped() {
        onDoubleTap?(self)
    }
}
