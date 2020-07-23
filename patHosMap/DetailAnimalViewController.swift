//
//  DetailAnimalViewController.swift
//  patHosMap
//
//  Created by 123 on 2020/7/22.
//  Copyright © 2020 陳逸煌. All rights reserved.
//

import UIKit

class DetailAnimalViewController: UIViewController {

    
    
    @IBOutlet weak var txtName: UITextField!
    

    
    
    @IBOutlet weak var imgPicture: UIImageView!
    
    
    
    
    weak var vaccTableViewController:VaccTableViewController!
    var currentData = Animal()
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtBirthday: UITextField!
    @IBOutlet weak var imgPicture: UIImageView!

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
