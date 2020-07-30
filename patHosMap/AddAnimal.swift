//
//  AddAnimal.swift
//  patHosMap
//
//  Created by anna on 2020/7/20.
//  Copyright © 2020 陳逸煌. All rights reserved.
//

import UIKit
import Firebase
class AddAnimal: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIPickerViewDelegate {
    
    weak var VaccTVC:VaccTVC!
    var currentObjectBottomPosition:CGFloat = 0
    var root:DatabaseReference!
    var addanimalname:String!
    var addname = ""
    var vc:UIImagePickerController!
    var petCount:Int!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtBirthday: UITextField!
    let Picker = UIDatePicker()
    @IBOutlet weak var imgPicture: UIImageView!
    
    var kind = 1
    @IBOutlet weak var btnCat: UIButton!
    @IBOutlet weak var btnDog: UIButton!

    @IBAction func btndog(_ sender: UIButton) {
        kind = 1
    }
    @IBAction func btncat(_ sender: UIButton) {
        kind = 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        creatDatePicker()
        root = Database.database().reference()
        //print(petCount!)
    }
    func creatDatePicker(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([done], animated: false)
        txtBirthday.inputAccessoryView = toolbar
        txtBirthday.inputView = Picker
        Picker.datePickerMode = .date
    }
    @objc func donePressed(){
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        //formatter.dateFormat = "yyyy.mm.dd"
        formatter.timeStyle = .none
        let dateString = formatter.string(from: Picker.date)
        
        txtBirthday.text = "\(dateString)"
        self.view.endEditing(true)
    }
    
        @IBAction func didEndOnExit(_ sender: UITextField)
        {

        }
    //相機
    @IBAction func btnCamera(_ sender: UIButton) {
        vc = UIImagePickerController()
        //vc.cameraCaptureMode = UITraitCollection.
        vc.sourceType = .camera
        vc.allowsEditing = true
        vc.cameraDevice = .rear
        vc.delegate = self
        self.present(vc, animated: true, completion: {})
//
//        if
//            !UIImagePickerController.isSourceTypeAvailable(.camera){
//                print("此裝置沒有相機")
//            return
//        }
//        let imagePicker = UIImagePickerController()
//        imagePicker.sourceType = .camera
//        imagePicker.delegate = self
//        self.show(imagePicker, sender: nil)
    }
    //相簿
    @IBAction func btnPhotoAlbum(_ sender: UIButton) {
        if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
               print("此裝置沒有相簿")
               return
           }
           //初始化影像挑選控制器
           let imagePicker = UIImagePickerController()
           //設定影像挑選控制器為相機
           imagePicker.sourceType = .photoLibrary
           //允許編輯相片
           imagePicker.allowsEditing = true
           
           //設定相機相關的代理事件
           imagePicker.delegate = self
           //開啟相簿
           self.show(imagePicker, sender: nil)
    }

    //MARK - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("影像資訊:\(info)")
        if let image = info[.originalImage] as? UIImage{
            //將拍照結果顯示在拍照位置
            imgPicture.image = image
            //由picker退掉相機畫面
            picker.dismiss(animated: true, completion: nil)
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //編輯用鍵盤使用結束後收起
        self.view.endEditing(true)
    }

    @IBAction func btnInsert(_ sender: UIButton) {
//        if txtName.text!.isEmpty || txtBirthday.text!.isEmpty || imgPicture.image == nil
        if txtName.text!.isEmpty || txtBirthday.text!.isEmpty {
            //製作訊息視窗
            let alert = UIAlertController(title: "資料輸入錯誤", message: "任何一個欄位都不可空白", preferredStyle: .alert)
            //初始化訊息視窗準備使用的按鈕
            let btnOK = UIAlertAction(title: "確定", style: .default, handler: nil)
            //將按鈕加入訊息視窗
            alert.addAction(btnOK)
            //顯示訊息視窗
            self.present(alert, animated: true, completion: nil)
            //離開函式
            return
        }

        let little_data_center:UserDefaults
        little_data_center = UserDefaults.init()
        let userID = little_data_center.integer(forKey: "userID") - 1
        print(userID)
        let petcount = "\(petCount!)"
        print("寵物數量\(petcount)")
        let dataAddanimal = root.child("mypet").child("\(userID)").child("\(petcount)")
        
//        let newData = ["name":"\(self.txtName.text!)","birthday":"\(self.txtBirthday.text!)","picture":"\(self.imgPicture.image!)","kind":"\(self.kind)",]
        
        let newData = ["name":"\(self.txtName.text!)","birthday":"\(self.txtBirthday.text!)","kind":"\(self.kind)",]
        
        dataAddanimal.setValue(newData)
        let alert = UIAlertController(title: "錯誤", message: "任一空格不得為空", preferredStyle: .alert)
        let btnOK = UIAlertAction(title: "確定", style: .default, handler: nil)
    }
    
}
