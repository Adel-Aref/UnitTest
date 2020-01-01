//
//  EndPoint.swift
//  We
//
//  Created by ahmed mahdy on 11/2/19.
//  Copyright © 2019 Mahdy. All rights reserved.
//

import Foundation

struct Endpoint {
    let type: EndPointType
    let path: String
}
extension Endpoint {
    static func regestration() -> Endpoint {
        return Endpoint(type: .registration,
            path: "/api/v2/organization/\(constants.organizationID)/application/\(constants.AppID)/user/register"
        )
    }
    static func sendToken() -> Endpoint {
        return Endpoint(type: .account,
                        path: "/api/v1/organization/\(constants.organizationID)/application/\(constants.AppID)/user/\(UserDefaults.standard.userID ?? "")/device/registration"
        )
    }
    
    static func notification() -> Endpoint {
        return Endpoint(type: .base,
                        path: "/api/v1/organization/\(constants.organizationID)/application/\(constants.AppID)/user/\(UserDefaults.standard.userID ?? "")/notification?PageNumber=1&PageSize=100")
    }
    static func survey() -> Endpoint {
        return Endpoint(type: .base,
                        path: "/api/v1/organization/\(constants.organizationID)/application/\(constants.AppID)/survey")
    }
    static func postSurvey() -> Endpoint {
        return Endpoint(type: .base,
                        path: "/api/v2/organization/\(constants.organizationID)/application/\(constants.AppID)/user/\(UserDefaults.standard.userID ?? "")/survey")
    }
    static func login() -> Endpoint {
        return Endpoint(type: .account,
                        path: "/api/v1/organization/\(constants.organizationID)/application/\(constants.AppID)/user/login")
    }
    static func naivagte() -> Endpoint {
        return Endpoint(type: .account,
                        path: "/api/v1/organization/\(constants.organizationID)/application/\(constants.AppID)/user/navigate")
    }
    static func Beacon() -> Endpoint {
        return Endpoint(type: .base,
                        path: "/api/v1/organization/\(constants.organizationID)/application/\(constants.AppID)/beacon/")
    }
    static func Points() -> Endpoint {
        return Endpoint(type: .account,
                        path: "/api/v1/organization/\(constants.organizationID)/application/\(constants.AppID)/user/\(UserDefaults.standard.userID ?? "")/points")
    }
    static func PointsHome() -> Endpoint {
        return Endpoint(type: .account,
                        path: "/api/v1/organization/\(constants.organizationID)/application/\(constants.AppID)/user/\(UserDefaults.standard.userID ?? "")/points/today")
    }
    static func verified() -> Endpoint {
        return Endpoint(type: .registration,
                        path: "/api/v1/organization/\(constants.organizationID)/application/\(constants.AppID)/user/\(UserDefaults.standard.userID ?? ""))/verified")
    }
    static func eventSetting() -> Endpoint {
        return Endpoint(type: .base,
                        path: "/api/v1/organization/\(constants.organizationID)/application/\(constants.AppID)")
    }
    static func appImages() -> Endpoint {
        return Endpoint(type: .base,
                        path: "/api/v1/organization/\(constants.organizationID)/application/\(constants.AppID)/images")
    }
}
extension Endpoint {
    var url: URL? {
        switch type {
        case .registration:
            let base = "https://magixeventregistration.azurewebsites.net"
            return URL(string: base + path)
        case .account:
            let base = "https://accountdbapi.azurewebsites.net"
            return URL(string: base + path)
        case .base:
            let base = "https://connectedmagix-mobile.azurewebsites.net"
            return URL(string: base + path)
        }
    }
}

enum EndPointType {
    case registration
    case account
    case base
}
