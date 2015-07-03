//
//  Created by Nick Snyder on 7/1/15.
//  Copyright (c) 2015 Example. All rights reserved.
//

import Foundation

struct CollectionChange {
  let insertIndexes: NSIndexSet
  let deleteIndexes: NSIndexSet
  let reloadIndexes: NSIndexSet
  let moveIndexes: [IndexMove]
}

struct IndexMove {
  let fromIndex: Int
  let toIndex: Int
}

protocol CollectionDelegate: class {
  typealias ElementType: ModelType
  typealias Delegate: CollectionDelegate
  func collection(collection: Collection<ElementType, Delegate>, didChange change: CollectionChange)
}

class Collection<ElementType: ModelType, Delegate: CollectionDelegate> {
  
  weak var delegate: Delegate?
  private var modelIds: [String] = []
  
  let datastore: Datastore
  let collectionId: String
  
  init(collectionId: String, datastore: Datastore) {
    self.collectionId = collectionId
    self.datastore = datastore
  }

  func objectAtIndex(index: Int) -> ElementType? {
    let modelId = modelIds[index]
    if let object = datastore.getValueForKey(modelId) as? ElementType {
      return object
    }
    return nil
  }
  
  func appendObjects(objects: [ElementType]) {
    let newModelIds = objects.map({ (model: ElementType) -> String in
      model.getModelId()
    })
    
  }
  
  var count: Int {
    return modelIds.count
  }
}