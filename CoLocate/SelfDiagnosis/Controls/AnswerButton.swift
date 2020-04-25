//
//  AnswerButton.swift
//  CoLocate
//
//  Created by NHSX.
//  Copyright © 2020 NHSX. All rights reserved.
//

import UIKit

@IBDesignable
class AnswerButton: UIControl {

    @IBInspectable var text: String? {
        didSet {
            textLabel.text = text
            accessibilityLabel = textLabel.accessibilityLabel
        }
    }

    let textLabel = UILabel()
    let imageView = UIImageView()

    override var isSelected: Bool {
        didSet {
            if isSelected {
                accessibilityTraits.insert(.selected)
            } else {
                accessibilityTraits.remove(.selected)
            }

            layer.borderWidth = isSelected ? 2 : 0
            imageView.isHighlighted = isSelected
        }
    }

    override var intrinsicContentSize: CGSize {
        CGSize(width: UIView.noIntrinsicMetric, height: 100)
    }

    override func awakeFromNib() {
        accessibilityTraits = [.button]
        isAccessibilityElement = true
        if #available(iOS 13.0, *) {
            accessibilityRespondsToUserInteraction = true
        } else {
            // Fallback on earlier versions
        }

        layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)

        layer.cornerRadius = 16
        layer.borderColor = UIColor(named: "NHS Highlight")!.cgColor

        textLabel.font = UIFont.preferredFont(forTextStyle: .body)
        textLabel.textColor = UIColor(named: "NHS Text")!

        imageView.image = UIImage(named: "Controls_RadioButton_Unselected")
        imageView.highlightedImage = UIImage(named: "Controls_RadioButton_Selected")

        let stack = UIStackView(arrangedSubviews: [
            textLabel,
            imageView,
        ])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 20

        addSubview(stack)
        stack.isUserInteractionEnabled = false
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.leftAnchor.constraint(equalTo: layoutMarginsGuide.leftAnchor),
            stack.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            stack.rightAnchor.constraint(equalTo: layoutMarginsGuide.rightAnchor),
            stack.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
        ])
        textLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        imageView.setContentHuggingPriority(.required, for: .horizontal)
    }

}