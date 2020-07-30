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
        self.root = Database.database().reference()
        //抬頭及在左右兩側增加編輯與新增
        self.navigationItem.title = "我的寵物"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "編輯", style: .plain, target: self, action: #selector(buttonEditAction))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "新增", style: .plain, target: self, action: #selector(buttonAddAction))
    }

    @objc func buttonEditAction()
    {
        print("編輯按鈕被按下")
        if !self.tableView.isEditing//如果表格不在編輯狀態
        {
        self.tableView.isEditing = true
        self.navigationItem.leftBarButtonItem?.title = "完成"
        }
        else
        {
            self.tableView.isEditing = false
            self.navigationItem.leftBarButtonItem?.title = "編輯"
        }
    }
    @objc func buttonAddAction(){
        print("新增按鈕被按下")
        let addVC = self.storyboard!.instantiateViewController(identifier: "AddAnimal") as! AddAnimal
        addVC.VaccTVC = self
        self.show(addVC, sender: nil)
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
            if data != [["birthday": "", "name": "", "kind": ""]]{
                self.array = data
                print(self.array!)
                self.signal = 1
            }
            else {
                self.signal = 2
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
    //畫面轉入VaccSchedule
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    count = indexPath.row
    let VaccS = self.storyboard?.instantiateViewController(identifier: "VaccSchedule") as! VaccSchedule
        self.show(VaccS, sender: nil)
        let d1 = array[indexPath.row]["birthday"]!
        let str = stringConvertDate(string: d1)
        print(str)
        VaccS.vaccDate = str
        VaccS.petName = array[indexPath.row]["name"]!
    }
    
    
    //左滑修改及刪除
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?{
        //準備"修改"按鈕
        let actionMore = UIContextualAction(style: .normal, title: "修改") { (action, view, completionHanlder) in
            let DetailAnimalVC = self.storyboard?.instantiateViewController(identifier: "DetailAnimalViewController") as! DetailAnimalViewController
                self.show(DetailAnimalVC, sender: nil)
            DetailAnimalVC.petID = indexPath.row
            print("修改按鈕被按下")
        }
        actionMore.backgroundColor = .blue
        //準備"刪除"按鈕//todo尚未完全
        let actionDelete = UIContextualAction(style: .normal, title: "刪除") { (action, view, completionHanlder) in
            print("刪除按鈕被按下")
            self.array.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.root = Database.database().reference()
            let delPet = self.root.child("mypet").child("\(self.userID)")
            delPet.setValue(self.array!)
            print("刪除後陣列：\(self.array!)")
        }
        actionDelete.backgroundColor = .systemPink
        //將兩個按鈕合併
        let config = UISwipeActionsConfiguration(actions: [actionDelete,actionMore])
        config.performsFirstActionWithFullSwipe = true
        //回傳按鈕組合
        return config
    }
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath){
        print("排序前陣列\(self.array!)")
        self.array!.insert(self.array!.remove(at: fromIndexPath.row), at: to.row)
        let movePet = self.root.child("mypet").child("\(self.userID)")
        movePet.setValue(self.array!)
    }
    
    func stringConvertDate(string:String, dateFormat:String="MMM dd, yyyy") -> Date {
            let dateFormatter = DateFormatter.init()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            let date = dateFormatter.date(from: string)
            return date!
    }
}
