//
//  DateFormatter.swift
//  Ios Demonstrations
//
//  Created by Nathan Walsh on 3/25/21.
//  Copyright © 2021 Nathan Walsh. All rights reserved.
//

import Foundation

public protocol StaticDateFormatterInterface {
    static var value: DateFormatter { get }
}

public enum CustomDecodeableDate<Formatter> where Formatter: StaticDateFormatterInterface {
    case value(Date)
    case error(DecodingError)
    
    var value: Date? {
        switch self {
        case .value(let value): return value
        case .error: return nil
        }
    }
    
    var error: DecodingError? {
        switch self {
        case .value: return nil
        case .error(let error): return error
        }
    }
    public enum DecodingError: Error {
        case incorrectFormat(source: String, dateFormatter: DateFormatter)
        case errorWhileDecoding(error: Error)
    }
}

extension CustomDecodeableDate: Codable {
  public func encode(to encoder: Encoder) throws {
    //implement
  }
  
    public init(from decoder: Decoder) throws {
        do {
            let dateString = try decoder.singleValueContainer().decode(String.self)
            guard let date = Formatter.value.date(from: dateString) else {
                self = .error(DecodingError.incorrectFormat(source: dateString, dateFormatter: Formatter.value))
                return
            }
            self = .value(date)
        } catch let err {
            self = .error(.errorWhileDecoding(error: err))
        }
    }
}
