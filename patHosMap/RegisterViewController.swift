//
//  RegisterViewController.swift
//  patHosMap
//
//  Created by 陳逸煌 on 2020/7/20.
//  Copyright © 2020 陳逸煌. All rights reserved.
//

import UIKit
import FirebaseDatabase
class RegisterViewController: UIViewController {
    @IBOutlet weak var account: UITextField!
    @IBOutlet weak var password: UITextField!
    var root:DatabaseReference!

    let observer:UInt = 0
//    let sales = root.child("sale_mangers").child("2")
//    var is_manager = false
//    sales.setValue([["account":"jacky"],["password":"123456"]])
//    sales.observe(DataEventType.value) { (data) in
//        print(data.value!)
    @IBAction func register(_ sender: UIButton) {
        var count = 0
        var is_manager = false
        let user = root.child("user")
        let account1 = self.account.text
        user.observeSingleEvent(of: .value) { (data) in
        let manager_array = data.value! as! [[String:String]]
            for manager in manager_array{
                count += 1
                if manager["account"] == account1{
                    is_manager = true
                    let alert = UIAlertController(title: "警告", message: "帳號已存在", preferredStyle: .alert)
                    let button = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (button) in
                        self.performSegue(withIdentifier: "toLoginVC", sender: nil)
                    }
                    alert.addAction(button)
                    self.present(alert, animated: true, completion: {})
                    break
                }
            }
            if !is_manager{
                if self.account.text != "" && self.password.text != ""{
                    print("推送\(count),創建帳號")
                    let newUser = self.root.child("user").child("\(count)")
                    let newData = ["account":"\(self.account.text!)","password":"\(self.password.text!)","favorite":""]
                    newUser.setValue(newData)
                    let alert = UIAlertController(title: "通知", message: "帳號已創建", preferredStyle: .alert)
                    let button = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (button) in
                        self.performSegue(withIdentifier: "toLoginVC", sender: nil)
                    }
                    alert.addAction(button)
                    self.present(alert, animated: true, completion: {})
                }
                else{
                    let alert = UIAlertController(title: "警告", message: "帳號或密碼不得為空", preferredStyle: .alert)
                    let button = UIAlertAction(title: "Try Again", style: UIAlertAction.Style.default) { (button) in
                    }
                    alert.addAction(button)
                    self.present(alert, animated: true, completion: {})
                }

            }
        }
    
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    root = Database.database().reference()
        // Do any additional setup after loading the view.
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
