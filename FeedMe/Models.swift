//
//  Models.swift
//  FeedMe
//
//  Created by Alice Q Wong on 3/10/19.
//  Copyright © 2019 Alice Q Wong. All rights reserved.
//

import Foundation

struct EntryItem {
    var key : String
    var preview : String
    var title: String
    var url : String
    
    init?(_ json : [String : Any]) {
        guard let key = json["key"] as? String else {
            return nil
        }
        
        guard let preview = json["preview"] as? String else {
            return nil
        }
        
        guard let title = json["title"] as? String else {
            return nil
        }
        
        guard let url = json["url"] as? String else {
            return nil
        }
        
        self.key = key
        self.preview = preview
        self.title = title
        self.url = url
    }
    
}

struct BlogFeed {
    var key : String
    var feed_url : String
    var is_fetched : Bool = false
    
    var blog_url : String?
    var title : String? 
    var last_update : Date?
}
