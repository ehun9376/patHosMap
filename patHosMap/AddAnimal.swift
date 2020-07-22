//
//  AddAnimal.swift
//  patHosMap
//
//  Created by anna on 2020/7/20.
//  Copyright © 2020 陳逸煌. All rights reserved.
//

import UIKit

class AddAnimal: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource {
    
        var currentObjectBottomPosition:CGFloat = 0
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtBirthday: UITextField!
    
    @IBOutlet weak var imgPicture: UIImageView!
    @IBOutlet weak var btnCat: UIButton!
    @IBOutlet weak var btnDog: UIButton!
    @IBOutlet weak var btnDecide: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    
    var pkvBirthday:UIPickerView!
    let arrBirthday = [["10","11","11","11","11","12"]]

 
    override func viewDidLoad() {
        super.viewDidLoad()

        pkvBirthday = UIPickerView()
        txtBirthday.inputView = pkvBirthday
        pkvBirthday.delegate = self
        pkvBirthday.dataSource = self
    }
    //相機
    //使用代理協定UIImagePickerControllerDelegate,UINavigationControllerDelegate
    @IBAction func btnCamera(_ sender: UIButton) {
        if
            !UIImagePickerController.isSourceTypeAvailable(.camera){
                print("此裝置沒有相機")
            return
        }
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        self.show(imagePicker, sender: nil)
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
    //Todo
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
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
    
    //MARK - UIPickerViewDataSource
    //滾輪有幾段(外迴圈數量)
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    //每一段滾輪有幾個選項（內迴圈數量）
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
            return arrBirthday.count
    }
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return arrBirthday[row]
//    }
    


}
