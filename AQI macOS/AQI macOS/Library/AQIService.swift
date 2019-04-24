//
//  NetworkManager.swift
//  AQI macOS
//
//  Created by Fernando Mata on 4/24/19.
//  Copyright © 2019 Fernando Mata. All rights reserved.
//

import Foundation
import Moya

class AQIProvider {
    static let shared = MoyaProvider<AQIService>()
}

enum AQIService {
    case search(_ string: String)
    case getAQI(city: String)
}

extension AQIService: TargetType {
    var baseURL: URL {
        return getBaseURL()
    }
    
    var path: String {
        switch self {
        case .search:
            return "/search/"
        case .getAQI(let city):
            return "/feed/\(city)/"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Task {
        switch self {
        case .search(let string):
            return .requestParameters(parameters: ["keyword" : string, "apiToken" : apiToken], encoding: URLEncoding.queryString)
        case .getAQI:
            return .requestParameters(parameters: ["apiToken" : apiToken], encoding: URLEncoding.queryString)
        }
    }
    
    var sampleData: Data {
        switch self {
        case .search:
            guard let url = Bundle.main.url(forResource: "Search", withExtension: "json"),
                let data = try? Data(contentsOf: url) else {
                    return Data()
            }
            return data
        case .getAQI:
            guard let url = Bundle.main.url(forResource: "AQI", withExtension: "json"),
                let data = try? Data(contentsOf: url) else {
                    return Data()
            }
            return data
        }
    }
    
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
    
    private var apiToken: String {
        return getAPIToken()
    }
    
    private func getBaseURL() -> URL {
        guard let plist = Bundle.main.path(forResource: "APIConfig", ofType: "plist"),
            let array = NSDictionary(contentsOfFile: plist),
            let apiBaseURL = array["BaseURL"] as? String,
            let baseURL = URL(string: apiBaseURL) else {
            fatalError("Base URL not found")
        }
        
        return baseURL
    }
    
    private func getAPIToken() -> String {
        guard let plist = Bundle.main.path(forResource: "APIConfig", ofType: "plist"),
            let array = NSDictionary(contentsOfFile: plist),
            let apiToken = array["APIToken"] as? String else {
                fatalError("Token not found")
        }
        
        return apiToken
    }
}
