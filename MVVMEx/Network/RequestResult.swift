//
//  RequestResult.swift
//  We
//
//  Created by ahmed mahdy on 11/2/19.
//  Copyright © 2019 Mahdy. All rights reserved.
//

import Foundation

public enum RequestResult<T, U> where U: Error  {
    case success(T?)
    case failure(U)
}

enum HTTPMethod: String {
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
}

enum RequestError: Error {
    case unknownError
    case connectionError
    case authorizationError
    case invalidRequest
    case notFound
    case invalidResponse
    case serverError
    case serverUnavailable
    case jsonConversionFailure
}
