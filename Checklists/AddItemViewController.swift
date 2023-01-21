//
//  AddItemViewController.swift
//  Checklists
//
//  Created by Bektur Mamytov on 20/1/23.
//

import UIKit

class AddItemViewController: UITableViewController {

    @IBOutlet weak var textFIeld: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //to hook up textfield delegate to VC
        textFIeld.delegate = self
        
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textFIeld.becomeFirstResponder()
    }
    
    @IBAction func cancel() {
        //this line of code tells the nav controller to close the add item screen and send to previous layer.
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func done() {
        
        print("Contents of the text field: \(textFIeld.text!)")
        
        navigationController?.popViewController(animated: true)
    }


}

//MARK: - Tabel View Delegate

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
