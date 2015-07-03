//
//  Created by Nick Snyder on 6/29/15.
//  Copyright (c) 2015 Example. All rights reserved.
//

import Foundation

typealias NetworkData = [String: AnyObject]

struct FeedResponse {
  let feedItems: [FeedItem]
  let contents: [Content]
  let people: [Person]
  
  init?(data: NetworkData?) {
    let feedItemsData = data?["feedItems"] as? [NetworkData] ?? []
    self.feedItems = feedItemsData.reduce([FeedItem](), combine: { (var feedItems: [FeedItem], feedItemData: NetworkData) -> [FeedItem] in
      if let feedItem = FeedItem(data: feedItemData) {
        feedItems.append(feedItem)
      }
      return feedItems
    })
    
    let contentsData = data?["contents"] as? [NetworkData] ?? []
    self.contents = contentsData.reduce([Content](), combine: { (var contents: [Content], contentData: NetworkData) -> [Content] in
      if let content = Content(data: contentData) {
        contents.append(content)
      }
      return contents
    })
    
    let peopleData = data?["people"] as? [NetworkData] ?? []
    self.people = peopleData.reduce([Person](), combine: { (var people: [Person], personData: NetworkData) -> [Person] in
      if let person = Person(data: personData) {
        people.append(person)
      }
      return people
    })
  }
}

struct FeedItem: NetworkModel {
  let contentId: String
  let sharerId: Int
  
  init?(data: NetworkData?) {
    if let contentId = data?["contentId"] as? String,
      sharerId = data?["sharerId"] as? Int {
      self.contentId = contentId
      self.sharerId = sharerId
    } else {
      return nil
    }
  }
  
  func toData() -> NetworkData {
    return [
      "contentId": contentId,
      "sharerId": sharerId
    ]
  }
  
  func getModelId() -> String {
    return "contentId:\(contentId);sharerId:\(sharerId)"
  }
}

struct Content: NetworkModel {
  let authorId: Int
  let body: String
  let id: String
  let title: String
  
  init?(data: NetworkData?) {
    if let authorId = data?["authorId"] as? Int,
      body = data?["body"] as? String,
      id = data?["id"] as? String,
      title = data?["title"] as? String {
        self.authorId = authorId
        self.body = body
        self.id = id
        self.title = title
    } else {
      return nil
    }
  }
  
  func toData() -> NetworkData {
    return [
      "authorId": authorId,
      "body": body,
      "id": id,
      "title": title
    ]
  }
  
  func getModelId() -> String {
    return id
  }
}

struct Person: NetworkModel {
  let id: Int
  let name: String
  let nickName: String?
  
  init?(data: NetworkData?) {
    if let id = data?["id"] as? Int,
      name = data?["name"] as? String {
        self.name = name
        self.id = id
        self.nickName = data?["nickName"] as? String
    } else {
      return nil
    }
  }
  
  func toData() -> NetworkData {
    var data: NetworkData = [
      "id": id,
      "name": name
    ]
    if let nickName = nickName {
      data["nickName"] = nickName
    }
    return data
  }
  
  func getModelId() -> String {
    return String(id)
  }
}