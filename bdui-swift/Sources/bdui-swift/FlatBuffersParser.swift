//
//  FlatBuffersParser.swift
//  bdui-swift
//
//  Created by Danil Chemaev on 15.12.2024.
//

import Foundation
import FlatBuffers

public class FlatBuffersParser {
    init(_ bb: ByteBuffer, o: Int32) {}

    public func parse<T: FlatBufferObject>(data: Data, type: T.Type) -> T? {
        let buffer = ByteBuffer(data: data)
        let offset: Int32 = 0
        return T.init(buffer, o: offset)
    }
}
