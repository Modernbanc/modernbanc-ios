//
//  http.types.swift
//  examp-elements
//
//  Created by Greg Gevorkyan on 3/17/23.
//

import Foundation


public struct MdbApiError: Codable, Error {
    public let code: String
    public let message: String
    
    init(code: String, message: String) {
        self.code = code
        self.message = message
    }
}

public struct CreateTokenResponse: Codable {
    public let result: [SecretToken]
}

public struct SecretToken: Codable {
    public let id: String
    public let name: String
    public let workspace_id: String
    public let original_value_type: String?
}

public enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
    case head = "HEAD"
    case options = "OPTIONS"
    case connect = "CONNECT"
    case query = "QUERY"
    case trace = "TRACE"
}
