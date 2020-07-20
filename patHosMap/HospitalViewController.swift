import UIKit

class HospitalViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    
    @IBOutlet weak var table: UITableView!
    var hosArray:[String] = []
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
                        self.hosArray = []
                        let hospitalArray = try JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as! [[String:String]]
                        for hospital in hospitalArray{
                            DispatchQueue.main.async {
                                if hospital["縣市"]! == sender.titleLabel?.text{
//                                    print(hospital["機構名稱"]!)
                                    self.hosArray.append(hospital["機構名稱"]!)
                                }
                            }
                            DispatchQueue.main.async{
                                self.table.dataSource = self
                                self.table.delegate = self
                                self.table.reloadData()
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


    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hosArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell()
        cell.textLabel?.text = hosArray[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)

    }
}
