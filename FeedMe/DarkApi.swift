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
        var params: Parameters = parameters
        params["user"] = "alice"
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
    
    static func newCards(_ callback : @escaping (_ list : [EntryItem]) -> Void ){
        get(path: "/"){ json in
            var list = [EntryItem]()
            
            guard let newStuff = json["results"] as? [[String:Any]] else {
                return
            }
            for ei in newStuff {
                if let e = EntryItem(ei) {
                    list.append(e)
                }
            }
            callback(list)
        }
    }
    
    static func feeds(_ callback : @escaping (_ list : [BlogFeed]) -> Void){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        get(path: "/feeds"){ json in
            var blogs = [BlogFeed]()
            
            if let jli = json["feeds"] as? [[String:Any]] {
                for bf in jli {
//                    if let bf = i as? [String:Any]{
                    guard let key = bf["key"] as? String else { continue}
                    guard let feed_url = bf["feed_url"] as? String else { continue}
                    guard let is_fetched = bf["is_fetched"] as? Bool else { continue}
                        if !is_fetched {
                            blogs.append(BlogFeed(key: key,
                                feed_url: feed_url,
                                is_fetched: false,
                                blog_url: nil, title: nil, last_update: nil))
                        } else {
                            guard let title = bf["title"] as? String else {continue}
                            guard let blog_url = bf["blog_url"] as? String else {continue}
                            guard let date_string = bf["last_update"] as? String else {continue}
                            
                            
                            let last_update = dateFormatter.date(from: date_string) ?? Date()
                            
                            blogs.append(BlogFeed(key: key,
                                feed_url: feed_url, is_fetched: true,
                                blog_url: blog_url, title: title, last_update: last_update))
                        }
//                    } else {
//                        print("fail to parse dict")
//                        continue
//                    }
                }
            }
            
            callback(blogs)
        }
    }
}
