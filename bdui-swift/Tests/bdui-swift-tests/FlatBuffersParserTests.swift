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
    
    func testEncodeAndParseTestButton() {
        let text = "Submit"
        let action = "submitAction"
        
        // Define properties for encoding
        let properties: [String: Any] = [
            "text": text,
            "action": action
        ]
        
        // Encode the TestButton
        let encodedData = parser.encode(schemaType: TestButton.self, properties: properties)
        
        // Decode the data
        if let decodedTestButton: TestButton = parser.parse(data: encodedData, schemaType: TestButton.self) {
            // Assert that the decoded values match the original ones
            XCTAssertEqual(decodedTestButton.text, text)
            XCTAssertEqual(decodedTestButton.action, action)
        } else {
            XCTFail("Failed to decode TestButton")
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
