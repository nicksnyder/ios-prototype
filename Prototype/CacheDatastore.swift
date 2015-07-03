//
//  Created by Nick Snyder on 6/20/15.
//  Copyright (c) 2015 Example. All rights reserved.
//

import Foundation

class CacheDatastore: Datastore {
  
  let cache = NSCache()
  let parentStore: Datastore?
  
  init(parentStore: Datastore) {
    self.parentStore = parentStore
  }
  
  func putData(data: [String: DatastoreValue?], completion: ((success: Bool) -> Void)?) {
    var immutableData = [String: AnyObject?]()
    for (key, value) in data {
      immutableData[key] = value?.immutableCopy()
    }
    parentStore?.putData(data, completion: { success in
      if success {
        for (key, value) in immutableData {
          if let value: AnyObject = value {
            self.cache.setObject(value, forKey: key)
          } else {
            self.cache.removeObjectForKey(key)
          }
        }
      }
      completion?(success: success)
    })
  }
  
  func getValueForKey(key: String) -> AnyObject? {
    if let value: AnyObject = cache.objectForKey(key) {
      return value
    }
    let value: AnyObject? = parentStore?.getValueForKey(key)
    if let value: AnyObject = value {
      cache.setObject(value, forKey: key)
    }
    return value
  }
}