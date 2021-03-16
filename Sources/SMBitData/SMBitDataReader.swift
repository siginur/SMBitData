//
//  BitDataReader.swift
//  
//
//  Created by Alexey Siginur on 07/03/2021.
//

import Foundation

public class SMBitDataReader {
    
    private let data: Data
    private(set) var index: Int = 0
    private var prefix: UInt8 = 0
    private(set) var prefixSize: UInt8 = 0
    
    public var elapsedBytes: Int {
        data.count - index
    }
    public var elapsedBits: Int {
        elapsedBytes * 8 + Int(prefixSize)
    }
    
    public init(data: Data) {
        self.data = data
    }
    
    public func readBytes(_ length: Int) throws -> [UInt8] {
        let nextIndex = self.index.advanced(by: length)
        guard nextIndex <= self.data.endIndex else {
            throw Error.outOfRange
        }
        defer { self.index = nextIndex }
        
        let bytes = [UInt8](data.subdata(in: self.index..<nextIndex))
        if prefixSize == 0 {
            return bytes
        }
        
        var convertedBytes = [UInt8](repeating: 0, count: bytes.count)
        var tmpPrefix: UInt8 = prefix
        for index in 0..<bytes.count {
            let byte = bytes[index]
            defer {
                tmpPrefix = byte << (8 - prefixSize)
            }
            convertedBytes[index] = tmpPrefix | (byte >> prefixSize)
        }
        prefix = tmpPrefix
        return convertedBytes
    }

    public func readByte() throws -> UInt8 {
        guard let byte = try readBytes(1).first else {
            throw Error.outOfRange
        }
        return byte
    }
    
    public func readBits(_ length: UInt8) throws -> UInt8 {
        if length <= prefixSize {
            let res: UInt8 = prefix >> (8 - length)
            prefixSize = prefixSize - length
            prefix = prefix << length
            return res
        }
        
        let nextIndex = self.index + 1
        guard nextIndex <= self.data.endIndex else {
            throw Error.outOfRange
        }
        defer { index = nextIndex }
        guard let byte = [UInt8](data.subdata(in: self.index..<nextIndex)).first else {
            throw Error.outOfRange
        }
        
        defer {
            prefix = byte << (length - prefixSize)
            prefixSize = 8 - (length - prefixSize)
        }
        return (prefix | (byte >> prefixSize)) >> (8 - length)
    }
    
    public func readBit() throws -> UInt8 {
        return try readBits(1)
    }
    
    public func readData(length: Int) throws -> Data {
        return Data(try readBytes(length))
    }
    
    public func skipBytes(_ length: Int) throws {
        let _ = try? readBytes(length)
    }
    
    public func skipByte() throws {
        try skipBytes(1)
    }
    
    public func skipBits(_ length: UInt8) throws {
        let _ = try? readBits(length)
    }
    
    public func skipBit() throws {
        try skipBits(1)
    }
    
}

extension SMBitDataReader {
    
    public enum Error: Swift.Error {
        case outOfRange
    }
    
}
