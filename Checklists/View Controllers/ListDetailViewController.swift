//
//  ListDetailViewController.swift
//  Checklists
//
//  Created by Xiao Quan on 12/23/21.
//

import UIKit

class ListDetailViewController: UITableViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var iconImage: UIImageView!
    
    weak var delegate: ListDetailViewControllerDelegate?
    
    var listToEdit: Checklist?
    var iconSelection = "checklist"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let list = listToEdit {
            title = "Edit Checklist"
            textField.text = list.name
            doneBarButton.isEnabled = true
            iconSelection = list.iconName
            iconImage.image = UIImage(systemName: list.iconName)
        }
        iconImage.image = UIImage(systemName: iconSelection)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowIcon" {
            let destinationController = segue.destination as! IconListViewController
            destinationController.delegate = self
        }
    }
    
    
    // MARK: - Tableview Delegate methods
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return indexPath.section == 1 ? indexPath : nil
    }
    
    // MARK: - User Actions
    
    @IBAction func cancel() {
        delegate?.listDetailViewControllerDidCancel(self)
    }
    
    @IBAction func done() {
        if let list = listToEdit {
            list.name = textField.text!
            list.iconName = iconSelection
            delegate?.listDetailViewController(self, didFinishEditing: list)
        } else {
            let list = Checklist(name: textField.text!, items: [], iconName: iconSelection)
            delegate?.listDetailViewController(self, didFinishAdding: list)
        }
    }
}

// MARK: - ListDetail Delegate Methods
protocol ListDetailViewControllerDelegate: AnyObject {
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController)
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding list: Checklist)
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing list: Checklist)
}

// MARK: - Textfield delegate methods
extension ListDetailViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(
            in: stringRange,
            with: string)
        doneBarButton.isEnabled = !newText.isEmpty
        
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneBarButton.isEnabled = false
        
        return true
    }
}

// MARK: IconListViewController Delegate
extension ListDetailViewController: IconListViewControllerDelegate {
    func iconList(_ list: IconListViewController, didSelect iconName: String) {
        self.iconSelection = iconName
        self.iconImage.image = UIImage(systemName: iconName)
        navigationController?.popViewController(animated: true)
    }
}
