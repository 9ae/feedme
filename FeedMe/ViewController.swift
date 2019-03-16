//
//  ViewController.swift
//  FeedMe
//
//  Created by Alice Q Wong on 3/10/19.
//  Copyright © 2019 Alice Q Wong. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    
    @IBOutlet var text : UILabel!
    @IBOutlet var webview : WKWebView!
    
    var entryItems : [EntryItem] = []
    //var currentIndex: Int = 0
    var currentItem : EntryItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        //webview.navigationDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func nextItem(){
        self.currentItem = self.entryItems.removeFirst()
        
        self.text.text = "Got \(self.entryItems.count) new items"
        
        if let ie = self.currentItem {
            self.webview.loadHTMLString(ie.preview, baseURL: nil)
        }
    }
    
    @IBAction func refreshBtnPressed(_ sender: Any){
        print("fetching new data")
        DarkApi.get(path: "/"){ json in
            guard let newStuff = json["results"] as? [[String:Any]] else {
                return
            }
            for ei in newStuff {
                if let e = EntryItem(ei) {
                    self.entryItems.append(e)
                }
            }

            DispatchQueue.main.async {
                self.text.text = "Got \(self.entryItems.count) new items"
                self.currentItem = self.entryItems.removeFirst()
                
                if let ie = self.currentItem {
                    self.webview.loadHTMLString(ie.preview, baseURL: nil)
                }
            }
            
        }
    }
    
    @IBAction func showDetails(_ sender: Any){
        
        guard let ie = self.currentItem else {
            return
        }
        
        guard let url = URL(string: ie.url) else {
            print("unable to load url")
            return
        }
        let req = URLRequest(url: url)
        self.webview.load(req)
 
    }
    
    @IBAction func save(_ sender: Any){
        
        if let ie = self.currentItem  {
            DarkApi.mark(key: ie.key, save: true)
        }
        
        nextItem()
    }
    
    @IBAction func trash(_ sender: Any){
        if let ie = self.currentItem {
            DarkApi.mark(key: ie.key, save: false)
        }
        
        nextItem()
    }
    


}

