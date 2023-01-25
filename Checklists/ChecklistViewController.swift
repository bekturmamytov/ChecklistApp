//
//  ViewController.swift
//  Checklists
//
//  Created by Bektur Mamytov on 15/1/23.
//

import UIKit

class ChecklistViewController: UITableViewController {
    var items = [ChecklistItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let item1 = ChecklistItem()
        item1.text = "Walk the dog"
        items.append(item1)
        
        let item2 = ChecklistItem()
        item2.text = "Brush my teeth"
        item2.checked = true
        items.append(item2)
        
        let item3 = ChecklistItem()
        item3.text = "Learn iOS Development"
        item3.checked = true
        items.append(item3)
        
        let item4 = ChecklistItem()
        item4.text = "Soccer practice"
        items.append(item4)
        
        let item5 = ChecklistItem()
        item5.text = "Eat ice cream"
        item5.checked = true
        items.append(item5)
    }
    
    func configureChackmark(for cell: UITableViewCell, with item: ChecklistItem) {
        // how to access the label by using tag number inside the cell.
        let label = cell.viewWithTag(1001) as! UILabel
        
        if item.checked {
            label.text = "√"
        } else {
            label.text = ""
        }
    }
    
    func configureText(for cell: UITableViewCell, with item: ChecklistItem) {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }
    
}

//MARK: - Table View Data Source
extension ChecklistViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        
        let item = items[indexPath.row]
        
        configureText(for: cell, with: item)
        // cell yaratilmadan once cell configure edilmesini saglayan method
        configureChackmark(for: cell, with: item)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // remove data from the array
        items.remove(at: indexPath.row)
        //update table view or remove row from the table view
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
}

//MARK: - Table View Delegate

extension ChecklistViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = items[indexPath.row]
            item.checked.toggle()
            
            configureChackmark(for: cell, with: item)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}

//MARK: - Add Item View Controller Delegate
// 4. Make object a conform the delegate protocol.
extension ChecklistViewController: AddItemViewControllerDelegate {
    func addItemViewControllerDidCancel(_ controller: AddItemViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func addItemViewController(_ controller: AddItemViewController, didFinishAdding item: ChecklistItem) {
        // configure index number in tableview
        let newRowIndex = items.count
        // add new item to array
        items.append(item)
        // add table view new row
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        //close AddI Items screen
        navigationController?.popViewController(animated: true)
    }
    
    func addItemViewController(_ controller: AddItemViewController, didFinishEditing item: ChecklistItem) {
        if let index = items.firstIndex(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    
    
}

//MARK: - Navigation (send data from one view to another)
// Tell objetc B that object A is now its delegate.
extension ChecklistViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //1. Find a right segue address
        if segue.identifier == "AddItem" {
            //2. Casting the destination, because destination is UIViewController. AddItemVC is UIVC's subclass. This is the force (!) downcasting.
            let controller = segue.destination as! AddItemViewController
            //3. Set AddViewController's delegate property as self(ChecklistViewController).
            controller.delegate = self
            
            //TODO: - RECAP ChecklistViewController is now delegate of AddViewController.
        } else if segue.identifier == "EditItem" {
            let controller = segue.destination as! AddItemViewController
            controller.delegate = self
            
            //indexPath() return type is optional thats why we are using if let to unwrap the optional value. Than we are casting sender (Any?) to UITableViewCell.
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                //assign to itemToEdit an item inside the items with related indexPath.row.
                controller.itemToEdit = items[indexPath.row]
            }
        }
    }
}
