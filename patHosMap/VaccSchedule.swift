import UIKit

struct vaccReminder
{
    var title = ""
    var date = Date.init()
    var done = false
}

class VaccSchedule: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var listTable: UITableView!
    var vaccTable = [vaccReminder]()
    var vaccDate:Date?
    var petName = ""
    var petKind = "2"  //to do:根據貓/狗給不同的預防針清單
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return vaccTable.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:UITableViewCell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        
        //顯示項目
        cell.textLabel?.text = vaccTable[indexPath.row].title
        
        //將日期轉為字串
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        dateFormatter.locale = Locale(identifier: "zh_Hant_TW") // 設定地區(台灣)
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Taipei") // 設定時區(台灣)
        let dateFormatString: String = dateFormatter.string(from: vaccTable[indexPath.row].date)
        //顯示日期
        cell.detailTextLabel?.text = dateFormatString
        cell.detailTextLabel?.textColor = UIColor(red: 78/255, green: 205/255, blue: 196/255, alpha: 0.9)
        
        //若以做過狀態為打勾
        if vaccTable[indexPath.row].done
        {
            cell.accessoryType = .checkmark
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let cell = tableView.cellForRow(at: indexPath)!
        //依紀錄判斷是否已被完成，若為完成的項目會顯示打勾，再按該項須改為不打勾並將狀態改為false
        if vaccTable[indexPath.row].done == true
        {
            cell.accessoryType = UITableViewCell.AccessoryType.none
            vaccTable[indexPath.row].done = false
            print("現在done = false \(vaccTable[indexPath.row])")
        }
        else
        {
            cell.accessoryType = UITableViewCell.AccessoryType.checkmark
            vaccTable[indexPath.row].done = true
            print("現在done = true \(vaccTable[indexPath.row])")
        }
    }

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationItem.title = "預防針施打紀錄"
        self.listTable.dataSource = self
        self.listTable.delegate = self
    //載入預防針清單
        loadlist()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        saveList()
    }
    func saveList()
    {
           
        let vaccItemsDic = vaccTable.map { (Item) -> [String: Any] in

        return ["title": Item.title , "date": Item.date, "done": Item.done]
           }

           UserDefaults.standard.set(vaccItemsDic, forKey: petName)
       }
    
    func loadlist()
    {
        
        print("petName is \(petName)")
        if let userVaccList = UserDefaults.standard.array(forKey: petName) as? [[String:Any]]
        {
            vaccTable = []
            for (index,item) in userVaccList.enumerated()
            {
                let title = userVaccList[index]["title"] as! String
                let date = userVaccList[index]["date"] as! Date
                let done = userVaccList[index]["done"] as! Bool
                
                vaccTable.append(vaccReminder(title: title, date: date, done: done))
            }
        }
        else
        {
            print("進入else段")
            if petKind == "2"
            {
                vaccTable = [
                vaccReminder(title: "8週-三合一疫苗", date: vaccDate! + 4838400, done: false),
                vaccReminder(title: "16週-三合一疫苗", date: vaccDate! + 9676800, done: false),
                vaccReminder(title: "結紮", date: vaccDate! + 9676800, done: false),
                vaccReminder(title: "狂犬病", date: vaccDate! + 14515200, done: false),
                vaccReminder(title: "1歲-三合一＆狂犬病", date: vaccDate! + 31536000, done: false),
                vaccReminder(title: "2歲-三合一＆狂犬病", date: vaccDate! + 63072000, done: false),
                vaccReminder(title: "3歲-三合一＆狂犬病", date: vaccDate! + 94608000, done: false),
                ]
            }
            else if petKind == "1"
            {
                vaccTable = [
                vaccReminder(title: "6週-六合一疫苗", date: vaccDate! + 3888000, done: false),
                vaccReminder(title: "10週-第一劑八合一疫苗", date: vaccDate! + 6048000, done: false),
                vaccReminder(title: "14週-第二劑八合一疫苗", date: vaccDate! + 8467200, done: false),
                vaccReminder(title: "狂犬病", date: vaccDate! + 9679800, done: false),
                vaccReminder(title: "18週-第三劑八合一疫苗", date: vaccDate! + 10886400, done: false),
                vaccReminder(title: "1Y4M-八合一＆狂犬病", date: vaccDate! + 41126400, done: false),
                vaccReminder(title: "2Y4M-三合一＆狂犬病", date: vaccDate! + 9676904, done: false),
                ]
            }
            else
            {
                print("pet kind傳遞錯誤")
            }
            
        }
    }
    

    

}
