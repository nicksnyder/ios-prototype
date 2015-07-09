//
//  Created by Nick Snyder on 6/29/15.
//  Copyright (c) 2015 Example. All rights reserved.
//

import Foundation

struct FeedResponse {
  let feedItems: [FeedItem]
  let contents: [String: Content]
  let people: [Int: Person]
  
  init?(data: ModelData?) {
    let feedItemsData = data?["feedItems"] as? [ModelData] ?? []
    self.feedItems = feedItemsData.reduce([FeedItem](), combine: { (var feedItems: [FeedItem], feedItemData: ModelData) -> [FeedItem] in
      if let feedItem = FeedItem(data: feedItemData) {
        feedItems.append(feedItem)
      }
      return feedItems
    })
    
    let contentsData = data?["contents"] as? [ModelData] ?? []
    self.contents = contentsData.reduce([String: Content](), combine: { (var contents: [String: Content], contentData: ModelData) -> [String: Content] in
      if let content = Content(data: contentData) {
        contents[content.id] = content
      }
      return contents
    })
    
    let peopleData = data?["people"] as? [ModelData] ?? []
    self.people = peopleData.reduce([Int: Person](), combine: { (var people: [Int: Person], personData: ModelData) -> [Int: Person] in
      if let person = Person(data: personData) {
        people[person.id] = person
      }
      return people
    })
  }
}

struct FeedItem: ModelType {
  let contentId: String
  let sharerId: Int
  
  init?(data: ModelData?) {
    if let contentId = data?["contentId"] as? String,
      sharerId = data?["sharerId"] as? Int {
      self.contentId = contentId
      self.sharerId = sharerId
    } else {
      return nil
    }
  }
  
  func toData() -> ModelData {
    return [
      "contentId": contentId,
      "sharerId": sharerId
    ]
  }
  
  func getModelId() -> String {
    return "contentId:\(contentId);sharerId:\(sharerId)"
  }
}

struct Content: ModelType {
  let authorId: Int
  let body: String
  let id: String
  let title: String
  
  init?(data: ModelData?) {
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
  
  func toData() -> ModelData {
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

struct Person: ModelType {
  let id: Int
  let name: String
  let nickName: String?
  
  init?(data: ModelData?) {
    if let id = data?["id"] as? Int,
      name = data?["name"] as? String {
        self.name = name
        self.id = id
        self.nickName = data?["nickName"] as? String
    } else {
      return nil
    }
  }
  
  func toData() -> ModelData {
    var data: ModelData = [
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