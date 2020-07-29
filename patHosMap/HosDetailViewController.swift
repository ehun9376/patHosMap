import UIKit
import MapKit
import CoreLocation
import Firebase
class HosDetailViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    var strtel = ""
    var straddr = ""
    var strname = ""
    var count = 0
    var root:DatabaseReference!
    var datafavorite:DatabaseReference!
    var little_data_center = UserDefaults.init()
    var userID:Int!
    @IBOutlet weak var hosName: UILabel!
    //@IBOutlet weak var hosTelephone: UILabel!
    @IBOutlet weak var buttonPhone: UIButton!
    @IBOutlet weak var hosAddress: UILabel!
    @IBOutlet weak var labelDistance: UILabel!
    @IBOutlet weak var background: UIImageView!
    
    //Map相關
    @IBOutlet weak var mapView: MKMapView!
    let annomation = MKPointAnnotation()
    fileprivate let application = UIApplication.shared
    var latitude:CLLocationDegrees!
    var longitude:CLLocationDegrees!
    //locationManager，用於偵測用戶位置變化
    var locationManager = CLLocationManager()
    //紀錄使用者位置
    var userlatitube:CLLocationDegrees!
    var userlongitube:CLLocationDegrees!
    var stringWithLink:String!
    var userFavoriteName:String!
    //MARK: - 加入最愛按鈕
    @IBAction func btnAddToFavorite(_ sender: UIButton) {
        self.userID = little_data_center.integer(forKey: "userID") - 1
        self.datafavorite =  root.child("user").child("\(self.userID!)").child("favorite")
        if self.userFavoriteName != nil{
            if self.userFavoriteName.components(separatedBy: ",").contains(strname) || count == 1{
                let alert = UIAlertController(title: "警告", message: "已在最愛", preferredStyle: .alert)
                let button = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (button) in
                }
                alert.addAction(button)
                self.present(alert, animated: true, completion: {})
            }
            else{
                self.datafavorite.setValue(self.userFavoriteName + "," + strname)
                count = 1
                let alert = UIAlertController(title: "通知", message: "已將\(strname)加入最愛", preferredStyle: .alert)
                let button = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (button) in
                }
                alert.addAction(button)
                self.present(alert, animated: true, completion: {})
            }

        }
        else{
            self.datafavorite.setValue(strname)
            let alert = UIAlertController(title: "通知", message: "已將\(strname)加入最愛", preferredStyle: .alert)
            let button = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (button) in
            }
            alert.addAction(button)
            self.present(alert, animated: true, completion: {})
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        background.layer.cornerRadius = 25
        //self.hosTelephone.text = strtel
        self.buttonPhone.setTitle(strtel, for: .normal)
        self.hosAddress.text = straddr
        self.hosName.text = strname
        stringWithLink = "http://maps.apple.com/?daddr=\(hosAddress.text!)"
        //print(stringWithLink)
        getDestination()
        locationManager.delegate = self  //委派給ViewController
        locationManager.desiredAccuracy = kCLLocationAccuracyBest  //設定為最佳精度
        locationManager.requestWhenInUseAuthorization()  //user授權
        locationManager.startUpdatingLocation()  //開始update user位置
        mapView.delegate = self  //委派給ViewController
        mapView.showsUserLocation = true   //顯示user位置
        mapView.userTrackingMode = .follow  //隨著user移動
        
        //使用userDefaults傳遞使用者ID
        self.userID = little_data_center.integer(forKey: "userID") - 1
        
        //連結資料庫取得登入本APP的使用者的資訊
        root = Database.database().reference()
        self.datafavorite =  root.child("user").child("\(userID!)").child("favorite")
        self.datafavorite.observeSingleEvent(of: .value) { (shot) in
            let data = shot.value! as! String
            if data != ""{
                self.userFavoriteName = data
                print(self.userFavoriteName!)
            }
        }
    }
    
    func getDestination()
    {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(hosAddress.text!) { (placemarks, error) in
            if let err = error
            {
                print("轉碼錯誤\(err)")
            }
            else
            {
                let placemarks = placemarks
                let location = placemarks?.first?.location!
                //print(location.coordinate.latitude, location.coordinate.longitude)
                self.latitude = location!.coordinate.latitude
                self.longitude = location!.coordinate.longitude
//                print("latitude:\(self.latitude!),longitude:\(self.longitude!)")
                
                
                //annomation.coordinate = CLLocationCoordinate2DMake(24.916062, 121.210480)
                self.annomation.coordinate = CLLocationCoordinate2DMake(self.latitude, self.longitude)
                self.annomation.title = self.hosName.text
                //self.annomation.subtitle = self.hosAddress
                self.mapView.addAnnotation(self.annomation)
                
                let region = MKCoordinateRegion(center: self.annomation.coordinate, latitudinalMeters: 200, longitudinalMeters: 200)
                
                self.mapView.setRegion(region, animated: true)
                
                //計算距離
                var firsLocation = CLLocation(latitude:self.latitude, longitude:self.longitude)
                var secondLocation = CLLocation(latitude: self.userlatitube, longitude: self.userlongitube)
                let distance = firsLocation.distance(from: secondLocation) / 1000
                //顯示於label上
                self.labelDistance.text = " \(String(format:"%.01f", distance)) 公里 "
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        userlatitube = locValue.latitude
        userlongitube = locValue.longitude
        
//        print("userlocation\(userlatitube),\(userlongitube)")
        
        
    }
    
    @IBAction func buttonOpenMap(_ sender: UIButton)
    {
        let mapURL = URL(string: "http://maps.apple.com/?daddr=\(latitude!),\(longitude!)")
        print(latitude!, longitude!)
        if (UIApplication.shared.canOpenURL(mapURL!)){
            UIApplication.shared.open(mapURL!, options: [:], completionHandler: nil)
        } else {
                // do nothing
        }
    }
    
    @IBAction func buttonPhone(_ sender: UIButton)
    {
        if let phoneURL = URL(string: "tel://\(strtel)")
        {
            if application.canOpenURL(phoneURL)
            {
                application.open(phoneURL, options: [:], completionHandler: nil)
            }
            else
            {
                //alert
            }
        }
    }
    
    @IBAction func buttonShare(_ sender: Any)
    {
        let activityController = UIActivityViewController(activityItems: [stringWithLink!], applicationActivities: nil)
        
         self.present(activityController, animated: true) {
             print("presented")
         }
    }
    
}
