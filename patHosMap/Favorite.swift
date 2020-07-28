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
    var datafavorite:DatabaseReference!
    var userFavoriteName:String!
    var userID = 0
    var userFavoriteNameArray:[String]!
    var signal = 0
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.signal = 0
        self.tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.download()
        self.root = Database.database().reference()
        self.navigationItem.title = "我的最愛"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "編輯", style: .plain, target: self, action: #selector(buttonEditAction))
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        print("資料載入中")
        var rows = 0
        DispatchQueue.main.async {
            let little_data_center:UserDefaults
            little_data_center = UserDefaults.init()
            self.userID = little_data_center.integer(forKey: "userID") - 1
            self.root = Database.database().reference()
            self.datafavorite =  self.root.child("user").child("\(self.userID)").child("favorite")
            self.datafavorite.observeSingleEvent(of: .value) { (shot) in
                let data = shot.value! as! String
                if data != ""{
                    self.userFavoriteNameArray = data.components(separatedBy: ",")
                    print(self.userFavoriteNameArray!)
                    self.signal = 1
                }
                else{
                    self.signal = 2
                }
            }
        }
        if signal == 0{
            let alert = UIAlertController(title: "警告", message: "資料下載中", preferredStyle: .alert)
            let button = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (button) in
                self.tableView.reloadData()
            }
            alert.addAction(button)
            self.present(alert, animated: true, completion: {})
        }
        else if signal == 1{
            rows = self.userFavoriteNameArray.count
        }
        else if signal == 2{
            let alert = UIAlertController(title: "警告", message: "找不到資料", preferredStyle: .alert)
            let button = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (button) in
            }
            alert.addAction(button)
            self.present(alert, animated: true, completion: {})
            rows = 0
        }
        return rows
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell:UITableViewCell = UITableViewCell()
        cell.textLabel?.text = self.userFavoriteNameArray[indexPath.row]
        return cell
    }
    // MARK: - Table view Delegate
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath){
        self.userFavoriteNameArray!.insert(self.userFavoriteNameArray!.remove(at: fromIndexPath.row), at: to.row)
        self.datafavorite =  self.root.child("user").child("\(self.userID)").child("favorite")
        self.datafavorite.setValue(self.userFavoriteNameArray!.joined(separator: ","))
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        self.userFavoriteNameArray!.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        self.datafavorite =  self.root.child("user").child("\(self.userID)").child("favorite")
        self.datafavorite.setValue(self.userFavoriteNameArray!.joined(separator: ","))
    }
    
    // MARK: - 自訂函式
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
    @objc func buttonEditAction(){
        print("編輯按鈕被按下")
        if !self.tableView.isEditing{
        self.tableView.isEditing = true
        self.navigationItem.leftBarButtonItem?.title = "完成"
        }
        else{
            self.tableView.isEditing = false
            self.navigationItem.leftBarButtonItem?.title = "編輯"
        }

    }
}
