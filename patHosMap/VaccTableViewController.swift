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
    var birthday = ""
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
        addVC.vaccTableViewController = self
        self.show(addVC, sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        arrTable = [
            Animal(name: "來寶", picture:UIImage(named: "DefaultPhoto.jpg")!.jpegData(compressionQuality: 0.8), birthday:"2015/06/15"),
            Animal(name: "旺福", picture:UIImage(named: "DefaultPhoto.jpg")!.jpegData(compressionQuality: 0.8), birthday: "2018/08/16"),
        ]
        self.navigationItem.title = "我的寵物"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "編輯", style: .plain, target: self, action: #selector(buttonEditAction))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "新增", style: .plain, target: self, action: #selector(buttonAddAction))
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        print("畫面重現：\(arrTable[currentRow])")
        //重整表格（重新執行Table view data source代理事件）
        self.tableView.reloadData()
    }
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTable.count
    }

    //準備每一儲存格顯示內容
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:UITableViewCell = UITableViewCell()
//        let cell = self.tableView.dequeueReusableCell(withIdentifier: "MyCellTableViewCell", for: indexPath) as! MyCellTableViewCell
        print("現在準備Section:\(indexPath.section)，Row:\(indexPath.row)")
        structRow = arrTable[indexPath.row]
        cell.textLabel!.text = structRow.name
        if let aPicture = structRow.picture
        {
            cell.imageView?.image = UIImage(data: aPicture)
        }
    return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    currentRow = indexPath.row
    let VaccS = self.storyboard?.instantiateViewController(identifier: "VaccSchedule") as! VaccSchedule
        self.show(VaccS, sender: nil)
    }
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath)
    {
        print("移動前：\(fromIndexPath)，移動後：\(to)")
        print("移動前的陣列：\(arrTable)")
        //<方法一>對調移動的來源儲存格與目的地儲存格
        arrTable.insert(arrTable.remove(at: fromIndexPath.row), at: to.row)
        
        /*
        //<方法二>為<方法一>的分階段執行
        //Step1.先記憶即將被移除的陣列元素（一開始的來源位置的元素），同時移除該元素
        let tmp = arrTable.remove(at: fromIndexPath.row)
        //Step2.再將已經移除的元素，往移動的目的地位置安插
        arrTable.insert(tmp, at: to.row)
        */
        
        print("移動後的陣列：\(arrTable)")
    }
        //注意：實作表格的編輯事件之後，表格可以滑動"刪除"
        override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
        {
    //        if editingStyle == .delete
    //        {
                print("刪除前陣列：\(arrTable)")
                //Step1.先刪除表格對應的該筆陣列資料
                arrTable.remove(at: indexPath.row)
                //Step2.再刪除介面上的該筆儲存格
                tableView.deleteRows(at: [indexPath], with: .fade)
                print("刪除後陣列：\(arrTable)")
    //        }
        }
 
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {   //準備"更多"按鈕
        let actionMore = UIContextualAction(style: .normal, title: "修改") { (action, view, completionHanlder) in
            let DetailAnimalVC = self.storyboard?.instantiateViewController(identifier: "DetailAnimalViewController") as! DetailAnimalViewController
                self.show(DetailAnimalVC, sender: nil)
            print("修改按鈕被按下")
        }
        actionMore.backgroundColor = .blue
        //準備"刪除"按鈕
        let actionDelete = UIContextualAction(style: .normal, title: "刪除") { (action, view, completionHanlder) in
            print("刪除前陣列：\(self.arrTable)")
            //step.1先刪除表格對應的該筆陣列資料
            self.arrTable.remove(at: indexPath.row)
             //step2.再刪除介面上的該筆儲存格
            tableView.deleteRows(at: [indexPath], with: .fade)
            print("刪除後陣列：\(self.arrTable)")
        }
        
        actionDelete.backgroundColor = .red
        //將兩個按鈕合併
        let config = UISwipeActionsConfiguration(actions: [actionDelete,actionMore])
        config.performsFirstActionWithFullSwipe = true
        //回傳按鈕組合
        return config
    }



}
