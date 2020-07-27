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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "新增", style: .plain, target: self, action: #selector(buttonAddAction))
        
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        print("資料載入中")
        var section = 0
        DispatchQueue.main.async {
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
            section = self.userFavoriteNameArray.count
        }
        else if signal == 2{
            let alert = UIAlertController(title: "警告", message: "找不到資料", preferredStyle: .alert)
            let button = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (button) in
            }
            alert.addAction(button)
            self.present(alert, animated: true, completion: {})
            section = 0
        }
        return section
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
            print("刪除按鈕被按下")
            //刪除本地也要刪除資料庫
//            print("刪除前陣列：\(self.userFavoriteNameArray!)")
//            self.userFavoriteNameArray.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//            //
//            let datafavorite =  self.root.child("user").child("\(self.userID)").child("favorite")
//            datafavorite.setValue(self.userFavoriteNameArray)
//
//            //
//            print("刪除後陣列：\(self.userFavoriteNameArray!)")
            
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
    @objc func buttonEditAction()
    {
        print("編輯按鈕被按下")
    }
    @objc func buttonAddAction(){
        print("新增按鈕被按下")
    }
}
