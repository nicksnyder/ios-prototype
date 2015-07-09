//
//  Created by Nick Snyder on 6/19/15.
//  Copyright (c) 2015 Example. All rights reserved.
//

import UIKit

struct FeedItemCellModel: ModelType {
  let content: Content
  let sharer: Person
  let author: Person
  
  init?(data: ModelData?) {
    if let content = Content(data: data?["content"] as? ModelData),
      sharer = Person(data: data?["person"] as? ModelData),
      author = Person(data: data?["author"] as? ModelData) {
        self.content = content
        self.sharer = sharer
        self.author = author
    } else {
      return nil
    }
  }
  
  func toData() -> ModelData {
    return [
      "content": content.toData(),
      "sharer": sharer.toData(),
      "author": author.toData()
    ]
  }
  
  func getModelId() -> String {
    return "content:\(content.id);sharer:\(sharer.id);author:\(author.id)"
  }
}

class FeedItemCell: UITableViewCell {

  @IBOutlet private var contentTitleLabel: UILabel!
  @IBOutlet private var authorNameLabel: UILabel!
  @IBOutlet private var contentBodyLabel: UILabel!
  @IBOutlet private var sharedByLabel: UILabel!
  
  func bindModel(feedItem: FeedItemCellModel) {
    contentTitleLabel.text = feedItem.content.title
    authorNameLabel.text = feedItem.sharer.name
    contentBodyLabel.text = feedItem.content.body
    sharedByLabel.text = feedItem.sharer.name
  }
}
