//
//  Created by Nick Snyder on 6/30/15.
//  Copyright (c) 2015 Example. All rights reserved.
//

import Foundation

class FixtureURLProtocol: NSURLProtocol {
  override class func canInitWithRequest(request: NSURLRequest) -> Bool {
    NSLog("can init with request")
    return false
  }

  override class func canonicalRequestForRequest(request: NSURLRequest) -> NSURLRequest {
    return request
  }
  
  override class func requestIsCacheEquivalent(a: NSURLRequest, toRequest b: NSURLRequest) -> Bool {
    return false
  }
  
  override func startLoading() {
    NSLog("start loading")
  }
  
  override func stopLoading() {
    NSLog("stop loading")
  }
}
