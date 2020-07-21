//
//  MyFavoriteViewController.swift
//  patHosMap
//
//  Created by 陳逸煌 on 2020/7/20.
//  Copyright © 2020 陳逸煌. All rights reserved.
//

import UIKit

class MyFavoriteViewController: UIViewController {
    
    var hospitalsArray:[[String:String]] = [[:]]

    @IBAction func test(_ sender: UIButton) {
        let little_data_center:UserDefaults
        little_data_center = UserDefaults.init()
        let age = little_data_center.integer(forKey: "age")
        let name = little_data_center.string(forKey: "username")!
        print("\(age),\(name)")
        print(self.hospitalsArray)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("從新")

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
