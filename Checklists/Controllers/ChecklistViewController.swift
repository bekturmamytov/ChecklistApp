//
//  ViewController.swift
//  Checklists
//
//  Created by Bektur Mamytov on 15/1/23.
//

import UIKit

class ChecklistViewController: UITableViewController {
    var items = [ChecklistItem]()
    var checklist: Checklist!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        //load items from phone memory
        loadChecklistItem()
               
        title = checklist.name
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
        //save data to phone memory or delete
        saveChecklistItems()
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
        
        //save data to phone memory
        saveChecklistItems()
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
        //save data to phone memory
        saveChecklistItems()
    }
    
    func addItemViewController(_ controller: AddItemViewController, didFinishEditing item: ChecklistItem) {
        if let index = items.firstIndex(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
            }
        }
        navigationController?.popViewController(animated: true)
        //save data to phone memory
        saveChecklistItems()
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

//MARK: - Get file path and save/load data

extension ChecklistViewController {
    
    // Get the file path
    
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Cheklists.plist")
    }
    
    // Save data
    func saveChecklistItems() {
        //1. create encoder to encode the items array
        let encoder = PropertyListEncoder()
        //2. error cathching block do/catch
        do {
            //3.  try to encode items array by using encoder. if there is any error during the encoding prosses we will catch on //5. 'try' keyword means that call encode can fail and throw an error. in case of fail code excecution will drop to catch block.
            let data = try encoder.encode(items)
            //4.if data successfully created then write the data to filePath. write method can throw an error that's why we are using 'try' keyword.
            try data.write(
                to: dataFilePath(),
                options: Data.WritingOptions.atomic)
            //5. this block will work when do block fails.
        } catch {
            //6. handle the catch error.
            print("Error encoding item array: \(error.localizedDescription)")
        }
    }
    
    func loadChecklistItem() {
        //1. put the result of dataFilePath(returns URL) to path.
        let path = dataFilePath()
        //2. try to load contents of .plist into new data object.
        if let data = try? Data(contentsOf: path) {
            //3.when find the items we will decode to CheklistItem data format.
            let decoder = PropertyListDecoder()
            do {
                //4. Load the data
                items = try decoder.decode([ChecklistItem].self, from: data)
            } catch {
                print("Error decoding item array: \(error.localizedDescription)")
            }
        }
    }
}
