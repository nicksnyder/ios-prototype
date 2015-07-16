//
//  Created by Nick Snyder on 6/30/15.
//  Copyright (c) 2015 Example. All rights reserved.
//

import Foundation

typealias JsonCompletion = (json: [String: AnyObject]?, response: NSURLResponse?, error: NSError?) -> Void

class NetworkClient {
  
  static var sharedInstance = NetworkClient()

  private static let errorDomain = "NetworkClient"
  
  let session: NSURLSession = {
    var conf = NSURLSessionConfiguration.defaultSessionConfiguration()
    //conf.protocolClasses = [FixtureProtocol.self] as? AnyObject
    //conf.protocolClasses = [FixtureURLProtocol.self]
    conf.protocolClasses = [SwiftFixtureProtocol.self]
    return NSURLSession(configuration: conf)
  }()
  
  func getJsonDataWithURL(urlString: String, completion: JsonCompletion) -> NSURLSessionDataTask? {
    let url = NSURL(string: urlString)!
    let task = session.dataTaskWithURL(url, completionHandler: wrapJsonCompletion(completion))
    task?.resume()
    return task
  }
  
  private func wrapJsonCompletion(completion: JsonCompletion) -> (NSData?, NSURLResponse?, NSError?) -> Void {
    return { (data: NSData?, response: NSURLResponse?, var error: NSError?) -> Void in
      var json: [String: AnyObject]? = nil
      if let data = data where error == nil {
        do {
          json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) as? [String: AnyObject]
        } catch let jsonError as NSError {
          error = jsonError
        } catch {
          //error = NSError(domain: NetworkClient.errorDomain, code: 1000, userInfo: nil)
        }
      }
      dispatch_async(dispatch_get_main_queue(), { () -> Void in
        completion(json: json, response: response, error: error)
      })
    }
  }
}
