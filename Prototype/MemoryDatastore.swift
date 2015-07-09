//
//  Created by Nick Snyder on 6/27/15.
//  Copyright (c) 2015 Example. All rights reserved.
//

import Foundation

class MemoryDatastore: Datastore {
  
  private var data = [String: AnyObject]()
  
  /*
  func putData(data: [String : DatastoreValue?], completion: ((success: Bool) -> Void)?) {
    for (key, value) in data {
      self.data[key] = value?.immutableCopy()
    }
    completion?(success: true)
  }*/
  
  func putData(data: [DatastoreEntry], completion: ((success: Bool) -> Void)?) {
    for entry in data {
      self.data[entry.key] = entry.immutableValue
    }
    completion?(success: true)
  }
  
  func getValueForKey(key: String) -> AnyObject? {
    return data[key]
  }
}