//
//  Created by Nick Snyder on 7/10/15.
//  Copyright © 2015 Example. All rights reserved.
//

import Foundation

// TODO: generic type
struct VersionedDictionary {
  
  struct Entry {
    let value: Any
    let version: Int
  }
  
  var entries = [String: Entry]()
  var currentVersion: Int = 0
  
  mutating func newVersion() -> Int {
    currentVersion++
    return currentVersion
  }
  
  mutating func setValue(value: Any, forKey key: String, version: Int) {
    entries[key] = Entry(value: value, version: version)
  }
  
  mutating func deleteKey(key: String, withVersion version: Int) {
    if let entry = entries[key] where entry.version <= version {
      entries.removeValueForKey(key)
    }
  }
  
  func getValueForKey(key: String) -> Any? {
    return entries[key]?.value
  }
}
