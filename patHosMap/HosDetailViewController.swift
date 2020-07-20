//
//  HosDetailViewController.swift
//  patHosMap
//
//  Created by 陳逸煌 on 2020/7/20.
//  Copyright © 2020 陳逸煌. All rights reserved.
//

import UIKit

class HosDetailViewController: UIViewController {
    var test = 1
    @IBAction func btnAddToFavorite(_ sender: UIButton) {
        let little_data_center:UserDefaults
        little_data_center = UserDefaults.init()
        little_data_center.set(45, forKey: "age")
        little_data_center.set("Rita", forKey: "username")
        print("OK了")
        print(self.test)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
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
