//
//  IconListViewController.swift
//  Checklists
//
//  Created by Xiao Quan on 12/26/21.
//

import Foundation
import UIKit

class IconListViewController: UITableViewController {
    let iconSystemNames = [
        "exclamationmark",
        "heart.circle",
        "folder",
        "percent",
        "seal",
        "pills",
        "brain.head.profile",
        "eye",
        "gamecontroller",
        "paperclip",
        "graduationcap",
        "bookmark",
        "umbrella",
        "eyeglasses",
        "facemask",
        "camera",
        "scissors",
        "wand.and.stars",
        "dial.min",
        "paintbrush",
        "pianokeys",
        "ruler",
        "hammer",
        "briefcase",
        "theatermasks",
        "lock",
        "key",
        "map",
        "headphones",
        "bed.double",
        "cup.and.saucer",
        "fork.knife",
        "lightbulb"
    ]
    
    weak var delegate: IconListViewControllerDelegate!
    var selectedIcon = "exclamationmark"
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return iconSystemNames.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IconCell")!
        
        let index = indexPath.row
        cell.imageView?.image = UIImage(systemName: iconSystemNames[index])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIcon = iconSystemNames[indexPath.row]
        delegate.iconList(self, didSelect: selectedIcon)
    }
}

protocol IconListViewControllerDelegate: AnyObject {
    func iconList(_ list: IconListViewController, didSelect iconName: String)
}
