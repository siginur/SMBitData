//
//  UnsignedInteger+BinaryString.swift
//  
//
//  Created by Alexey Siginur on 16/03/2021.
//

import Foundation

extension UnsignedInteger {
    
    public var binaryString: String {
        let str = String(self, radix: 2)
        return String(repeating: "0", count: bitWidth - str.count).appending(str)
    }
    
}
