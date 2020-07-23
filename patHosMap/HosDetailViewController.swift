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
    @IBOutlet weak var hosName: UILabel!
    //@IBOutlet weak var hosTelephone: UILabel!
    @IBOutlet weak var buttonPhone: UIButton!
    @IBOutlet weak var hosAddress: UILabel!
    @IBOutlet weak var labelDistance: UILabel!
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
    
    @IBAction func btnAddToFavorite(_ sender: UIButton) {
        let little_data_center:UserDefaults
        little_data_center = UserDefaults.init()
        let userID = little_data_center.integer(forKey: "userID") - 1
        print(userID)
        let datafavorite =  root.child("user").child("\(userID)").child("favorite")
        datafavorite.setValue("123")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.hosTelephone.text = strtel
        self.buttonPhone.setTitle(strtel, for: .normal)
        self.hosAddress.text = straddr
        self.hosName.text = strname
        getDestination()
        locationManager.delegate = self  //委派給ViewController
        locationManager.desiredAccuracy = kCLLocationAccuracyBest  //設定為最佳精度
        locationManager.requestWhenInUseAuthorization()  //user授權
        locationManager.startUpdatingLocation()  //開始update user位置
        mapView.delegate = self  //委派給ViewController
        mapView.showsUserLocation = true   //顯示user位置
        mapView.userTrackingMode = .follow  //隨著user移動
        root = Database.database().reference()
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
                let location = placemarks?.first?.location as! CLLocation
                //print(location.coordinate.latitude, location.coordinate.longitude)
                self.latitude = location.coordinate.latitude
                self.longitude = location.coordinate.longitude
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
                self.labelDistance.text = " \(String(format:"%.01f", distance)) KM "
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
}
