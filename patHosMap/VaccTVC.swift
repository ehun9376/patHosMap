//
//  VaccTVC.swift
//  patHosMap
//
//  Created by anna on 2020/7/27.
//  Copyright © 2020 陳逸煌. All rights reserved.
//

import UIKit
import Firebase
class VaccTVC: UITableViewController {
    var array:[[String:String]]!
    var root:DatabaseReference!
    var userID = 0
    var signal = 0
    var count = 0

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.signal = 0
        self.tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
     
 
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("資料載入中")
        var section = 0
        let mypet_data_center:UserDefaults
        mypet_data_center = UserDefaults.init()
        self.userID = mypet_data_center.integer(forKey: "userID") - 1
        self.root = Database.database().reference()
        let addPet = self.root.child("mypet").child("\(self.userID)")
        addPet.observeSingleEvent(of: .value) { (shot) in
            let data = shot.value! as! [[String:String]]
            print(data)
            if data != []{
                self.array = data
                print(self.array!)
                self.signal = 1
            }
            else {
                self.signal = 2
            }
//            print(data)
//            self.array = data
        }
      
        if signal == 0{
            let alert = UIAlertController(title: "警告", message: "資料下載中", preferredStyle: .alert)
            let button = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (button) in
                self.tableView.reloadData()
            }
            alert.addAction(button)
            self.present(alert, animated: true, completion: {})
        }
        else if signal == 1 {
            section = self.array.count
        }
        else if signal == 2 {
            let alert = UIAlertController(title: "警告", message: "找不到資料", preferredStyle: .alert)
            let button = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (button) in
            }
            alert.addAction(button)
            self.present(alert, animated: true,completion: {})
            section = 0
        }
          return section
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell()
        cell.textLabel?.text=self.array[indexPath.row]["name"]
        return cell
    }
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


}
