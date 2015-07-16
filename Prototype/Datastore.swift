//
//  Created by Nick Snyder on 6/27/15.
//  Copyright (c) 2015 Example. All rights reserved.
//

import Foundation

struct DatastoreEntry {
  let key: String
  let immutableValue: AnyObject
}

protocol Datastore {
  func putEntries(entries: [DatastoreEntry], completion: ((success: Bool) -> Void)?)
  func getValueForKey(key: String) -> Any? // TODO: implement this in protocol extension
  func getValuesForKeys(keys: [String], completion: (values: [Any]) -> Void)
  //func getValueForKey(key: String, completion: AnyObject? -> Void)
}

extension Datastore {
  func getValueForKey(key: String, completion: Any? -> Void) {
    getValuesForKeys([key], completion: { (values: [Any]) -> Void in
      completion(values.first)
    })
  }
}