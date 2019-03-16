//
//  MyKolodaViewController.swift
//  FeedMe
//
//  Created by Alice Q Wong on 3/15/19.
//  Copyright © 2019 Alice Q Wong. All rights reserved.
//

import UIKit
import Koloda

class SwipeFeedVC: UIViewController {

    @IBOutlet weak var kolodaView: KolodaView!
    
    var entryItems : [EntryItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        kolodaView.dataSource = self
        kolodaView.delegate = self
        
        
    }
    
    @IBAction func refreshBtnPressed(_ sender: Any){
        print("LOG fetching new data")
        DarkApi.get(path: "/"){ json in
            print("LOG got results")
            guard let newStuff = json["results"] as? [[String:Any]] else {
                return
            }
            for ei in newStuff {
                if let e = EntryItem(ei) {
                    self.entryItems.append(e)
                }
            }
            self.kolodaView.reloadData()
            print("LOG reload data")
        }
    }
}

extension SwipeFeedVC: KolodaViewDelegate {
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        koloda.reloadData()
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
       
    }
}

extension SwipeFeedVC: KolodaViewDataSource {
    
    func kolodaNumberOfCards(_ koloda:KolodaView) -> Int {
        return entryItems.count
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .fast
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        if let cardView = Bundle.main.loadNibNamed("RecipeCardUI", owner: self, options: nil)?[0] as? RecipeCard {
            let ei = self.entryItems[index]
            cardView.title.text = ei.title
            cardView.webview.loadHTMLString(ei.preview, baseURL: nil)
            return cardView
        } else {
            let errorLabel = UILabel()
            errorLabel.text = "Zoops!"
            return errorLabel
        }
    }
    
    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        //return Bundle.main.loadNibNamed("OverlayView", owner: self, options: nil)?[0] as? OverlayView
        return OverlayView()
    }
}
