//
//  UILoader.swift
//  bdui-example
//
//  Created by Danil Chemaev on 23.01.2025.
//

import Foundation
import FlatBuffers
import bdui_swift
import bdui_swift_resources

class UILoader {
    private let encoder = UIEncoder()

    // MARK: - Decode Button
    func decodeButton(from data: Data) -> Button? {
        return encoder.decodeButton(from: data)
    }

    // MARK: - Decode StackView
    func decodeStackView(from data: Data) -> StackView? {
        return encoder.decodeStackView(from: data)
    }
}
