//
//  FeedsVC.swift
//  FeedMe
//
//  Created by Alice on 4/14/19.
//  Copyright © 2019 Alice Q Wong. All rights reserved.
//

import UIKit

class FeedsVC: UITableViewController {
    
    var feeds : [BlogFeed] = []
    @IBOutlet var field : UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DarkApi.feeds { list in
            self.feeds = list
            self.tableView.reloadData()
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @IBAction func saveNewFeed(_ sender: Any){
        let feed_url = field.text ?? "_"
        print("Adding \(feed_url)")
        self.field.endEditing(true)
        self.field.resignFirstResponder()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return feeds.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let blog = feeds[indexPath.row]
            if blog.is_fetched {
                let cell = tableView.dequeueReusableCell(withIdentifier: "feed_li", for: indexPath)
                
                if let _cell = cell as? FeedLiCell {
                    _cell.url.text = blog.blog_url
                    _cell.title.text = blog.title
                    _cell.lastUpdate.text = blog.last_update?.description
                    
                }
                
                return cell
            } else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "new_feeds", for: indexPath)
                
                if let _cell = cell as? NewCell {
                    _cell.url.text = blog.feed_url
                }
                
                return cell
            }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

            let blog = feeds[indexPath.row]
            return blog.is_fetched ? 80 : 50
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
