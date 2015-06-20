//
//  Created by Nick Snyder on 6/18/15.
//  Copyright (c) 2015 Example. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {
  
  let items: [Item] = [
    Item(viewController: RedViewController(), title: "RedViewController", subTitle: "")
  ]

  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Main"
    tableView.registerClass(SubtitleCell.self, forCellReuseIdentifier: SubtitleCell.reuseId)
    self.tableView.tableFooterView = UIView() // Remove ugly separators for empty table view
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let item = items[indexPath.item]
    self.navigationController?.pushViewController(item.viewController, animated: true)
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let item = items[indexPath.item]
    let cell = tableView.dequeueReusableCellWithIdentifier(SubtitleCell.reuseId, forIndexPath: indexPath) as! SubtitleCell
    cell.textLabel?.text = item.title
    cell.detailTextLabel?.text = item.subTitle
    return cell
  }
}

struct Item {
  let viewController: UIViewController
  let title: String
  let subTitle: String
}

class SubtitleCell: UITableViewCell {
  static let reuseId = "SubtitleCell"
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier)
    accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
  }
  
  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}