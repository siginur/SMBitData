//
//  SMBitDataWriterTests.swift
//  
//
//  Created by Alexey Siginur on 08/03/2021.
//

import XCTest
import SMBitData

final class SMBitDataWriterTests: XCTestCase {
    
    func testWriteByte() throws {
        let container = SMBitDataWriter()
        for value in 0...255 {
            container.writeByte(UInt8(value))
        }

        for (index, value) in [UInt8](container.data).enumerated() {
            XCTAssertEqual(UInt8(index), value)
        }
    }
    
    func testWriteBytes() throws {
        var srcBytesArray = [UInt8]()
        for value in 0...255 {
            srcBytesArray.append(UInt8(value))
        }

        let container = SMBitDataWriter()
        container.writeBytes(srcBytesArray)

        XCTAssertEqual(container.data, Data(srcBytesArray))
    }

    func testWriteBit() throws {
        let container = SMBitDataWriter()
        container.writeBitOne()
        container.writeBit(1)
        container.writeBitOne()
        container.writeBit(0)
        container.writeBitZero()
        container.writeBitOne()
        container.writeBit(0)
        container.writeBitOne()
        
        container.writeBitZero()
        container.writeBit(1)
        container.writeBit(1)
        container.writeBit(0)
        container.writeBitOne()
        container.writeBit(0)
        container.writeBitZero()
        container.writeBitOne()
        
        XCTAssertEqual(container.data, Data([0b11100101, 0b01101001] as [UInt8]))
        
        container.writeBitOne()
        XCTAssertEqual(container.data, Data([0b11100101, 0b01101001, 0b10000000] as [UInt8]))
    }

    func testWriteBits() throws {
        let container = SMBitDataWriter()
        
        container.writeBits(0b1, count: 1)
        container.writeBits(0b11, count: 2)
        container.writeBits(0b001, count: 3)
        container.writeBits(0b010, count: 3)
        container.writeBits(0b110, count: 3)
        container.writeBits(0b1001, count: 4)
        container.writeBits(0b11010101, count: 8)
        container.writeBits(0b000, count: 3)
        container.writeBits(0b10110110, count: 8)
        container.writeBits(0b01110, count: 5)
        
        XCTAssertEqual(container.data, Data([0b11100101, 0b01101001, 0b11010101, 0b00010110, 0b11001110] as [UInt8]))
    }

    func testWrite() throws {
        let container = SMBitDataWriter()
        
        container.writeBits(0b1, count: 1)
        container.writeByte(0b11001010)
        container.writeBits(0b110, count: 3)
        container.writeBits(0b1001, count: 4)
        container.writeByte(0b11010101)
        container.writeBits(0b000, count: 3)
        container.writeBytes([0b10110110, 0b01110011])
        container.writeBits(0b00101, count: 5)
        
        XCTAssertEqual(container.data, Data([0b11100101, 0b01101001, 0b11010101, 0b00010110, 0b11001110, 0b01100101] as [UInt8]))
    }

}
