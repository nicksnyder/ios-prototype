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
  let batchSize: Int
}

// rubber db
class Collection {
  
  private let persistenceInfo: PersistenceInfo?
  
  private var modelIds = [String]()
  private var pendingWrites = VersionedDictionary()
  
  //private let queue = dispatch_queue_create("Collection", nil)
  
  private(set) var loaded = false
  
  init() {
    self.persistenceInfo = nil
  }
  
  private init(persistenceInfo: PersistenceInfo) {
    self.persistenceInfo = persistenceInfo
  }
  
  static func loadPersistentCollection(persistenceInfo: PersistenceInfo, completion: Collection -> Void) {
    let key = datastoreKeyForCollectionId(persistenceInfo.id)
    persistenceInfo.datastore.getValueForKey(key, completion: { (value: Any?) -> Void in
      if let modelIds = value as? [String] {
        let firstBatchModelIds = modelIds[0..<persistenceInfo.batchSize]
        persistenceInfo.datastore.getValuesForKeys(Array(firstBatchModelIds), completion: { (values: [Any]) -> Void in
          let c = Collection()
          c.modelIds = modelIds
          if let models = values as? [ModelType] {
            c.appendModels(models)
          } else {
            NSLog("could not cast values to ModelType \(values)")
          }
        })
      } else {
        NSLog("could not cast modelIds to [String]")
        completion(Collection())
      }
    })
  }
  
  func modelAtIndex(index: Int) -> ModelType? {
    let modelId = modelIds[index]
    if let model = pendingWrites.getValueForKey(modelId) as? ModelType {
      return model
    }
    if let persistenceInfo = persistenceInfo {
      let key = Collection.datastoreKeyForCollectionId(persistenceInfo.id, modelId: modelId)
      return persistenceInfo.datastore.getValueForKey(key) as? ModelType
    }
    return nil
  }
  
  func appendModels(models: [ModelType]) {
    let version = pendingWrites.newVersion()
    for model in models {
      let modelId = model.getModelId()
      modelIds.append(modelId)
      pendingWrites.setValue(model, forKey: modelId, version: version)
    }
    if let persistenceInfo = persistenceInfo {
      var entries = [DatastoreEntry]()
      var modelIds = [String]()
      for model in models {
        let modelId = model.getModelId()
        modelIds.append(modelId)
        let key = Collection.datastoreKeyForCollectionId(persistenceInfo.id, modelId: modelId)
        entries.append(DatastoreEntry(key: key, immutableValue: model.toData()))
      }
      let collectionKey = Collection.datastoreKeyForCollectionId(persistenceInfo.id)
      entries.append(DatastoreEntry(key: collectionKey, immutableValue: modelIds))
      persistenceInfo.datastore.putEntries(entries, completion: { (success) -> Void in
        if (success) {
          // Writes have made it to the db, so we can stop retaining them.
          for model in models {
            self.pendingWrites.deleteKey(model.getModelId(), withVersion: version)
          }
        }
      })
    }
  }
  
  private static func datastoreKeyForCollectionId(collectionId: String) -> String {
    return "collection:\(collectionId)"
  }
  
  private static func datastoreKeyForCollectionId(collectionId: String, modelId: String) -> String {
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