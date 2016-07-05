//
//  ViewController.swift
//  UUXPlaySwift
//
//  Created by Eduardo Cobuci on 7/5/16.
//  Copyright © 2016 Eduardo Cobuci. All rights reserved.
//

import UIKit
import SDWebImage
import Alamofire

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    var REQUEST_URL = NSURL(string: "https://raw.githubusercontent.com/facebook/react-native/master/docs/MoviesExample.json")!
    var dataSource: [[String: AnyObject]] = []
    let CELL_ID = "CELL_ID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.hidden = true
        request(.GET, REQUEST_URL).responseJSON { response in
            let json = response.result.value as! [String: AnyObject]
            let movies = json["movies"] as? [[String: AnyObject]]
            for i in 0..<20 {
                self.dataSource.appendContentsOf(movies!)
            }
            self.indicator.stopAnimating()
            self.tableView.hidden = false
            self.tableView.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count ?? 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(CELL_ID)
        if cell == nil {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: CELL_ID)
        }
        let movie = self.dataSource[indexPath.row]
        cell?.textLabel?.text = movie["title"] as? String
        let thumbnailUrl = NSURL(string: (movie["posters"] as! [String: String])["thumbnail"]!)
        cell?.imageView?.sd_setImageWithURL(thumbnailUrl, placeholderImage: UIImage(named: "uux_placeholder"))
        cell?.detailTextLabel?.text = String(movie["year"] as? Int)
        return cell!
    }
}

