//
//  Favorite.swift
//  patHosMap
//
//  Created by 陳逸煌 on 2020/7/26.
//  Copyright © 2020 陳逸煌. All rights reserved.
//

import UIKit
import Firebase
class Favorite: UITableViewController {

    var hospitalsArray:[[String:String]] = [[:]]
    var count = 0
    var root:DatabaseReference!
    var userFavoriteName:String!
    var userID = 0
    var userFavoriteNameArray:[String]!
    var signal = false
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let little_data_center:UserDefaults
        little_data_center = UserDefaults.init()
        self.userID = little_data_center.integer(forKey: "userID") - 1
        root = Database.database().reference()
        let datafavorite =  root.child("user").child("\(self.userID)").child("favorite")
        datafavorite.observeSingleEvent(of: .value) { (shot) in
           let data = shot.value! as! String
           if data != ""{
            self.userFavoriteNameArray = data.components(separatedBy: ",")
               print(self.userFavoriteNameArray!)
           }
        }
        self.tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.download()
        let little_data_center:UserDefaults
        little_data_center = UserDefaults.init()
        self.userID = little_data_center.integer(forKey: "userID") - 1
        self.root = Database.database().reference()
        let datafavorite =  self.root.child("user").child("\(self.userID)").child("favorite")
        datafavorite.observeSingleEvent(of: .value) { (shot) in
            let data = shot.value! as! String
            if data != ""{
                self.userFavoriteNameArray = data.components(separatedBy: ",")
                print(self.userFavoriteNameArray!)
                self.signal = true
            }
        }
        
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userFavoriteNameArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell:UITableViewCell = UITableViewCell()
        cell.textLabel?.text = self.userFavoriteNameArray[indexPath.row]
        return cell
    }
    // MARK: - Table view Delegate
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?{
        //準備"更多"按鈕
        let actionMore = UIContextualAction(style: .normal, title: "修改") { (action, view, completionHanlder) in
            print("修改按鈕被按下")
        }
        actionMore.backgroundColor = .blue
        //準備"刪除"按鈕
        let actionDelete = UIContextualAction(style: .normal, title: "刪除") { (action, view, completionHanlder) in
        }
        actionDelete.backgroundColor = .red
        //將兩個按鈕合併
        let config = UISwipeActionsConfiguration(actions: [actionDelete,actionMore])
        config.performsFirstActionWithFullSwipe = true
        //回傳按鈕組合
        return config
    }
        override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
                tableView.deleteRows(at: [indexPath], with: .fade)
        }
    
    // MARK: - 自訂函示
    func download() -> Void {
        let session:URLSession = URLSession(configuration: .default)
        let task:URLSessionDataTask = session.dataTask(with: URL(string:"https://data.coa.gov.tw/Service/OpenData/DataFileService.aspx?UnitId=078&$top=1000&$skip=0")!){
            (data,reponse,err)
            in
            if let error = err{
                let alert = UIAlertController(title: "警告", message: "連線出現問題！\n\(error.localizedDescription)", preferredStyle: .alert)
                let button = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (button) in
                }
                alert.addAction(button)
                self.present(alert, animated: true, completion: {})
            }
            else{
                do{
                    self.hospitalsArray = try JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as! [[String:String]]
                    
                }catch{
                    print("伺服器出錯\(error)")
                }
            }
        }
        task.resume()
    }
}
