//
//  ViewController.swift
//  bdui-example
//
//  Created by Danil Chemaev on 23.01.2025.
//

import UIKit

class ViewController: UIViewController {
    private let mockUIService = MockUIService()
    private let uiLoader = UILoader()
    private let uiBuilder = UIBuilder()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Generate mock StackView data
        let stackViewData = mockUIService.generateMockStackViewData()

        // Decode the StackView
        guard let stackView = uiLoader.decodeStackView(from: stackViewData) else {
            showError(message: "Failed to decode StackView.")
            return
        }

        // Build the UI components
        let uiStackView = UIBuilder.buildUI(from: stackView)

        // Add the UI to the view
        addUIToView(uiStackView)
    }

    // MARK: - Add UI to View
    private func addUIToView(_ uiStackView: UIStackView) {
        view.addSubview(uiStackView)
        uiStackView.translatesAutoresizingMaskIntoConstraints = false

        // Center the UIStackView in the view
        NSLayoutConstraint.activate([
            uiStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            uiStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    // MARK: - Error Handling
    private func showError(message: String) {
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
