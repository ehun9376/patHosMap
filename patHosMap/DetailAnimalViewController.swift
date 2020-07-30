//
//  DetailAnimalViewController.swift
//  patHosMap
//
//  Created by 123 on 2020/7/22.
//  Copyright © 2020 陳逸煌. All rights reserved.
//

import UIKit
import Firebase

class DetailAnimalViewController: UIViewController,UINavigationControllerDelegate {
    weak var VaccTVC:VaccTVC!
    var currentData = 0
    var userID = 0
    var petID:Int!
    var petdata:[String:String]!
    var root:DatabaseReference!
    var editPet:DatabaseReference!
    var vaccTable = [vaccReminder]()
    var originalPet = ""
    var newPet = ""
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtBirthday: UITextField!
    let Picker = UIDatePicker()
    @IBOutlet weak var imgPicture: UIImageView!
    
    //鍵盤跳出及收回
    @IBAction func editDidBegin(_ sender: UITextField){
        print("開始編輯")
    }
    @IBAction func didEndOnExit(_ sender: UITextField)
    {
        //只需對應，即可按下Return鍵收起鍵盤！
    }
    @objc func keyboardWillShow(_ sender:Notification){
                print("鍵盤彈出！")
    }
    @objc func keyboardWillHide(){
                print("鍵盤收合！")
    }
    //MARK: - 滾輪轉換日期
    func creatDatePicker(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([done], animated: false)
        txtBirthday.inputAccessoryView = toolbar
        txtBirthday.inputView = Picker
        Picker.datePickerMode = .date
    }
    @objc func donePressed(){
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        //formatter.dateFormat = "yyyy.mm.dd"
        formatter.timeStyle = .none
        let dateString = formatter.string(from: Picker.date)
        
        txtBirthday.text = "\(dateString)"
        self.view.endEditing(true)
    }
    //MARK: - 生命循環
    override func viewDidLoad() {
        super.viewDidLoad()
        creatDatePicker()
        let notificationCenter = NotificationCenter.default
        //向通知中心註冊鍵盤彈出通知
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        //向通知中心註冊鍵盤收合通知
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        //todo
        let mypet_data_center:UserDefaults
        mypet_data_center = UserDefaults.init()
        self.userID = mypet_data_center.integer(forKey: "userID") - 1
        print("\(self.petID!)")
        self.root = Database.database().reference()
        self.editPet = self.root.child("mypet").child("\(self.userID)").child("\(self.petID!)/")
        editPet.observeSingleEvent(of: .value) { (shot) in
            self.petdata = (shot.value! as! [String:String])
            self.txtName.text = self.petdata["name"]
            self.txtBirthday.text = self.petdata["birthday"]
            self.originalPet = self.petdata["name"]!
            self.loadlist()
        }

    }

    

    //MARK: - target action
    @IBAction func btnUpdate(_ sender: UIButton) {
        if txtName.text!.isEmpty || txtBirthday.text!.isEmpty{
            let alert = UIAlertController(title: "資料輸入錯誤", message: "任一欄位都不可為空", preferredStyle: .alert)

            let btnok = UIAlertAction(title: "確認", style: .default, handler: nil)
            alert.addAction(btnok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        else{
            self.petdata["name"] = self.txtName.text
            self.newPet = self.txtName.text!
            self.petdata["birthday"] = self.txtBirthday.text
            self.editPet.setValue(petdata)
            let alert = UIAlertController(title: "完成", message: "資料修改成功！", preferredStyle: .alert)
            let btnok = UIAlertAction(title: "確認", style: .default, handler: nil)
            alert.addAction(btnok)
            self.present(alert, animated: true, completion: {})
            self.saveList()
        }
        
    }
    
    func saveList()
    {
           
        let vaccItemsDic = vaccTable.map { (Item) -> [String: Any] in

        return ["title": Item.title , "date": Item.date, "done": Item.done]
           }

           UserDefaults.standard.set(vaccItemsDic, forKey: newPet)
          
       }
    
    func loadlist()
    {
        
        print("petName is \(originalPet)")
        if let userVaccList = UserDefaults.standard.array(forKey: originalPet) as? [[String:Any]]
        {
            vaccTable = []
            for (index,item) in userVaccList.enumerated()
            {
                let title = userVaccList[index]["title"] as! String
                let date = userVaccList[index]["date"] as! Date
                let done = userVaccList[index]["done"] as! Bool
                
                vaccTable.append(vaccReminder(title: title, date: date, done: done))
            }
            //print("vacc陣列儲存到\(NSHomeDirectory())")
            //print(vaccTable)
        }
        else
        {
           //do nothing
        }
    }
    
}
