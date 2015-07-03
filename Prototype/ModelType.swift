//
//  Created by Nick Snyder on 7/2/15.
//  Copyright (c) 2015 Example. All rights reserved.
//

import Foundation

protocol ModelType {
  func getModelId() -> String
}

protocol NetworkModel: ModelType {
  init?(data: NetworkData?)
  func toData() -> NetworkData
}