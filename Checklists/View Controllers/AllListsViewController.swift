//
//  AllListsViewController.swift
//  CheckdataModel.lists
//
//  Created by Xiao Quan on 12/22/21.
//

import UIKit

class AllListsViewController: UITableViewController {
    
    let cellIdentifier = "ChecklistCell"
    var dataModel: DataModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
//        tableView.register(
//            UITableViewCell.self,
//            forCellReuseIdentifier: cellIdentifier)
        
        dataModel.loadChecklists()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.delegate = self
        
        let checklistIndex = dataModel.indexOfSelectedList
        print("\n>>>---ViewDidAppear---")
        print("Set self as navigation controller delegate")
        print("Retrieved checklistIndex from UserDefaults as: ", checklistIndex)
        print("---ViewDidAppear--->>>\n")
        
        if checklistIndex >= 0 && checklistIndex < dataModel.lists.count {
            let checklist = dataModel.lists[checklistIndex]
            
            performSegue(
                withIdentifier: "ShowChecklist",
                sender: checklist)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowChecklist" {
            let viewContorller = segue.destination as! ChecklistViewController
            let checklist = sender as? Checklist
            viewContorller.checklist = checklist
        }
        
        if segue.identifier == "EditChecklist" {
            let controller = segue.destination as! ListDetailViewController
            let listToEdit = sender as? Checklist
            controller.listToEdit = listToEdit
            controller.delegate = self
        }
        
        if segue.identifier == "AddChecklist" {
            let controller = segue.destination as! ListDetailViewController
            controller.delegate = self
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataModel.lists.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)

        let cell: UITableViewCell!
        if let temp = tableView.dequeueReusableCell(
            withIdentifier: cellIdentifier) {
            cell = temp
        } else {
            cell = UITableViewCell(
                style: .subtitle,
                reuseIdentifier: cellIdentifier)
        }
        
        let checklist = dataModel.lists[indexPath.row]
        let numItems = checklist.items.count
        let numUnchecked = checklist.countUncheckedItems()
        cell.textLabel!.text = checklist.name
    
        cell.detailTextLabel!.text = numItems == 0 ? "List Empty 📭" :
                                     numUnchecked == 0 ? "All Done 👏" :
                                     "\(numUnchecked) items"
        cell.accessoryType = .detailDisclosureButton
        
        let iconName = checklist.iconName
        cell.imageView?.image = UIImage(systemName: iconName)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        dataModel.indexOfSelectedList = indexPath.row
        
        print("\n>>>---segue into row \(indexPath.row)---")
        print("Set ChecklistIndex to: ", indexPath.row)
        print("---segue into row \(indexPath.row)--->>>\n")
        
        let checklist = dataModel.lists[indexPath.row]
        performSegue(withIdentifier: "ShowChecklist", sender: checklist)
        
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        
        let listToEdit = dataModel.lists[indexPath.row]
        performSegue(withIdentifier: "EditChecklist", sender: listToEdit)
        
//        let controller = storyboard!.instantiateViewController(withIdentifier: "ListDetailViewController") as! ListDetailViewController
//        controller.delegate = self
//
//        let checklist = dataModel.lists[indexPath.row]
//        controller.listToEdit = checklist
//
//        navigationController?.pushViewController(controller, animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        dataModel.lists.remove(at: indexPath.row)
        
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    

}

// MARK: - ListDetailViewController Delegate Methods

extension AllListsViewController: ListDetailViewControllerDelegate {
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding item: Checklist) {
        dataModel.lists.append(item)
        
        let indexPath = IndexPath(row: dataModel.lists.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        
        navigationController?.popViewController(animated: true)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing list: Checklist) {
        if let position = dataModel.lists.firstIndex(of: list) {
            let indexPath = IndexPath(row: position, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                cell.textLabel!.text = list.name
            }
        }
        
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - NavigationController Delegate

extension AllListsViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController === self {
            dataModel.indexOfSelectedList = -1
            print("\n>>>---UINavigationControllerDelegate---")
            print("Came back to home screen")
            print("Set checklist index to -1")
            print("---UINavigationControllerDelegate--->>>\n")
        }
    }
}
