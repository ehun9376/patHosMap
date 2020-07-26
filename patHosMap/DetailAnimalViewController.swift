//
//  DetailAnimalViewController.swift
//  patHosMap
//
//  Created by 123 on 2020/7/22.
//  Copyright © 2020 陳逸煌. All rights reserved.
//

import UIKit

class DetailAnimalViewController: UIViewController {

    weak var vaccTableViewController:VaccTableViewController!
    var currentData = Animal()
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtBirthday: UITextField!
    @IBOutlet weak var imgPicture: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    


    @IBAction func btnUpdate(_ sender: UIButton) {
    }
    
}
