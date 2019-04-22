//
//  RecipeCard.swift
//  FeedMe
//
//  Created by Alice Q Wong on 3/16/19.
//  Copyright © 2019 Alice Q Wong. All rights reserved.
//

import UIKit
import WebKit

class RecipeCard: UIView {
    
    @IBOutlet var title : UILabel!
    @IBOutlet var webview : WKWebView!
    
    var entry: EntryItem?

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        self.layer.cornerRadius = 20
    }
    
    func set(_ ei: EntryItem){
        self.entry = ei
        
        self.title.text = ei.title
        self.webview.loadHTMLString(ei.preview, baseURL: nil)
    }
    
    @IBAction func onShowMore(_ sender: Any){
        guard let ei = self.entry else { return }
        guard let url = URL(string: ei.url) else {
            return
        }
        let req = URLRequest(url: url)
        self.webview.load(req)
    }
    
    @IBAction func onNo(_ sender: Any) {
        if let ie = self.entry  {
            DarkApi.mark(key: ie.key, save: false)
        }
    }
    
    @IBAction func onSave(_ sender: Any) {
        if let ie = self.entry  {
            DarkApi.mark(key: ie.key, save: true)
        }
    }
    
    @IBAction func onCalendar(_ sender: Any){
        guard let ei = self.entry else { return }
        
        NotificationCenter.default.post(
            name: SwipeFeedVC.ADD_RECIPE_TO_CALENDAR,
            object: nil,
            userInfo: ["entry": ei]
        )
    }

}
