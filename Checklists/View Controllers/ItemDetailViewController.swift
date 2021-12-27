//
//  ItemDetailViewController.swift
//  Checklists
//
//  Created by Xiao Quan on 12/2/21.
//

import UIKit

class ItemDetailViewController: UITableViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var setReminderToggle: UISwitch!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    weak var delegate: ItemDetailViewControllerDelegate?
    
    var itemToEdit: ChecklistItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let item = itemToEdit {
            title = "Edit Item"
            textField.text = item.text
            doneBarButton.isEnabled = true
            setReminderToggle.isOn = item.requireReminder
            datePicker.date = item.dueDate
        }
        
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        textField.becomeFirstResponder()
    }
    
    @IBAction func setReminderToggled() {
        textField.resignFirstResponder()
        
        if setReminderToggle.isOn {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(
                options: [.alert, .sound]) { _, _ in
                    // pass
                }

        }
    }
    
    @IBAction func cancel() {
        delegate?.itemDetailViewControllerDidCancel(self)
    }
    
    @IBAction func done() {
        if let item = itemToEdit {
            item.text = textField.text!
            item.requireReminder = setReminderToggle.isOn
            item.dueDate = datePicker.date
            item.setReminder()
            
            delegate?.itemDetailViewController(self, didFinishEditing: item)
        } else {
            let item = ChecklistItem(text: textField.text!)
            item.requireReminder = setReminderToggle.isOn
            item.dueDate = datePicker.date
            item.setReminder()
            delegate?.itemDetailViewController(self, didFinishAdding: item)
            
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
}

// MARK: - Textfield Delegate Methods

extension ItemDetailViewController: UITextFieldDelegate {
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
