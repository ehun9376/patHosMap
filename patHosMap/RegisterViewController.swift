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
    @IBOutlet weak var acoount: UITextField!
    @IBOutlet weak var password: UITextField!
    var root:DatabaseReference!
       let observer:UInt = 0
//    let sales = root.child("sale_mangers").child("2")
//    var is_manager = false
//    sales.setValue([["account":"jacky"],["password":"123456"]])
//    sales.observe(DataEventType.value) { (data) in
//        print(data.value!)
    @IBAction func register(_ sender: UIButton) {
        let user = root.child("user")
        var count = 0
        var is_manager = false
        user.observe(DataEventType.value, with: { (data) in
            print(data.value!)
            let manager_array = data.value! as! [[String:String]]
            print(manager_array)
            
            for manager in manager_array{
                count += 1
                if manager["account"] == self.acoount.text{
                    is_manager = true
                    break
                }
            }
            print(count)
            if is_manager{
                print("帳號創建失敗")
                let alert = UIAlertController(title: "警告", message: "帳號已存在", preferredStyle: .alert)
                let button = UIAlertAction(title: "ok", style: UIAlertAction.Style.default) { (button) in
                }
                alert.addAction(button)
                self.present(alert, animated: true, completion: {})
            }
            else{
                //推送到資料庫
//                DispatchQueue.main.async {
//                    let newUser = self.root.child("user").child("\(count)")
//                    let newData = [["account":"\(self.acoount.text!)"],["password":"\(self.password.text!)"]]
//                    newUser.setValue(newData)
//                }

            }
          })
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
