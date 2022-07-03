import XCTest
@testable import Freebase
import Runtime
import UniqueID
import SnapshotTesting
//import KeyValueCoding


final class FreebaseTests: XCTestCase {
    
    func testUUIDGeneration() throws {
        [1, 23, 987].forEach {
            print(UUID.simple($0))
        }
        
        print(UUID.one)
     }
    
    func testSampler() throws {
        let info = try typeInfo(of: Person.self)
        for p in info.properties {
            print(p)
        }
        
        let id = try info.property(named: "id")
        print (id)
        
        let pinfo = try info.property(named: "dob")
        print(pinfo, pinfo.type)

        let taginfo = try info.property(named: "tags")
        let tags = try typeInfo(of: taginfo.type)
//        print (tags.type, tags.elementType)

        let dob = try typeInfo(of: pinfo.type)
//        print (dob.isOptional, dob.type, dob.elementType)
        
        let p = try createInstance(of: Person.self)
        assertSnapshot(matching: p, as: .dump)
        print(p)
    }
    
    func testRestructure() throws {
        let map :[String:Any?] = [
            "id": UniqueID.null,
            "name": "jane",
            "tags": [],
            "dob": nil
        ]

        let rec = try JSONRecord(map)
        let p: Person = try rec.restructure()
        assertSnapshot(matching: p, as: .dump)
        print(p)
    }
}

public struct JSONRecord: Record {
    
    public var allColumns: [String] = .init()
    public var allValues: [StorageValue] = .init()
    
    public init(_ map: [String:Any?]) throws {
        try self.init(map as [String : Any])
    }
    
    public init(_ map: [String:Any]) throws {
        try map.forEach { (key: String, value: Any) in
            allColumns.append(key)
//            if let value = value {
                try allValues.append(.encode(any: value))
//            } else {
//                allValues.append(.null)
//            }
        }
//        self.allColumns = map.keys
//        self.allValues = map.values.m
    }
    public func contains(column: String) -> Bool {
        allColumns.contains(column)
    }
    
//    public func decodeNil(column: String) throws -> Bool {
//        guard contains(column: column) else {
//            throw FreebaseError()
//        }
//    }
    
    public func decode(column: String) throws -> StorageValue {
        .null
    }
    
    public func encode(column: String, value: StorageValue) throws {
    }
}

extension UniqueID: DefaultConstructor {
    public init() {
        self = .null
    }
}

struct Person {
    var id: UniqueID = .null
    var name: String
    var tags: [String]
    var dob: Date?
}
