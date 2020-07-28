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
}

class VaccSchedule: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var listTable: UITableView!
    
    var Vacc = ["三合一","三合一","結紮","狂犬病","三合一＆狂犬病","三合一＆狂犬病","三合一＆狂犬病","三合一＆狂犬病"]
    
    var strucRow = vaccReminder()
    var vaccTable = [vaccReminder]()
    var currentRow = 0
    var vaccDate = Date.init()
    
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
        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCell.AccessoryType.checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
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
        vaccReminder(title: "三合一", date: vaccDate),
        vaccReminder(title: "三合一", date: vaccDate),
        vaccReminder(title: "結紮", date: vaccDate),
        vaccReminder(title: "狂犬病", date: vaccDate),
        vaccReminder(title: "三合一＆狂犬病", date: vaccDate),
        vaccReminder(title: "三合一＆狂犬病", date: vaccDate),
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
