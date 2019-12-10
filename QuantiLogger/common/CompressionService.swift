//
//  CompressionService.swift
//  QuantiLogger
//
//  Created by George Ivannikov on 12/9/19.
//  Copyright © 2019 quanti. All rights reserved.
//

import Foundation
import Compression

protocol CompressionServiceProtocol {
    func compress(data: Data?) -> Data?
    func perform(source: UnsafePointer<UInt8>, sourceSize: Int, preload: Data) -> Data?
}

/// Service for data compression.
struct CompressionService: CompressionServiceProtocol {
    func compress(data: Data?) -> Data? {
        guard let data = data else {
            return nil
        }
        let compressedData = data.withUnsafeBytes { (sourcePtr: UnsafePointer<UInt8>) -> Data? in
            perform(source: sourcePtr, sourceSize: data.count)
        }
        return compressedData
    }

    func perform(source: UnsafePointer<UInt8>, sourceSize: Int, preload: Data = Data()) -> Data? {
        let streamBase = UnsafeMutablePointer<compression_stream>.allocate(capacity: 1)
        defer { streamBase.deallocate() }
        var stream = streamBase.pointee

        let status = compression_stream_init(&stream, COMPRESSION_STREAM_ENCODE, COMPRESSION_LZFSE)
        guard status != COMPRESSION_STATUS_ERROR else { return nil }
        defer { compression_stream_destroy(&stream) }

        var result = preload
        var flags: Int32 = Int32(COMPRESSION_STREAM_FINALIZE.rawValue)
        let blockLimit = 64 * 1024
        var bufferSize = Swift.max(sourceSize, 64)

        if sourceSize > blockLimit {
            bufferSize = blockLimit
            flags = 0
        }

        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
        defer { buffer.deallocate() }

        stream.dst_ptr  = buffer
        stream.dst_size = bufferSize
        stream.src_ptr  = source
        stream.src_size = sourceSize

        while true {
            switch compression_stream_process(&stream, flags) {
            case COMPRESSION_STATUS_OK:
                guard stream.dst_size == 0 else { return nil }
                result.append(buffer, count: stream.dst_ptr - buffer)
                stream.dst_ptr = buffer
                stream.dst_size = bufferSize

                flags = flags == 0 && stream.src_size == 0 ?
                Int32(COMPRESSION_STREAM_FINALIZE.rawValue) : flags

            case COMPRESSION_STATUS_END:
                result.append(buffer, count: stream.dst_ptr - buffer)
                return result

            default:
                return nil
            }
        }
    }

}
