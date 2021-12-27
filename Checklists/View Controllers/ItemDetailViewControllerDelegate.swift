//
//  ItemDetailViewControllerDelegate.swift
//  Checklists
//
//  Created by Xiao Quan on 12/3/21.
//

import Foundation

protocol ItemDetailViewControllerDelegate: AnyObject {
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController)
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem)
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem)
}
