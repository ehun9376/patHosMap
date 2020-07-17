import UIKit

class HospitalViewController: UIViewController {
    @IBOutlet var citys: [UIButton]!
    @IBOutlet weak var city: UILabel!
    @IBAction func changeCity(_ sender: UIButton) {
        UIView.animate(withDuration: 1) {
            for city in self.citys{
                city.isHidden = !city.isHidden
                self.view.layoutIfNeeded()
            }
        }
    }
    @IBAction func choicedCity(_ sender: UIButton) {
            self.city.text = sender.titleLabel?.text
        UIView.animate(withDuration: 1) {
            for city in self.citys{
                city.isHidden = !city.isHidden
                self.view.layoutIfNeeded()
            }
            let session:URLSession = URLSession(configuration: .default)
            let task:URLSessionDataTask = session.dataTask(with: URL(string:"https://data.coa.gov.tw/Service/OpenData/DataFileService.aspx?UnitId=078&$top=1000&$skip=0")!){
                (data,reponse,err)
                in
                if let error = err{
                    let alert = UIAlertController(title: "警告", message: "連線出現問題！\n\(error.localizedDescription)", preferredStyle: .alert)
                    let button = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (button) in
                    }
                    alert.addAction(button)
                    self.present(alert, animated: true, completion: {})
                }else{
//                    let server_message = String(data: data!, encoding: .utf8)!
//                    print(server_message)
                    do{
                        let hospitalArray = try JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as! [[String:String]]
                        for hospital in hospitalArray{
                            DispatchQueue.main.async {
                                if hospital["縣市"]! == sender.titleLabel?.text{
                                    print(hospital["機構名稱"]!)
                                }
                            }

                        }
                    }catch{
                        print("伺服器出錯\(error)")
                    }
                }
            }
            task.resume()

        }

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
