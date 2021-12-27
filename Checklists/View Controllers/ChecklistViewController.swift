//
//  ViewController.swift
//  Checklists
//
//  Created by Xiao Quan on 12/1/21.
//

import UIKit

class ChecklistViewController: UITableViewController {
    var checklist: Checklist!
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        title = checklist.name
        
    }
    
    // MARK: - Navigation Segue Setup
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ItemDetail" {
            let destinationViewController = segue.destination as! ItemDetailViewController
            destinationViewController.delegate = self
        }
        
        if segue.identifier == "EditItem" {
            let destinationViewController = segue.destination as! ItemDetailViewController
            destinationViewController.delegate = self
            
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                destinationViewController.itemToEdit = checklist.items[indexPath.row]
            }
        }
    }
    
    // MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklist.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        let item = checklist.items[indexPath.row]
        
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = checklist.items[indexPath.row]
            
            item.completed.toggle()
            configureCheckmark(for: cell, with: item)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    // Delete Item
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        checklist.items.remove(at: indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    
    }
    
    // MARK: - Cell Configuration Methods
    private func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem) {
        let checkmark = cell.viewWithTag(101) as! UILabel
        
        checkmark.text = item.completed ? "✔️" : ""
        if checkmark.text == "✔️" {
            item.deleteReminder()
        }
    }
    
    private func configureText(for cell: UITableViewCell, with item: ChecklistItem) {
        let label = cell.viewWithTag(100) as! UILabel
        label.text = item.text
    }
}

// MARK: - ItemDetailViewController Delegate Methods

extension ChecklistViewController: ItemDetailViewControllerDelegate {
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        navigationController?.popViewController(animated: true)

    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
        checklist.items.append(item)
        
        let indexPath = IndexPath(row: checklist.items.count - 1, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        navigationController?.popViewController(animated: true)
        
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem) {

        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        navigationController?.popViewController(animated: true)
    }
}
