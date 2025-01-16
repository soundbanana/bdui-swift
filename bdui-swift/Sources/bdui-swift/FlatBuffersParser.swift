import Foundation
import FlatBuffers
import bdui_swift_resources

public typealias TestButton = bdui_TestButton
public typealias StackView = bdui_StackView
public typealias Axis = bdui_Axis

protocol FlatBufferEncodable {
    static func encodeToFlatBuffer(properties: [String: Any], builder: inout FlatBufferBuilder) -> Offset
}

protocol FlatBufferDecodable {
    static func decodeFromFlatBuffer(data: Data) -> Self?
}

extension TestButton: FlatBufferEncodable {
    static func encodeToFlatBuffer(properties: [String: Any], builder: inout FlatBufferBuilder) -> Offset {
        guard let text = properties["text"] as? String,
              let action = properties["action"] as? String else {
            fatalError("Failed to encode TestButton: Missing 'text' or 'action' property.")
        }

        let textOffset = builder.create(string: text)
        let actionOffset = builder.create(string: action)
        return createTestButton(&builder, textOffset: textOffset, actionOffset: actionOffset)
    }
}

extension TestButton: FlatBufferDecodable {
    static func decodeFromFlatBuffer(data: Data) -> TestButton? {
        var buffer = ByteBuffer(bytes: [UInt8](data))
        return try? getCheckedRoot(byteBuffer: &buffer)
    }
}

extension StackView: FlatBufferEncodable {
    static func encodeToFlatBuffer(properties: [String: Any], builder: inout FlatBufferBuilder) -> Offset {
        guard let axisRawValue = properties["axis"] as? Int8,
              let axis = Axis(rawValue: axisRawValue) else {
            fatalError("Failed to encode StackView: Missing or invalid 'axis' property.")
        }
        
        guard let childrenArray = properties["children"] as? [[String: Any]] else {
            fatalError("Failed to encode StackView: Missing 'children' property.")
        }
        
        var childrenOffsets: [Offset] = []
        for child in childrenArray {
            let childOffset = TestButton.encodeToFlatBuffer(properties: child, builder: &builder)
            childrenOffsets.append(childOffset)
        }
        
        let childrenVector = builder.createVector(ofOffsets: childrenOffsets)
        return createStackView(&builder, axis: axis, childrenVectorOffset: childrenVector)
    }
}

extension StackView: FlatBufferDecodable {
    static func decodeFromFlatBuffer(data: Data) -> StackView? {
        var buffer = ByteBuffer(bytes: [UInt8](data))
        return try? getCheckedRoot(byteBuffer: &buffer)
    }
}

class FlatBuffersParser {
    
    func encode<T: FlatBufferEncodable>(schemaType: T.Type, properties: [String: Any]) -> Data {
        print("Encoding \(T.self) with properties: \(properties)")
        var builder = FlatBufferBuilder(initialSize: 1024)

        let offset = T.encodeToFlatBuffer(properties: properties, builder: &builder)
        builder.finish(offset: offset)
        
        let byteArray = builder.sizedByteArray
        print("Encoded byte array size: \(byteArray.count)")
        return Data(byteArray)
    }

    func parse<T: FlatBufferDecodable>(data: Data, schemaType: T.Type) -> T? {
        print("Decoding \(T.self) from data...")
        
        return T.decodeFromFlatBuffer(data: data)
    }
}
