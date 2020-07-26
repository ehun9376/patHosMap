//
//  MyFavoriteViewController.swift
//  patHosMap
//
//  Created by 陳逸煌 on 2020/7/20.
//  Copyright © 2020 陳逸煌. All rights reserved.
//

import UIKit
import Firebase
class MyFavoriteViewController: UIViewController {
    
    var hospitalsArray:[[String:String]]! = [[:]]
    var count = 0
    var root:DatabaseReference!
    var userFavoriteName:String!
    @IBAction func test(_ sender: UIButton) {
        let little_data_center:UserDefaults
        little_data_center = UserDefaults.init()
        let userID = little_data_center.integer(forKey: "userID") - 1
        print(userID)
        root = Database.database().reference()
        let datafavorite =  root.child("user").child("\(userID)").child("favorite")
        datafavorite.observeSingleEvent(of: .value) { (shot) in
            let data = shot.value! as! String
            if data != ""{
                self.userFavoriteName = data
                print(self.userFavoriteName!)
            }
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
