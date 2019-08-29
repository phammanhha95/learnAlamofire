//
//  JWTAccessTokenAdapter.swift
//  AlamofireLearn
//
//  Created by Techmaster on 4/29/19.
//  Copyright © 2019 Techmaster. All rights reserved.
//

import Foundation
import Alamofire

final class JWTAccessTokenAdapter: RequestAdapter {
    typealias JWT = String
    private let accessToken: JWT
    
    init(accessToken: JWT) {
        self.accessToken = accessToken
    }
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        
        /// Set the Authorization header value using the access token.
        urlRequest.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
       
        
        return urlRequest
    }
}
/*
 https://rudybermudez.io/handing-network-problems-gracefully-with-alamofire
 https://github.com/Alamofire/Alamofire/issues/1906
 */
/*
extension JWTAccessTokenAdapter: RequestRetrier {
    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
            completion(false, 0.0)
            return
        }
        
        refreshToken = { [weak self] accessToken in
            guard let strongSelf = self else { return }
            
            strongSelf.accessToken = accessToken
            completion(true, 0.0)
        }
    }
}*/
