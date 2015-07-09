//
//  Created by Nick Snyder on 7/2/15.
//  Copyright (c) 2015 Example. All rights reserved.
//

import Foundation

protocol ModelType {
  init?(data: ModelData?)
  func getModelId() -> String
  func toData() -> ModelData
}

typealias ModelData = [String: AnyObject]

/*
protocol NetworkModel: ModelType {
  init?(data: NetworkData?)
  func toData() -> NetworkData
}*/

