import Foundation
import FlatBuffers
import bdui_swift_resources

// Type Aliases for FlatBuffers schema
public typealias Button = bdui_Button
public typealias Color = bdui_Color
public typealias StackView = bdui_StackView
public typealias Axis = bdui_Axis

// Protocols for FlatBuffer Encoding/Decoding
protocol FlatBufferEncodable {
    static func encodeToFlatBuffer(properties: [String: Any], builder: inout FlatBufferBuilder) -> Offset
}

protocol FlatBufferDecodable {
    static func decodeFromFlatBuffer(data: Data) -> Self?
}

// MARK: - Button Extension
extension Button: FlatBufferEncodable {
    static func encodeToFlatBuffer(properties: [String: Any], builder: inout FlatBufferBuilder) -> Offset {
        let textOffset = builder.create(string: properties["text"] as? String ?? "")
        let actionOffset = builder.create(string: properties["action"] as? String ?? "")

        let titleColorOffset = encodeColor(properties["title_color"] as? [String: Float], builder: &builder)
        let backgroundColorOffset = encodeColor(properties["background_color"] as? [String: Float], builder: &builder)
        let imageOffset = builder.create(string: properties["image"] as? String ?? "")

        let imageEdgeInsetsVector = builder.createVector(properties["image_edge_insets"] as? [Float] ?? [])
        let contentEdgeInsetsVector = builder.createVector(properties["content_edge_insets"] as? [Float] ?? [])

        return createButton(
            &builder,
            textOffset: textOffset,
            actionOffset: actionOffset,
            titleColorOffset: titleColorOffset,
            backgroundColorOffset: backgroundColorOffset,
            imageOffset: imageOffset,
            imageEdgeInsetsVectorOffset: imageEdgeInsetsVector,
            contentEdgeInsetsVectorOffset: contentEdgeInsetsVector,
            isEnabled: properties["is_enabled"] as? Bool ?? true,
            isSelected: properties["is_selected"] as? Bool ?? false,
            isHighlighted: properties["is_highlighted"] as? Bool ?? false
        )
    }

    private static func encodeColor(_ color: [String: Float]?, builder: inout FlatBufferBuilder) -> Offset {
        guard let color = color, let r = color["r"], let g = color["g"], let b = color["b"], let a = color["a"] else {
            return Offset()
        }
        return Color.createColor(&builder, r: r, g: g, b: b, a: a)
    }
}

extension Button: FlatBufferDecodable {
    static func decodeFromFlatBuffer(data: Data) -> Button? {
        var buffer = ByteBuffer(bytes: [UInt8](data))
        return try? getCheckedRoot(byteBuffer: &buffer)
    }

    func toDictionary() -> [String: Any] {
        var dictionary: [String: Any] = [:]

        dictionary["text"] = text
        dictionary["action"] = action
        dictionary["title_color"] = titleColor?.toDictionary()
        dictionary["background_color"] = backgroundColor?.toDictionary()
        dictionary["image"] = image
        dictionary["image_edge_insets"] = imageEdgeInsets
        dictionary["content_edge_insets"] = contentEdgeInsets
        dictionary["is_enabled"] = isEnabled
        dictionary["is_selected"] = isSelected
        dictionary["is_highlighted"] = isHighlighted

        return dictionary.compactMapValues { $0 }
    }

    private func encodeDictionary(for color: Color?) -> [String: Float]? {
        guard let color = color else { return nil }
        return ["r": color.r, "g": color.g, "b": color.b, "a": color.a]
    }
}

private extension Color {
    func toDictionary() -> [String: Float] {
        return ["r": r, "g": g, "b": b, "a": a]
    }
}

// MARK: - StackView Extension
extension StackView: FlatBufferEncodable {
    static func encodeToFlatBuffer(properties: [String: Any], builder: inout FlatBufferBuilder) -> Offset {
        guard let axisRawValue = properties["axis"] as? Int8,
              let axis = Axis(rawValue: axisRawValue) else {
            fatalError("Failed to encode StackView: Missing or invalid 'axis' property.")
        }

        let childrenOffsets = (properties["children"] as? [[String: Any]] ?? []).map {
            Button.encodeToFlatBuffer(properties: $0, builder: &builder)
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

// MARK: - FlatBuffersParser
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
