//
//  Created by Nick Snyder on 6/27/15.
//  Copyright (c) 2015 Example. All rights reserved.
//

import Foundation


protocol Datastore {
  func putData(data: [String: DatastoreValue?], completion: ((success: Bool) -> Void)?)
  func getValueForKey(key: String) -> AnyObject?
}

protocol DatastoreValue {
  func immutableCopy() -> AnyObject // TODO: do generic types correctly
}