//
//  UIEncoder.swift
//  bdui-example
//
//  Created by Danil Chemaev on 23.01.2025.
//

import Foundation
import FlatBuffers
import bdui_swift

class UIEncoder {
    private let parser = FlatBuffersParser()

    // MARK: - Encode Button
    func encodeButton(
        text: String,
        action: String,
        titleColor: [String: Float]? = nil,
        backgroundColor: [String: Float]? = nil,
        image: String? = nil,
        imageEdgeInsets: [Float]? = nil,
        contentEdgeInsets: [Float]? = nil,
        isEnabled: Bool = true,
        isSelected: Bool = false,
        isHighlighted: Bool = false
    ) -> Data {
        let properties: [String: Any] = [
            "text": text,
            "action": action,
            "title_color": titleColor as Any,
            "background_color": backgroundColor as Any,
            "image": image as Any,
            "image_edge_insets": imageEdgeInsets as Any,
            "content_edge_insets": contentEdgeInsets as Any,
            "is_enabled": isEnabled,
            "is_selected": isSelected,
            "is_highlighted": isHighlighted
        ]

        return parser.encode(schemaType: Button.self, properties: properties)
    }

    // MARK: - Decode Button
    func decodeButton(from data: Data) -> Button? {
        return parser.parse(data: data, schemaType: Button.self)
    }

    // MARK: - Encode StackView
    func encodeStackView(axis: Axis, children: [[String: Any]]) -> Data {
        let properties: [String: Any] = [
            "axis": axis.rawValue,
            "children": children
        ]

        return parser.encode(schemaType: StackView.self, properties: properties)
    }

    // MARK: - Decode StackView
    func decodeStackView(from data: Data) -> StackView? {
        return parser.parse(data: data, schemaType: StackView.self)
    }
}
