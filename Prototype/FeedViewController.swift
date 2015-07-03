//
//  Created by Nick Snyder on 6/19/15.
//  Copyright (c) 2015 Example. All rights reserved.
//

import UIKit

class FeedViewController: UITableViewController {
  
  let feedItemCell = "FeedItemCell"
  
  var feedItemCollection: Collection<FeedItemCellModel, FeedViewController>?
  
  override func viewDidLoad() {
    super.viewDidLoad()
  
    FixtureProtocol.addDataFromResourceNamed("get-feed.json", bundle: NSBundle.mainBundle(), forPath: "/feed", method: "GET")
    title = "FeedViewController"
    tableView.estimatedRowHeight = 168
    tableView.registerNib(UINib(nibName: feedItemCell, bundle: nil), forCellReuseIdentifier: feedItemCell)
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    var conf = NSURLSessionConfiguration.defaultSessionConfiguration()
    conf.protocolClasses = [FixtureProtocol.self]
    let session = NSURLSession(configuration: conf)
    NetworkClient.sharedInstance.getJsonDataWithURL("http://nick.com/feed", completion: { (json, response, error) -> Void in
      if let feedResponse = FeedResponse(data: json) {
        NSLog("feed response \(feedResponse)")
      } else {
        NSLog("no feed response \(json)")
      }
    })
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(feedItemCell, forIndexPath: indexPath) as! FeedItemCell
    if let feedItem = feedItemCollection?.objectAtIndex(indexPath.row) {
      cell.bindModel(feedItem)
    }
    return cell
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 0
  }
}

extension FeedViewController: CollectionDelegate {
  typealias ElementType = FeedItemCellModel
  typealias Delegate = FeedViewController
  
  func collection(collection: Collection<ElementType, Delegate>, didChange change: CollectionChange) {
    // TODO: better handling
    self.tableView.reloadData()
  }
}
