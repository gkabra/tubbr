//
//  CommunityServiceApi.swift
//  TubbrAssignment
//
//  Created by Gaurav Kabra on 12/07/20.
//  Copyright © 2020 Apple. All rights reserved.
//


import Foundation
import UIKit

enum CommunityServiceApi {
    case getSearchTracksData(requestParams :  [String : Any], headers: HeaderInfo)

}

extension CommunityServiceApi: EndPointType {


    var isAuthorization: Bool {
        return false
    }

    var headers: HTTPHeaders? {
        switch self {
        case .getSearchTracksData(  _, let header):
            return ["Authorization":"Bearer " + header.authToken]
        }
    }
    
    public var baseURL: URL {
        guard let url = URL(string: "https://api.spotify.com/v1/") else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    public var path: String {
        switch self {
        case .getSearchTracksData(request: _):
            return "tracks"
        }
    }
    
    public var httpMethod: HTTPMethod {
        switch self {
        case .getSearchTracksData(request: _):
            return .get
        }
    }

    
    public var timeout: TimeInterval {
        return 60
    }
    
    
    public var task: HTTPTask {
        switch self {

        case .getSearchTracksData(let request, _):
            return .requestParametersAndHeaders(bodyParameters: nil,
                                                bodyEncoding: .urlEncoding,
                                                urlParameters: request,
                                                additionHeaders: headers)

        }
    }
}

