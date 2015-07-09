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
  func putData(data: [DatastoreEntry], completion: ((success: Bool) -> Void)?)
  func getValueForKey(key: String) -> AnyObject?
}