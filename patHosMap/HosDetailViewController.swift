import UIKit
import MapKit
import CoreLocation

class HosDetailViewController: UIViewController {
    var strtel = ""
    var straddr = ""
    var latitude:CLLocationDegrees!
    var longitude:CLLocationDegrees!
    let annomation = MKPointAnnotation()
    @IBOutlet weak var hosName: UILabel!
    @IBOutlet weak var hosTelephone: UILabel!
    @IBOutlet weak var hosAddress: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func btnAddToFavorite(_ sender: UIButton) {
//        let little_data_center:UserDefaults
//        little_data_center = UserDefaults.init()
//        little_data_center.set(45, forKey: "age")
//        little_data_center.set("Rita", forKey: "username")
//        print("OK了")
//        print(self.test)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hosTelephone.text = strtel
        self.hosAddress.text = straddr
        getDestination()
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
                print("latitude:\(self.latitude!),longitude:\(self.longitude!)")
                
                
                //annomation.coordinate = CLLocationCoordinate2DMake(24.916062, 121.210480)
                self.annomation.coordinate = CLLocationCoordinate2DMake(self.latitude, self.longitude)
                self.annomation.title = self.hosName.text
                //self.annomation.subtitle = self.hosAddress
                self.mapView.addAnnotation(self.annomation)
                
                let region = MKCoordinateRegion(center: self.annomation.coordinate, latitudinalMeters: 100, longitudinalMeters: 100)
                
                self.mapView.setRegion(region, animated: true)
            }
        }
    }


}
