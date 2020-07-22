import UIKit
import CoreLocation

class HospitalViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    
    @IBOutlet weak var table: UITableView!

    @IBOutlet var citys: [UIButton]!
    @IBOutlet weak var city: UILabel!
    var locationManager = CLLocationManager()
    var cityHosArray:[[String:String]] = [[:]]
    var hosNameArray:[String] = []
    var hosTelArray:[String] = []
    var hosAddrArray:[String] = []
    var hospitalsArray:[[String:String]] = [[:]]
    @IBAction func changeCity(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.5) {
            for city in self.citys{
                city.isHidden = !city.isHidden
                self.view.layoutIfNeeded()
            }
        }
    }
    @IBAction func choicedCity(_ sender: UIButton) {
        self.city.text = sender.titleLabel?.text
        UIView.animate(withDuration: 0.5) {
            for city in self.citys{
                city.isHidden = !city.isHidden
                self.view.layoutIfNeeded()
            }
        }
        self.cityHosArray = [[:]]
        self.hosNameArray = []
        self.hosTelArray = []
        self.hosAddrArray = []
        if self.hospitalsArray != [[:]]{
            print(self.cityHosArray)
            print(self.hosNameArray)
            for hospital in self.hospitalsArray{
                if hospital["縣市"]! == sender.titleLabel!.text{
                    print(hospital)
                    self.cityHosArray.append(hospital)
                    self.hosNameArray.append(hospital["機構名稱"]!)
                    self.hosTelArray.append(hospital["機構電話"]!)
                    self.hosAddrArray.append(hospital["機構地址"]!)
                }
                
            }
//            print(self.cityHosArray)
//            print(self.hosNameArray)
            self.table.dataSource = self
            self.table.delegate = self
            self.table.reloadData()
        }
        else{
            DispatchQueue.main.async{
                let alert = UIAlertController(title: "警告", message: "資料下載未完成，請稍待幾秒鐘再試一次", preferredStyle: .alert)
                let button = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (button) in
                }
                alert.addAction(button)
                self.present(alert, animated: true, completion: {})
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.download()
        locationManager.requestWhenInUseAuthorization()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hosNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell()
        if indexPath.row <= self.hosNameArray.count{
            cell.textLabel?.text = hosNameArray[indexPath.row]
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let HosDetailVC = self.storyboard?.instantiateViewController(identifier: "HosDetail") as! HosDetailViewController
        HosDetailVC.strtel = self.hosTelArray[indexPath.row]
        HosDetailVC.straddr = self.hosAddrArray[indexPath.row]
        HosDetailVC.strname = self.hosNameArray[indexPath.row]
        self.show(HosDetailVC, sender: nil)
    }
    
    //
    func download() -> Void {
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
            }
            else{
                do{
                    self.hospitalsArray = try JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as! [[String:String]]
                }catch{
                    print("伺服器出錯\(error)")
                }
            }
        }
        task.resume()
    }
}
