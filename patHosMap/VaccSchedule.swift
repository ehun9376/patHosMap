//
//  VaccSchedule.swift
//  patHosMap
//
//  Created by anna on 2020/7/20.
//  Copyright © 2020 陳逸煌. All rights reserved.
//

import UIKit

struct vaccReminder
{
    var title = ""
    var date = Date.init()
    var done = false
}

class VaccSchedule: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var listTable: UITableView!
    
    var Vacc = ["三合一","三合一","結紮","狂犬病","三合一＆狂犬病","三合一＆狂犬病","三合一＆狂犬病","三合一＆狂犬病"]
    
    var strucRow = vaccReminder()
    var vaccTable = [vaccReminder]()
    var currentRow = 0
    //var vaccDate = Date.init()
    var vaccDate:Date?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return Vacc.count
        return vaccTable.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let cell:UITableViewCell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = vaccTable[indexPath.row].title
        let date: Date = Date()
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        dateFormatter.locale = Locale(identifier: "zh_Hant_TW") // 設定地區(台灣)
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Taipei") // 設定時區(台灣)
        let dateFormatString: String = dateFormatter.string(from: vaccTable[indexPath.row].date)
        cell.detailTextLabel?.text = dateFormatString
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        if vaccTable[indexPath.row].done == true{
            cell.accessoryType = UITableViewCell.AccessoryType.none
            vaccTable[indexPath.row].done = false
            print("現在done = false \(vaccTable[indexPath.row])")
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
            vaccTable[indexPath.row].done = true
            print("現在done = true \(vaccTable[indexPath.row])")
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete{
            Vacc.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "疫苗施打紀錄"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "儲存", style: .plain, target: self, action: #selector(buttonAddAction))
        // Do any additional setup after loading the view.
        self.listTable.dataSource = self
        self.listTable.delegate = self
        vaccTable = [
        vaccReminder(title: "8週三合一", date: vaccDate!, done: false),
        vaccReminder(title: "16週三合一", date: vaccDate!, done: false),
        vaccReminder(title: "結紮", date: vaccDate!, done: false),
        vaccReminder(title: "狂犬病", date: vaccDate!, done: false),
        vaccReminder(title: "1歲-三合一＆狂犬病", date: vaccDate!, done: false),
        vaccReminder(title: "2歲-三合一＆狂犬病", date: vaccDate!, done: false),
        vaccReminder(title: "3歲-三合一＆狂犬病", date: vaccDate!, done: false),
        ]
    }
    
    @objc func buttonAddAction(){
        print("儲存按鈕被按下")
//        let addVC = self.storyboard!.instantiateViewController(identifier: "AddAnimal") as! AddAnimal
//        addVC.vaccTableViewController = self
//        self.show(addVC, sender: nil)
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
