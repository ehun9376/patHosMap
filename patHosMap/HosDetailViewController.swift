//
//  HosDetailViewController.swift
//  patHosMap
//
//  Created by 陳逸煌 on 2020/7/20.
//  Copyright © 2020 陳逸煌. All rights reserved.
//

import UIKit

class HosDetailViewController: UIViewController {
    var strtel = ""
    var straddr = ""
    @IBOutlet weak var hosTelephone: UILabel!
    @IBOutlet weak var hosAddress: UILabel!
    
    @IBAction func btnAddToFavorite(_ sender: UIButton) {
//        let little_data_center:UserDefaults
//        little_data_center = UserDefaults.init()
//        little_data_center.set(45, forKey: "age")
//        little_data_center.set("Rita", forKey: "username")
//        print("OK了")
//        print(self.test)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hosTelephone.text = strtel
        self.hosAddress.text = straddr
    }
    


}
