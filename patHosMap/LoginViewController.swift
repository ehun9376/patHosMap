//
//  LoginViewController.swift
//  patHosMap
//
//  Created by 陳逸煌 on 2020/7/20.
//  Copyright © 2020 陳逸煌. All rights reserved.
//

import UIKit
import FirebaseDatabase
class LoginViewController: UIViewController {
    @IBOutlet weak var account: UITextField!
    @IBOutlet weak var password: UITextField!
    var root:DatabaseReference!
    let observer:UInt = 0
    var count = 0
    @IBAction func clean(_ sender: UIButton) {
        self.account.text = ""
        self.password.text = ""
    }
    @IBAction func login(_ sender: UIButton) {
        let user = root.child("user")
        var is_manager = false
        user.observe(DataEventType.value, with: { (data) in
            print(data.value!)
            let manager_array = data.value! as! [[String:String]]
            print(manager_array)
            for manager in manager_array{
                self.count += 1
                if manager["account"] == self.account.text && manager["password"] == self.password.text{
                    is_manager = true
                    break
                }
            }
            if is_manager{
                print("使用者登入成功")
                print(self.count)
                let HosDetailVC = self.storyboard?.instantiateViewController(identifier: "HosDetail") as! HosDetailViewController
                user.removeObserver(withHandle: self.observer)
                self.performSegue(withIdentifier: "login", sender: nil)
            }
            else{
                print("登入失敗")
                let alert = UIAlertController(title: "警告", message: "帳密有誤", preferredStyle: .alert)
                let button = UIAlertAction(title: "Try Again", style: UIAlertAction.Style.default) { (button) in
                }
                alert.addAction(button)
                self.present(alert, animated: true, completion: {})
            }
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        root = Database.database().reference()
    }

}
