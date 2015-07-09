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

struct PersistenceInfo {
  let id: String
  let datastore: Datastore
}

// rubber db
class Collection {
  
  private let persistenceInfo: PersistenceInfo?
  
  private var modelIds = [String]()
  private var retainedModels = [String: ModelType]()
  
  //private let queue = dispatch_queue_create("Collection", nil)
  
  private(set) var loaded = false
  
  var batchSize: Int = 10
  
  init(persistenceInfo: PersistenceInfo?) {
    self.persistenceInfo = persistenceInfo
  }
  
  func modelAtIndex(index: Int) -> ModelType? {
    let modelId = modelIds[index]
    if let model = retainedModels[modelId] {
      return model
    }
    if let persistenceInfo = persistenceInfo {
      let key = datastoreKeyForCollectionId(persistenceInfo.id, modelId: modelId)
      return persistenceInfo.datastore.getValueForKey(key) as? ModelType
    }
    return nil
  }
  
  func appendModels(models: [ModelType]) {
    for model in models {
      let modelId = model.getModelId()
      modelIds.append(modelId)
      retainedModels[modelId] = model
    }
    /*
    let appendedModelIds = models.map({ (model: ModelType) -> String in
      return model.getModelId()
    })*/
    
    if let persistenceInfo = persistenceInfo {
      var data = [DatastoreEntry]()
      for model in models {
        let modelId = model.getModelId()
        let key = datastoreKeyForCollectionId(persistenceInfo.id, modelId: modelId)
        data.append(DatastoreEntry(key: key, immutableValue: model.toData()))
      }
      let key = datastoreKeyForCollectionId(persistenceInfo.id)
      data.append(DatastoreEntry(key: key, immutableValue: modelIds))
      persistenceInfo.datastore.putData(data, completion: { (success) -> Void in
        
      })
    }
  }
  
  private func datastoreKeyForCollectionId(collectionId: String) -> String {
    return "collection:\(collectionId)"
  }
  
  private func datastoreKeyForCollectionId(collectionId: String, modelId: String) -> String {
    return "\(datastoreKeyForCollectionId(collectionId)):\(modelId)"
  }
  
  var count: Int {
    return modelIds.count
  }
}

/*
protocol CollectionDelegate: class {
  typealias ElementType: ModelType
  typealias Delegate: CollectionDelegate
  func collection(collection: Collection<ElementType, Delegate>, didChange change: CollectionChange)
}

class Collection<ElementType: ModelType, Delegate: CollectionDelegate> {
  
  private let queue = dispatch_queue_create("Collection", nil)

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
    objects.map({ (model: ElementType) -> String in
      model.getModelId()
    })
    
  }
  
  var count: Int {
    return modelIds.count
  }
}
*/