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

public typealias TestButton = bdui_TestButton
public typealias StackView = bdui_StackView
public typealias Axis = bdui_Axis

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
        let axis: bdui_Axis = .vertical  // Correct enum type for Axis
        let text1 = "Submit"
        let action1 = "submitAction"
        let text2 = "Cancel"
        let action2 = "cancelAction"
        
        // Define properties for encoding
        let properties: [String: Any] = [
            "axis": axis.rawValue,  // Use the raw value if needed for the enum
            "children": [
                ["text": text1, "action": action1],
                ["text": text2, "action": action2]
            ]
        ]
        
        // Encode the StackView
        let encodedData = parser.encode(schemaType: StackView.self, properties: properties)
        
        // Decode the data
        if let decodedStackView: StackView = parser.parse(data: encodedData, schemaType: StackView.self) {
            // Assert that the decoded values match the original ones
            XCTAssertEqual(decodedStackView.axis, axis)
            
            // Access the 'children' properly by index
            let childrenCount = decodedStackView.childrenCount
            print("Children count: \(childrenCount)")
            XCTAssertEqual(childrenCount, 2)
            
            for i in 0..<childrenCount {
                if let decodedButton = decodedStackView.children(at: i) {
                    switch i {
                    case 0:
                        XCTAssertEqual(decodedButton.text, text1)
                        XCTAssertEqual(decodedButton.action, action1)
                    case 1:
                        XCTAssertEqual(decodedButton.text, text2)
                        XCTAssertEqual(decodedButton.action, action2)
                    default:
                        XCTFail("Unexpected index")
                    }
                } else {
                    XCTFail("Failed to decode child button at index \(i)")
                }
            }
        } else {
            XCTFail("Failed to decode StackView")
        }
    }
}
