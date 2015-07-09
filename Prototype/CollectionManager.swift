//
//  Created by Nick Snyder on 7/1/15.
//  Copyright (c) 2015 Example. All rights reserved.
//

import Foundation

/*
class CollectionManager<CollectionElementType: ModelType, CollectionDelegateType: CollectionDelegate> {
  let datastore: Datastore
  
  typealias CollectionType = Collection<CollectionElementType, CollectionDelegateType>
  
  init(datastore: Datastore) {
    self.datastore = datastore
  }
  
  func loadCollectionWithId(id: String, completion: CollectionType -> Void) {
    
  }
  
  func saveCollection(collection: CollectionType, id: String, completion: (Void -> Void)? = nil) {
    
  }
}
*/

class CollectionManager {
  let datastore: Datastore
  
  init(datastore: Datastore) {
    self.datastore = datastore
  }
  
  func loadCollectionWithId(id: String, completion: Collection -> Void) {
    
  }
  
  func saveCollection(collection: Collection, id: String, completion: (Void -> Void)? = nil) {
    
  }
}