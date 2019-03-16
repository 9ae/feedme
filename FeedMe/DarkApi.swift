//
//  DarkApi.swift
//  FeedMe
//
//  Created by Alice Q Wong on 3/10/19.
//  Copyright © 2019 Alice Q Wong. All rights reserved.
//

import Foundation
import Alamofire

class DarkApi {
    static let HOST = "https://alice-recipes.builtwithdark.com"
    
    static func get(path: String, callback: @escaping (_ json : [String:Any]) -> Void ) {
        let url = "\(HOST)\(path)?user=alice"
        Alamofire.request(url).responseJSON { response in
            if let JSON = response.result.value as? [String:Any] {
                callback(JSON)
            } else {
                print("GET \(url)")
                print("error parsing json")
            }
        }
    }
    
    static func post(path: String, parameters: [String: Any], callback: @escaping (_ json : [String:Any]) -> Void){
        let url = "\(HOST)\(path)"
        let params: Parameters = parameters
        Alamofire.request(
            url,
            method: .post,
            parameters: params,
            encoding: JSONEncoding.default).responseJSON { response in
                if let JSON = response.result.value as? [String:Any] {
                    callback(JSON)
                } else {
                    print("POST \(url)")
                    print("error parsing json")
                }
        }
    }
    
    static func mark(key: String, save: Bool){
        post(path: "/mark", parameters: ["key": key, "save": save]){ json in
            print(json)
        }
    }
}
