//
//  MyKolodaViewController.swift
//  FeedMe
//
//  Created by Alice Q Wong on 3/15/19.
//  Copyright © 2019 Alice Q Wong. All rights reserved.
//

import UIKit
import Koloda
import EventKit
import EventKitUI

class SwipeFeedVC: UIViewController, EKEventEditViewDelegate, UINavigationControllerDelegate {
    
    static let ADD_RECIPE_TO_CALENDAR = NSNotification.Name(rawValue: "ADD_RECIPE_TO_CALENDAR")
    
    var eventStore = EKEventStore()
    
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        print("did complete")
        print(action)
        controller.dismiss(animated: false){
            print("dismissed")
        }
    }
    
    func eventEditViewControllerDefaultCalendar(forNewEvents controller: EKEventEditViewController) -> EKCalendar {
        return self.eventStore.defaultCalendarForNewEvents ?? EKCalendar(for: .event, eventStore: self.eventStore)
    }
    

    @IBOutlet weak var kolodaView: KolodaView!
    
    var entryItems : [EntryItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        kolodaView.dataSource = self
        kolodaView.delegate = self
        
        DarkApi.newCards { (list) in
            self.entryItems = list
            self.kolodaView.reloadData()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.addToCalendar), name: SwipeFeedVC.ADD_RECIPE_TO_CALENDAR , object: nil)
    }
    
    @objc func addToCalendar(){
        let i  = kolodaView.currentCardIndex
        entryToCalendar(self.entryItems[i])
        // It works but it doesn't open calendar it just silently adds it to the calendar
    }
    
    func mark(ie: EntryItem, save: Bool){
        DarkApi.mark(key: ie.key, save: save)
    }
    
    func _insertEvent(ei: EntryItem) {
        if let calendar = self.eventStore.defaultCalendarForNewEvents {

            let startDate = Date()
            let endDate = startDate.addingTimeInterval(2 * 60 * 60)
            
            let event = EKEvent(eventStore: self.eventStore)
            event.calendar = calendar
            
            event.title = ei.title
            event.url = URL(string: ei.url)
            event.startDate = startDate
            event.endDate = endDate

            
            do {
                //try self.eventStore.save(event, span: .thisEvent)
                let editVC = EKEventEditViewController()
                editVC.delegate = self
                editVC.editViewDelegate = self
                editVC.event = event
                editVC.eventStore = self.eventStore
                
                self.present(editVC, animated: false){
                    print("event to calendar")
                }
            }
            catch {
                print("Error saving event in calendar")             }
            }
    }
    
    func entryToCalendar(_ ei: EntryItem){
        
        switch EKEventStore.authorizationStatus(for: .event) {
        case .authorized:
            self._insertEvent(ei: ei)
        case .denied:
            print("Access denied")
        case .notDetermined:
            self.eventStore.requestAccess(to: .event, completion:
                {[weak self] (granted: Bool, error: Error?) -> Void in
                    if granted {
                        self?._insertEvent(ei: ei)
                    } else {
                        print("Access denied")
                    }
            })
        default:
            print("Case default")
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
            cardView.set(self.entryItems[index])
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
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        let dirStr = direction == .left ? "left" : "right"
        let ie = self.entryItems[index]
        print("swiped \(dirStr) on \(ie.title)")
        self.mark(ie: ie, save: direction == .right)
    }
}
