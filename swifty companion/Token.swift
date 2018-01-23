//
//  Token.swift
//  swifty companion
//
//  Created by Paul DESPRES on 1/22/18.
//  Copyright © 2018 42. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


struct Global {
    static var tokenId: String?
}

class Token {
    
    private let key = "90158da8d5d2bafaed0c5a489d8c1a772bf5c70c98e0d84fd41e75b05931e8fa"
    private let secret = "b17f0315364116d25a866e63e96d0aad30a4ccdfb1736134e0897f58826005b1"
    
    init() {
        APITokenRequest()
    }
    
    func APITokenRequest() {
        print("token request")
        Alamofire.request(
            URL(string: "https://api.intra.42.fr/oauth/token")!,
            method: .post,
            parameters: ["grant_type": "client_credentials", "client_id": key, "client_secret": secret])
            .validate()
            .responseJSON { response in
                guard response.result.isSuccess else {
                    print("Error while fetching token: \(String(describing: response.result.error))")
                    return
                }
                
                if let value = response.result.value as? [String: Any] {
                    let json = JSON(value)
                    Global.tokenId = json["access_token"].string
                }
        }
    }

    func checkToken() {
        print("token check")
        Alamofire.request(
            URL(string: "https://api.intra.42.fr/v2/cursus")!,
            method: .get,
            parameters: ["access_token": Global.tokenId!])
            .validate()
            .responseJSON { response in
                guard response.result.isSuccess else {
                    if response.response!.statusCode == 401 {
                        print("new token")
                        self.APITokenRequest()
                    }
                    return
                }
        }
    }
    
}
