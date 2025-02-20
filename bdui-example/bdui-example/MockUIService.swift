//
//  MockUIService.swift
//  bdui-example
//
//  Created by Danil Chemaev on 23.01.2025.
//

import Foundation
import FlatBuffers
import bdui_swift_resources

public typealias StackView = bdui_StackView
public typealias Button = bdui_Button
public typealias Axis = bdui_Axis


import Foundation
import FlatBuffers
import bdui_swift_resources

class MockUIService {
    private let encoder = UIEncoder()

    // MARK: - Generate Mock Button Data
    func generateMockButtonData() -> Data {
        let properties: [String: Any] = [
            "text": "Submit",
            "action": "submitAction",
            "title_color": ["r": 1.0, "g": 0.0, "b": 0.0, "a": 1.0], // Red
            "background_color": ["r": 0.0, "g": 0.0, "b": 1.0, "a": 1.0], // Blue
            "is_enabled": true,
            "is_selected": false,
            "is_highlighted": false
        ]

        return encoder.encodeButton(
            text: properties["text"] as! String,
            action: properties["action"] as! String,
            titleColor: properties["title_color"] as? [String: Float],
            backgroundColor: properties["background_color"] as? [String: Float],
            isEnabled: properties["is_enabled"] as! Bool,
            isSelected: properties["is_selected"] as! Bool,
            isHighlighted: properties["is_highlighted"] as! Bool
        )
    }

    // MARK: - Generate Mock StackView Data
    func generateMockStackViewData() -> Data {
        let button1Properties: [String: Any] = [
            "text": "Submit",
            "action": "submitAction",
            "title_color": ["r": 1.0, "g": 0.0, "b": 0.0, "a": 1.0], // Red
            "background_color": ["r": 0.0, "g": 0.0, "b": 1.0, "a": 1.0], // Blue
            "is_enabled": true,
            "is_selected": false,
            "is_highlighted": false
        ]

        let button2Properties: [String: Any] = [
            "text": "Cancel",
            "action": "cancelAction",
            "title_color": ["r": 0.0, "g": 1.0, "b": 0.0, "a": 1.0], // Green
            "background_color": ["r": 1.0, "g": 1.0, "b": 0.0, "a": 1.0], // Yellow
            "is_enabled": true,
            "is_selected": false,
            "is_highlighted": false
        ]

        let stackViewProperties: [String: Any] = [
            "axis": Axis.vertical.rawValue,
            "children": [button1Properties, button2Properties]
        ]

        return encoder.encodeStackView(axis: .vertical, children: stackViewProperties["children"] as! [[String: Any]])
    }
}
