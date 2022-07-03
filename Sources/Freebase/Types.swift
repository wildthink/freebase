//
//  File.swift
//  
//
//  Created by Jason Jobe on 5/22/22.
//

import Foundation
import UniqueID

public protocol Topical {
    var id: UniqueID { get }
    var name: String { get }
}

public struct Topic: Topical {
    public var id: UniqueID = .null
    public var name: String
}

public struct Person: Topical {
    public var id: UniqueID = .null
    public var name: String { pname.formatted() }
    public var pname: PersonNameComponents
    public var pronouns: String?
    
    public init(_ gname: String? = nil, _ fname: String? = nil) {
        pname = .init(givenName: gname, familyName: fname)
    }
}

struct Note: Identifiable, Codable {
    var id: UniqueID = .null
    var title: String
    var subtitle: String?
    var body: String
}
