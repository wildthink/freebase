//
//  Storage.swift
//  
//
//  Created by Jason Jobe on 5/22/22.
//

import Foundation

public struct Schema {
    var domain: URL
    var properties: [Property<Any>]
}

/// The ``Property`` specifies the relationship and conversion between the storage ``Record``
/// and the a Swift Type.
public struct Property<Value> {
    public var key: String
    public var label: String
    public var get: (Record) throws -> Value
    public var set: (Record, Value) throws -> Void
}

public protocol Record {
    /// The returned `String` array is in the same order as the `allValues`
    var  allColumns: [String] { get }
    /// The returned `StorageValue` array is in the `allColumns` order
    var  allValues: [StorageValue] { get }
    
    func contains(column: String) -> Bool
    
//    func decodeNil(column: String) throws -> Bool
    func decode(column: String) throws -> StorageValue
    
    func encode(column: String, value: StorageValue) throws
}

public enum StorageValue {
    public enum Case { case data, double, integer, text, null }

    case data(Data)
    case double(Double)
    case integer(Int64)
    case text(String)
    case record(Record)
    case array([StorageValue])
    case null
}

public extension StorageValue {
    static func integer(_ v: Int) -> StorageValue { .integer(Int64(v)) }
}

// MARK: - Convenience Extensions
public extension StorageValue {
    static func encode(any value: Any) throws -> StorageValue {
//        guard let value = value else { return .null }
        
        if let i = value as? Data { return .data(i) }
        if let i = value as? Double { return .double(i) }
        
        if let i = value as? Int { return .integer(i) }
        if let i = value as? Int64 { return .integer(i) }

        if let i = value as? String { return .text(i) }

        return .null
//        throw FreebaseError("Don't know how to encode \(type(of: value))")
    }
    
    var anyValue: Any? {
        switch self {
            case .null: return nil
            case .data(let value): return value
            case .double(let value): return value
            case .integer(let value): return value
            case .text(let value): return value
            case .record(let value): return value
            case .array(let ar): return ar.map(\.anyValue)
        }
    }
}

public extension Property {
    static func data(key: String, label: String) -> Property<String> {
        .init(key: key, label: label,
              get: { r in
            try r.decode(column: key).anyValue as! String
        },
              set: { (r, v) in
            let sv: StorageValue = try .encode(any: v)
            try r.encode(column: key, value: sv)
        })
    }
}


public struct FreebaseError: Error {
    let msg: String
    let fn: String
    let line: Int
    
    public init(_ msg: String = "", fn: String = #function, line: Int = #line) {
        self.msg = msg
        self.fn = fn
        self.line = line
    }
}

import Runtime

public extension Record {
    func restructure<C>(into: C.Type = C.self) throws -> C {
        let info = try typeInfo(of: C.self)
        var it = try createInstance(of: C.self) as! C
        
        for p in info.properties {
            do {
                if let sv = try? self.decode(column: p.name),
                   let value = sv.anyValue {
                    try p.set(value: value, on: &it)
                }
            } catch {
                print (p, "NOT Supported", error)
            }
        }
        return it
        //        let property = try info.property(named: "username")
    }
}
