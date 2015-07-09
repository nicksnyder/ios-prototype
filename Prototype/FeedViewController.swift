//
//  Created by Nick Snyder on 6/19/15.
//  Copyright (c) 2015 Example. All rights reserved.
//

import UIKit

class FeedViewController: UITableViewController {
  
  let feedItemCell = "FeedItemCell"
  
  let feedItemCollection = Collection(persistenceInfo: PersistenceInfo(id: "feed", datastore: MemoryDatastore()))
  
  override func viewDidLoad() {
    super.viewDidLoad()
  
    FixtureProtocol.addDataFromResourceNamed("feed1.json", bundle: NSBundle.mainBundle(), forPath: "/feed1", method: "GET")
    FixtureProtocol.addDataFromResourceNamed("feed2.json", bundle: NSBundle.mainBundle(), forPath: "/feed2", method: "GET")
    
    title = "FeedViewController"
    tableView.estimatedRowHeight = 168
    tableView.registerNib(UINib(nibName: feedItemCell, bundle: nil), forCellReuseIdentifier: feedItemCell)
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    NetworkClient.sharedInstance.getJsonDataWithURL("http://nick.com/feed1", completion: { (json, response, error) -> Void in
      if let feedResponse = FeedResponse(data: json) {
        NSLog("feed response \(feedResponse)")
       
      
      } else {
        NSLog("no feed response \(json)")
      }
    })
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(feedItemCell, forIndexPath: indexPath) as! FeedItemCell
    if let feedItem = feedItemCollection.modelAtIndex(indexPath.row) as? FeedItemCellModel {
      cell.bindModel(feedItem)
    }
    return cell
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 0
  }
  
  override func tableView(tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
    NetworkClient.sharedInstance.getJsonDataWithURL("http://nick.com/feed2", completion: { (json, response, error) -> Void in
      if let feedResponse = FeedResponse(data: json) {
        NSLog("feed response \(feedResponse)")
      } else {
        NSLog("no feed response \(json)")
      }
    })
  }
}

/*
extension FeedViewController: CollectionDelegate {
  typealias ElementType = FeedItemCellModel
  typealias Delegate = FeedViewController
  
  func collection(collection: Collection<ElementType, Delegate>, didChange change: CollectionChange) {
    // TODO: better handling
    self.tableView.reloadData()
  }
}*/
