//
//  BitDataBuilder.swift
//  
//
//  Created by Alexey Siginur on 08/03/2021.
//

import Foundation

public class SMBitDataWriter {
    
    private var _data: Data
    private(set) var suffix: UInt8 = 0
    private(set) var suffixSize: UInt8 = 0
    
    public var data: Data {
        var fullData = _data
        if suffixSize > 0 {
            fullData.append(suffix)
        }
        return fullData
    }
    
    public var bytes: [UInt8] {
        [UInt8](data)
    }
    
    public var sizeInBytes: Int {
        _data.count + (suffixSize > 0 ? 1 : 0)
    }
    public var sizeInBits: UInt64 {
        suffixSize > 0 ? UInt64(_data.count) * 8 + UInt64(suffixSize) : UInt64(_data.count) * 8
    }
    
    public init(initialData data: Data = Data()) {
        self._data = data
    }
    
    public func writeData(_ data: Data) {
        if suffixSize == 0 {
            self._data.append(data)
            return
        }
        
        writeBytes([UInt8](data))
    }
    
    public func writeBytes(_ bytes: [UInt8]) {
        if suffixSize == 0 {
            _data.append(contentsOf: bytes)
            return
        }
        
        var convertedBytes = [UInt8](repeating: 0, count: bytes.count)
        var tmpSuffix: UInt8 = suffix
        for index in 0..<bytes.count {
            let byte = bytes[index]
            defer {
                tmpSuffix = byte << (8 - suffixSize)
            }
            convertedBytes[index] = tmpSuffix | (byte >> suffixSize)
        }
        _data.append(contentsOf: convertedBytes)
        suffix = tmpSuffix
    }

    public func writeByte(_ byte: UInt8) {
        writeBytes([byte])
    }

    public func writeBits(_ bits: UInt8, count: UInt8) {
        let newSuffixSize = suffixSize + count
        if newSuffixSize < 8 {
            suffix = suffix | (bits << (8 - newSuffixSize))
            suffixSize = newSuffixSize
            return
        }
        
        _data.append(suffix | (bits >> (newSuffixSize - 8)))
        suffix = bits << (16 - newSuffixSize)
        suffixSize = newSuffixSize - 8
    }
    
    public func writeBit(_ bit: UInt8) {
        writeBits(bit, count: 1)
    }
    
    public func writeBitOne() {
        writeBits(1, count: 1)
    }
    
    public func writeBitZero() {
        writeBits(0, count: 1)
    }
    
    public func write(from builder: SMBitDataWriter) {
        writeData(builder._data)
        if builder.suffixSize > 0 {
            writeBits(builder.suffix >> (8 - builder.suffixSize), count: builder.suffixSize)
        }
    }
    
    public func fillUpToByte() {
        _data.append(suffix)
        suffix = 0
        suffixSize = 0
    }
    
}
