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

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        self.layer.cornerRadius = 20
    }

}
