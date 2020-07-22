//
//  VaccTableViewController.swift
//  patHosMap
//
//  Created by 陳逸煌 on 2020/7/20.
//  Copyright © 2020 陳逸煌. All rights reserved.
//

import UIKit
struct Animal {
    var name = ""
    var picture:Data?
}
class VaccTableViewController: UITableViewController {
    var structRow = Animal()
    //查詢到的資料表所存放的陣列（用於離線資料集）
    var arrTable = [Animal]()
    var currentRow = 0
    var list:[String]!
    //MARK: -Target Action
    //導覽列的新增按鈕
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
        self.show(addVC, sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        arrTable = [
            Animal(name: "來寶", picture:UIImage(named: "DefaultPhoto.jpg")!.jpegData(compressionQuality: 0.8)),
            Animal(name: "旺福", picture:UIImage(named: "DefaultPhoto.jpg")!.jpegData(compressionQuality: 0.8)),
        ]
        self.navigationItem.title = "我的寵物"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "編輯", style: .plain, target: self, action: #selector(buttonEditAction))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "新增", style: .plain, target: self, action: #selector(buttonAddAction))
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        super.prepare(for: segue, sender: sender)
        print("即將由換頁線換頁")
        //由線換頁取得下一頁
        let detailVC = segue.destination as! AddAnimal
        //將本頁的執行實體通知下一頁
        detailVC.vaccTableViewController = self
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        print("畫面重現：\(arrTable[currentRow])")
        //重整表格（重新執行Table view data source代理事件）
        self.tableView.reloadData()
    }
    
 
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTable.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) as! MyCell
        print("現在準備Section:\(indexPath.section)，Row:\(indexPath.row)")
    structRow = arrTable[indexPath.row]
    cell.lblName.text = structRow.name
        if let aPicture = structRow.picture
        {
            cell.imgPicture.image = UIImage(data: aPicture)

        }
        
    return cell
    }
    
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {   //準備"更多"按鈕
        let actionMore = UIContextualAction(style: .normal, title: "更多") { (action, view, completionHanlder) in
            print("更多按鈕被按下")
        }
        actionMore.backgroundColor = .blue
        //準備"刪除"按鈕
        let actionDelete = UIContextualAction(style: .normal, title: "刪除") { (action, view, completionHanlder) in
            print("刪除前陣列：\(self.list)")
            //step.1先刪除表格對應的該筆陣列資料
            self.list.remove(at: indexPath.row)
             //step2.再刪除介面上的該筆儲存格
            tableView.deleteRows(at: [indexPath], with: .fade)
            print("刪除後陣列：\(self.list)")
        }
        
        actionDelete.backgroundColor = .red
        //將兩個按鈕合併
        let config = UISwipeActionsConfiguration(actions: [actionDelete,actionMore])
        config.performsFirstActionWithFullSwipe = true
        //回傳按鈕組合
        return config
    }



}
