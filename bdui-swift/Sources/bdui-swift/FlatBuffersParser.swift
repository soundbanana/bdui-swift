//
//  FlatBuffersParser.swift
//  bdui-swift
//
//  Created by Danil Chemaev on 15.12.2024.
//

import Foundation
import FlatBuffers
import bdui_swift_resources

typealias TestButton = bdui_swift_resources.bdui_TestButton

class FlatBuffersParser {
    
    // MARK: - Encoding Function (Generic)
    func encode<T>(schemaType: T.Type, properties: [String: Any]) -> Data where T: FlatBufferObject {
        print("Encoding \(T.self) with properties: \(properties)")
        
        var builder = FlatBufferBuilder(initialSize: 1024)

        // Dynamically create the FlatBuffer based on the properties dictionary.
        if let text = properties["text"] as? String, let action = properties["action"] as? String {
            let textOffset = builder.create(string: text)
            let actionOffset = builder.create(string: action)
            
            // Log the offsets created
            print("Text offset: \(textOffset), Action offset: \(actionOffset)")

            if let testButton = T.self as? TestButton.Type {
                let testButtonObj = testButton.createTestButton(&builder, textOffset: textOffset, actionOffset: actionOffset)
                builder.finish(offset: testButtonObj)

                // Log the byte array size
                let byteArray = builder.sizedByteArray
                print("Encoded byte array size: \(byteArray.count)")
                return Data(bytes: byteArray)
            }
        }
        
        print("Failed to encode \(T.self): Unsupported schema or missing properties.")
        return Data()
    }
    
    // MARK: - Decoding Function (Generic)
    func parse<T>(data: Data, schemaType: T.Type) -> T? where T: FlatBufferObject, T: Verifiable {
        print("Decoding \(T.self) from data...")

        // Convert Data to [UInt8]
        var buffer = ByteBuffer(bytes: [UInt8](data))

        // Log the buffer size
        print("Buffer size: \(buffer.size)")

        // Decode the root object (based on the schemaType) from the ByteBuffer
        // Ensure that T conforms to FlatBufferObject and Verifiable
        if let object: T = try? getCheckedRoot(byteBuffer: &buffer) {
            print("Successfully decoded \(T.self).")
            return object
        } else {
            print("Failed to decode \(T.self): Invalid data or corrupted buffer.")
            return nil
        }
    }
}
