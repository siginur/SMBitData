//
//  SMBitDataReaderTests.swift
//  
//
//  Created by Alexey Siginur on 08/03/2021.
//

import XCTest
import SMBitData

final class SMBitDataReaderTests: XCTestCase {
    
    func testReadByte() throws {
        var srcBytesArray = [UInt8]()
        for value in 0...255 {
            srcBytesArray.append(UInt8(value))
        }
        let srcData = Data(srcBytesArray)
        
        let container = SMBitDataReader(data: srcData)
        for value in 0...255 {
            XCTAssertEqual(try container.readByte(), UInt8(value))
        }
    }
    
    func testReadBytes() throws {
        var srcBytesArray = [UInt8]()
        for value in 0...255 {
            srcBytesArray.append(UInt8(value))
        }
        let srcData = Data(srcBytesArray)
        
        let container = SMBitDataReader(data: srcData)
        XCTAssertEqual(try container.readBytes(256), srcBytesArray)
    }
    
    func testReadBit() throws {
        let srcData = Data([0b11100101, 0b01101001] as [UInt8])
        let container = SMBitDataReader(data: srcData)

        XCTAssertEqual(try container.readBit(), 1)
        XCTAssertEqual(try container.readBit(), 1)
        XCTAssertEqual(try container.readBit(), 1)
        XCTAssertEqual(try container.readBit(), 0)
        XCTAssertEqual(try container.readBit(), 0)
        XCTAssertEqual(try container.readBit(), 1)
        XCTAssertEqual(try container.readBit(), 0)
        XCTAssertEqual(try container.readBit(), 1)
        
        XCTAssertEqual(try container.readBit(), 0)
        XCTAssertEqual(try container.readBit(), 1)
        XCTAssertEqual(try container.readBit(), 1)
        XCTAssertEqual(try container.readBit(), 0)
        XCTAssertEqual(try container.readBit(), 1)
        XCTAssertEqual(try container.readBit(), 0)
        XCTAssertEqual(try container.readBit(), 0)
        XCTAssertEqual(try container.readBit(), 1)
    }
    
    func testReadBits() throws {
        let srcData = Data([0b11100101, 0b01101001, 0b11010101, 0b00010110, 0b11001110] as [UInt8])
        let container = SMBitDataReader(data: srcData)

        XCTAssertEqual(try container.readBits(1), 0b1)
        XCTAssertEqual(try container.readBits(2), 0b11)
        XCTAssertEqual(try container.readBits(3), 0b001)
        XCTAssertEqual(try container.readBits(3), 0b010)
        XCTAssertEqual(try container.readBits(3), 0b110)
        XCTAssertEqual(try container.readBits(4), 0b1001)
        XCTAssertEqual(try container.readBits(8), 0b11010101)
        XCTAssertEqual(try container.readBits(3), 0b000)
        XCTAssertEqual(try container.readBits(8), 0b10110110)
        XCTAssertEqual(try container.readBits(5), 0b01110)
    }
    
    func testRead() throws {
        let srcData = Data([0b11100101, 0b01101001, 0b11010101, 0b00010110, 0b11001110, 0b01100101] as [UInt8])
        let container = SMBitDataReader(data: srcData)

        XCTAssertEqual(try container.readBits(1), 0b1)
        XCTAssertEqual(try container.readByte(),  0b11001010)
        XCTAssertEqual(try container.readBits(3), 0b110)
        XCTAssertEqual(try container.readBits(4), 0b1001)
        XCTAssertEqual(try container.readByte(),  0b11010101)
        XCTAssertEqual(try container.readBits(3), 0b000)
        XCTAssertEqual(try container.readBytes(2),[0b10110110, 0b01110011])
        XCTAssertEqual(try container.readBits(5), 0b00101)
    }

}
