//
//  Created by Nick Snyder on 6/19/15.
//  Copyright (c) 2015 Example. All rights reserved.
//

import UIKit

class FeedViewController: UITableViewController {
  
  let feedItemCell = "FeedItemCell"
  
  //Collection(persistenceInfo: PersistenceInfo(id: "feed", datastore: MemoryDatastore()))
  
  var feedItemCollection: Collection?
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
    feedItemCollection = Collection()
    appendFeedItemsFromURL("http://nick.com/feed1")
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(feedItemCell, forIndexPath: indexPath) as! FeedItemCell
    if let feedItem = feedItemCollection?.modelAtIndex(indexPath.row) as? FeedItemCellModel {
      cell.bindModel(feedItem)
    }
    return cell
  }
  
  var page = 0
  override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    if let feedItemCollection = feedItemCollection {
      if indexPath.row == feedItemCollection.count - 1 {
        page = (page + 1) % 2
        appendFeedItemsFromURL("http://nick.com/feed\(page+1)")
      }
    }
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return feedItemCollection?.count ?? 0
  }
  
  private func appendFeedItemsFromURL(url: String) {
    NetworkClient.sharedInstance.getJsonDataWithURL(url, completion: { (json, response, error) -> Void in
      if let feedResponse = FeedResponse(data: json) {
        NSLog("feed response \(feedResponse)")
        let models = feedResponse.toFeedItemCellModels()
        if let feedItemCollection = self.feedItemCollection {
          // Animating inserts into table views while scrolling causes jittering. Set doAnimations to false to see what I mean.
          let doAnimations = false
          if doAnimations {
            let insertIndexPaths = FeedViewController.indexPathsFromIndex(feedItemCollection.count, section: 0, count: models.count)
            feedItemCollection.appendModels(models)
            self.tableView.beginUpdates()
            self.tableView.insertRowsAtIndexPaths(insertIndexPaths, withRowAnimation: UITableViewRowAnimation.Bottom)
            self.tableView.endUpdates()
          } else {
            feedItemCollection.appendModels(models)
            self.tableView.reloadData()
          }
        }
      } else {
        NSLog("no feed response \(json)")
      }
    })
  }
  
  private static func indexPathsFromIndex(fromIndex: Int, section: Int, count: Int) -> [NSIndexPath] {
    var indexPaths = [NSIndexPath]()
    for var i = fromIndex; i < fromIndex + count; i++ {
      indexPaths.append(NSIndexPath(forRow: i, inSection: section))
    }
    return indexPaths
  }
}

extension FeedResponse {
  func toFeedItemCellModels() -> [ModelType] {
    var models = [ModelType]()
    for feedItem in self.feedItems {
      if let cellModel = FeedItemCellModel(feedItem: feedItem, feedResponse: self) {
        models.append(cellModel)
      }
    }
    return models
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
