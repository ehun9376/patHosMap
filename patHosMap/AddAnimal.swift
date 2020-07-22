//
//  AddAnimal.swift
//  patHosMap
//
//  Created by anna on 2020/7/20.
//  Copyright © 2020 陳逸煌. All rights reserved.
//

import UIKit

class AddAnimal: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
        var currentObjectBottomPosition:CGFloat = 0
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtBirthday: UITextField!
    
    
    
    
    @objc func keyboardWillHide(){
        print("鍵盤收合！")
        //將畫面移回原來位置
        self.view.frame.origin.y = 0
    }
    
    @IBAction func editDidBegin(_ sender: UITextField) {
        print("開始編輯")
        switch sender.tag {
            case 3: //phone
                sender.keyboardType = .phonePad
            case 6://email
                sender.keyboardType = .emailAddress
            default:
                sender.keyboardType = .default
        }
        //計算輸入元件的Ｙ軸底元位置
        currentObjectBottomPosition = sender.frame.origin.y + sender.frame.size.height
    }
    
    
    @objc func keyboardWillShow(_ sender:Notification){
        print("鍵盤彈出！")
        print("通知資訊：\(sender)")
        if let keyboardHeight = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height {
            print("鍵盤高度：\(keyboardHeight)")
            //整個高度減去鍵盤高度（計算扣除鍵盤後的可視高度）
            let visibleHeight = self.view.bounds.size.height - keyboardHeight
            //如果”Ｙ軸底緣位置“比“可視高度”還高，表示元件被鍵盤遮住
            
            if currentObjectBottomPosition > visibleHeight{
                //移動“Ｙ軸底緣位置”與“可視高度”之間的差值（即被遮住的範圍高度再少１０點）
                self.view.frame.origin.y -= currentObjectBottomPosition - visibleHeight + 10
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let notificationCenter = NotificationCenter.default
        //向通知中心註冊鍵盤彈出通知
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        // Do any additional setup after loading the view.
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
    }
    
    //相簿
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
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //編輯用鍵盤使用結束後收起
        self.view.endEditing(true)
    }
    

}
