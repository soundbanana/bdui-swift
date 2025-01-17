//
//  FlatBuffersParserTests.swift
//  bdui-swift-tests
//
//  Created by Danil Chemaev on 16.12.2024.
//

import XCTest
@testable import bdui_swift
@testable import bdui_swift_resources
import FlatBuffers

class FlatBuffersParserTests: XCTestCase {

    var parser: FlatBuffersParser!

    override func setUp() {
        super.setUp()
        parser = FlatBuffersParser()
    }

    func testEncodeAndParseButton() {
        let text = "Submit"
        let action = "submitAction"
        let titleColor: [String: Float] = ["r": 1.0, "g": 0.0, "b": 0.0, "a": 1.0]
        let backgroundColor: [String: Float] = ["r": 0.0, "g": 0.0, "b": 1.0, "a": 1.0]

        // Define properties for encoding
        let properties: [String: Any] = [
            "text": text,
            "action": action,
            "title_color": titleColor,
            "background_color": backgroundColor,
            "is_enabled": true,
            "is_selected": false,
            "is_highlighted": false
        ]

        // Encode the Button
        let encodedData = parser.encode(schemaType: Button.self, properties: properties)

        // Явное указание типа для результата
        let decodedButton: Button? = parser.parse(data: encodedData, schemaType: Button.self)

        if let decodedButton = decodedButton {
            // Assert that the decoded values match the original ones
            XCTAssertEqual(decodedButton.text, text)
            XCTAssertEqual(decodedButton.action, action)
            XCTAssertEqual(decodedButton.titleColor?.r, titleColor["r"])
            XCTAssertEqual(decodedButton.titleColor?.g, titleColor["g"])
            XCTAssertEqual(decodedButton.titleColor?.b, titleColor["b"])
            XCTAssertEqual(decodedButton.titleColor?.a, titleColor["a"])
            XCTAssertEqual(decodedButton.backgroundColor?.r, backgroundColor["r"])
            XCTAssertEqual(decodedButton.backgroundColor?.g, backgroundColor["g"])
            XCTAssertEqual(decodedButton.backgroundColor?.b, backgroundColor["b"])
            XCTAssertEqual(decodedButton.backgroundColor?.a, backgroundColor["a"])
            XCTAssertEqual(decodedButton.isEnabled, true)
            XCTAssertEqual(decodedButton.isSelected, false)
            XCTAssertEqual(decodedButton.isHighlighted, false)
        } else {
            XCTFail("Failed to decode Button.")
        }
    }

    func testEncodeAndParseStackView() {
        let axis: Axis = .vertical
        let text1 = "Submit"
        let action1 = "submitAction"
        let text2 = "Cancel"
        let action2 = "cancelAction"

        let properties: [String: Any] = [
            "axis": axis.rawValue,
            "children": [
                ["text": text1, "action": action1],
                ["text": text2, "action": action2]
            ]
        ]

        let encodedData = parser.encode(schemaType: StackView.self, properties: properties)
        if let decodedStackView: StackView = parser.parse(data: encodedData, schemaType: StackView.self) {
            XCTAssertEqual(decodedStackView.axis, axis)
            XCTAssertEqual(decodedStackView.childrenCount, 2)

            if let firstChild = decodedStackView.children(at: 0) {
                XCTAssertEqual(firstChild.text, text1)
                XCTAssertEqual(firstChild.action, action1)
            } else {
                XCTFail("Failed to decode first child.")
            }

            if let secondChild = decodedStackView.children(at: 1) {
                XCTAssertEqual(secondChild.text, text2)
                XCTAssertEqual(secondChild.action, action2)
            } else {
                XCTFail("Failed to decode second child.")
            }
        } else {
            XCTFail("Failed to decode StackView.")
        }
    }
}
