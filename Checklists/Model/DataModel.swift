//
//  DataModel.swift
//  Checklists
//
//  Created by Bektur Mamytov on 12/2/23.
//

import Foundation

class DataModel {
    var lists = [Checklist]()
    
    init() {
        loadChecklists()
    }
    //MARK: - Data Saving
    
    // Get the file path
    
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print("DEBUG: \(paths)")
        return paths[0]
    }
    
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Cheklists.plist")
    }
    
    // Save data
    func saveChecklists() {
        //1. create encoder to encode the items array
        let encoder = PropertyListEncoder()
        //2. error cathching block do/catch
        do {
            //3.  try to encode items array by using encoder. if there is any error during the encoding prosses we will catch on //5. 'try' keyword means that call encode can fail and throw an error. in case of fail code excecution will drop to catch block.
            let data = try encoder.encode(lists)
            //4.if data successfully created then write the data to filePath. write method can throw an error that's why we are using 'try' keyword.
            try data.write(
                to: dataFilePath(),
                options: Data.WritingOptions.atomic)
            //5. this block will work when do block fails.
        } catch {
            //6. handle the catch error.
            print("Error encoding list array: \(error.localizedDescription)")
        }
    }
    
    func loadChecklists() {
        //1. put the result of dataFilePath(returns URL) to path.
        let path = dataFilePath()
        //2. try to load contents of .plist into new data object.
        if let data = try? Data(contentsOf: path) {
            //3.when find the items we will decode to CheklistItem data format.
            let decoder = PropertyListDecoder()
            do {
                //4. Load the data
                lists = try decoder.decode([Checklist].self, from: data)
            } catch {
                print("Error decoding list array: \(error.localizedDescription)")
            }
        }
    }
    
    
}
