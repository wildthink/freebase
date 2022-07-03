//
//  FoundationExtensions.swift
//  
//
//  Created by Jason Jobe on 5/22/22.
//

import Foundation

public extension UUID {
    
    static var one: UUID = .simple(1)
    
    static func simple(_ ndx: UInt) -> UUID {
        UUID(uuidString: String(format: "00000000-0000-0000-0000-%012d", ndx))!
    }
}
