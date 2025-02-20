//
//  UiBuilder.swift
//  bdui-example
//
//  Created by Danil Chemaev on 23.01.2025.
//

import UIKit

class UIBuilder {
    // MARK: - Build UIStackView from StackView
    static func buildUI(from stackView: StackView) -> UIStackView {
        let uiStackView = UIStackView()
        uiStackView.axis = stackView.axis == .horizontal ? .horizontal : .vertical
        uiStackView.spacing = 8
        uiStackView.alignment = .center
        uiStackView.distribution = .fillEqually

        for i in 0..<stackView.childrenCount {
            if let button = stackView.children(at: i) {
                let uiButton = buildButton(from: button)
                uiStackView.addArrangedSubview(uiButton)
            }
        }

        return uiStackView
    }

    // MARK: - Build UIButton from Button
    static func buildButton(from button: Button) -> UIButton {
        let uiButton = UIButton(type: .system)
        uiButton.setTitle(button.text, for: .normal)
        uiButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)

        if let titleColor = button.titleColor {
            uiButton.setTitleColor(UIColor(
                red: CGFloat(titleColor.r),
                green: CGFloat(titleColor.g),
                blue: CGFloat(titleColor.b),
                alpha: CGFloat(titleColor.a)
            ), for: .normal)
        }

        if let backgroundColor = button.backgroundColor {
            uiButton.backgroundColor = UIColor(
                red: CGFloat(backgroundColor.r),
                green: CGFloat(backgroundColor.g),
                blue: CGFloat(backgroundColor.b),
                alpha: CGFloat(backgroundColor.a)
            )
        }

        return uiButton
    }

    @objc private static func buttonTapped(_ sender: UIButton) {
        print("Button tapped: \(sender.title(for: .normal) ?? "")")
    }
}
