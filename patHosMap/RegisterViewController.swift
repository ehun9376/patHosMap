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
    @IBAction func register(_ sender: UIButton) {
        let user =  root.child("user")
        user.observe(DataEventType.value,with:  { (data) in
            print(data.value!)
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
