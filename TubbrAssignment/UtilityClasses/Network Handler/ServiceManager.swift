//
//  ServiceManager.swift
//  TubbrAssignment
//
//  Created by Gaurav Kabra on 12/07/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
public struct HeaderInfo {
    public let authToken: String

    public init(authToken: String) {
        self.authToken = authToken
    }
}

public struct ServiceManager {
    static  let tubberRouter = Router<CommunityServiceApi>()

    //Bearer token 
    static var headerInfo = HeaderInfo.init(authToken: bearerToken)


    static public func getSearchRecords(request: [String: Any],
                                          completion: @escaping (Result<SearchTracksResponseModel?,
        APIError>) -> Void) {
        tubberRouter.fetch(.getSearchTracksData(requestParams: request, headers: headerInfo), decode: { json -> SearchTracksResponseModel? in
            guard let result = json as? SearchTracksResponseModel else { return  nil }
            return result
        }, completion: completion)
    }

}
