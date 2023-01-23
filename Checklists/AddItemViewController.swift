//
//  AddItemViewController.swift
//  Checklists
//
//  Created by Bektur Mamytov on 20/1/23.
//

import UIKit

//1.Define a delegate protocol for object B
protocol AddItemViewControllerDelegate: AnyObject {
    func addItemViewControllerDidCancel(_ controller: AddItemViewController)
    func addItemViewController(_ controller: AddItemViewController, didFinishAdding item: ChecklistItem)
}

class AddItemViewController: UITableViewController {
    
    var itemToEdit: ChecklistItem?

    @IBOutlet weak var textFIeld: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    //2. Give object B an optional delegate variable. This variable should be weak.
    // To avoid 'ownership cycles' you can make one of these references weak. Therefore, delegates are always made weak.
    weak var delegate: AddItemViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //to hook up textfield delegate to VC
        textFIeld.delegate = self
        navigationItem.largeTitleDisplayMode = .never
        
        // item is temporary constant, temp. constant now contains optional variable and temp. constant is only available from within this code block.
        if let item = itemToEdit {
            title = "Edit Item"
            textFIeld.text = item.text
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textFIeld.becomeFirstResponder()
    }
    
    @IBAction func cancel() {
        //3. Update delegate when something happened (pressed button).
        delegate?.addItemViewControllerDidCancel(self)
    }
    
    @IBAction func done() {
        
        //3. Update delegate when something happened (pressed button).
        let item = ChecklistItem()
        item.text = textFIeld.text!
        
        delegate?.addItemViewController(self, didFinishAdding: item)
    }


}

//MARK: - Table View Delegate

extension AddItemViewController {
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
}

//MARK: - Text Field Delegate

extension AddItemViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        
        if newText.isEmpty {
            doneBarButton.isEnabled = false
        } else {
            doneBarButton.isEnabled = true
        }
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneBarButton.isEnabled = false
        return true
    }
}
