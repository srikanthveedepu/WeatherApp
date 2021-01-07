

import UIKit

class ShowForeCastViewController: UIViewController {
    
    let dictForecastInfo: [String: Any]
    var arrDayWise = [[String: Any]]()
    let cityName: String
    
    init(_ forecastData: [String: Any], city: String) {
        self.dictForecastInfo = forecastData
        self.cityName = city
        super.init(nibName: nil, bundle: nil)
        
        separateDataDayWise()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
    }
    
    func separateDataDayWise() {
        
        guard let arrData = dictForecastInfo["list"] as? [[String: Any]] else { return }
                
        for dict in arrData {
            
            guard let dateStr = dict["dt_txt"] as? String else { return }
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            let date = df.date(from: dateStr)!
            df.dateFormat = "yyyy-MM-dd"
            
            let newStr = df.string(from: date)
            print(newStr)
            
            var arr1 = [[String: Any]]()
            
            if arrDayWise.contains(where: { $0["name"] as? String == newStr }) {
                
                var filteredData = arrDayWise.filter { $0["name"] as? String == newStr }[0]
                
                arr1.append(contentsOf: filteredData[newStr] as! [[String: Any]])
                arr1.append(dict)
                
                filteredData[newStr] = arr1
                print(filteredData)
                //arrDayWise.removeAll(where: {  })
            }
            else {
                
                arr1.append(dict)
                let dict1 = ["name": newStr, newStr: arr1] as [String : Any]
                arrDayWise.append(dict1)
            }
        }
        
        print(arrDayWise)
        
        displayData()
    }
    
    func displayData() {
        
        let dictData = arrDayWise[0]
        guard let arrToday = dictData[dictData["name"] as! String] as? [[String: Any]] else { return }
        
        let dictToday = arrToday[0]
        print(dictToday)
        
        let topView = UIView()
        topView.backgroundColor = .white
        view.addSubview(topView)
        topView.translatesAutoresizingMaskIntoConstraints = false
        [
            topView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            topView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            topView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
        ].forEach { $0.isActive = true }
        
        let svMainView = UIStackView()
        svMainView.axis = .vertical
        svMainView.alignment = .center
        svMainView.spacing = 20
        topView.addSubview(svMainView)
        svMainView.translatesAutoresizingMaskIntoConstraints = false
        [
            svMainView.topAnchor.constraint(equalTo: topView.topAnchor, constant: 20),
            svMainView.leftAnchor.constraint(equalTo: topView.leftAnchor, constant: 0),
            svMainView.rightAnchor.constraint(equalTo: topView.rightAnchor, constant: 0),
            svMainView.bottomAnchor.constraint(equalTo: topView.bottomAnchor, constant: -20)
        ].forEach { $0.isActive = true }
        
        let lblCity = UILabel()
        lblCity.textAlignment = .center
        lblCity.text = self.cityName
        lblCity.textColor = .black
        lblCity.font = UIFont.customFont(name: AppFont.LATO_BOLD, size: .title2)
        svMainView.addArrangedSubview(lblCity)
        
        let lblToday = UILabel()
        lblToday.textAlignment = .center
        lblToday.text = dictData["name"] as? String
        lblToday.textColor = .black
        lblToday.font = UIFont.customFont(name: AppFont.LATO_BOLD, size: .title2)
        svMainView.addArrangedSubview(lblToday)
        
        let lblFeelLike = UILabel()
        lblFeelLike.textAlignment = .center
        lblFeelLike.text = (dictToday["weather"] as! [[String: Any]]) [0]["description"] as? String
        lblFeelLike.textColor = .black
        lblFeelLike.font = UIFont.customFont(name: AppFont.LATO_SEMIBOLD, size: .body)
        svMainView.addArrangedSubview(lblFeelLike)
        
        let lblTemp = UILabel()
        lblTemp.textAlignment = .center
        lblTemp.text = String(format: "%.1f C", (((dictToday["main"] as! [String: Any])["temp"] as! Double)))
        lblTemp.textColor = .black
        lblTemp.font = UIFont.customFont(name: AppFont.LATO_SEMIBOLD, size: .body)
        svMainView.addArrangedSubview(lblTemp)
        
        for (index, dictNext) in arrDayWise.enumerated() {
            
            if index == 0 {
                continue
            }
            
            let svNext = UIStackView()
            svNext.axis = .horizontal
            svNext.spacing = 20
            svNext.alignment = .center
            svMainView.addArrangedSubview(svNext)
            
            let lblDate = UILabel()
            //lblDate.textAlignment = .center
            lblDate.text = dictNext["name"] as? String
            lblDate.textColor = .black
            lblDate.font = UIFont.customFont(name: AppFont.LATO_MEDIUM, size: .body)
            svNext.addArrangedSubview(lblDate)
            
            let dict1 = (dictNext[dictNext["name"] as! String] as! [[String: Any]])[0]
            
            let lblFeelLike = UILabel()
            lblFeelLike.textAlignment = .center
            lblFeelLike.text = ( dict1["weather"] as! [[String: Any]]) [0]["description"] as? String
            lblFeelLike.textColor = .black
            lblFeelLike.font = UIFont.customFont(name: AppFont.LATO_SEMIBOLD, size: .body)
            svNext.addArrangedSubview(lblFeelLike)
            
            let lblTemp = UILabel()
            lblTemp.textAlignment = .center
            lblTemp.text = String(format: "%.1f C", (((dict1["main"] as! [String: Any])["temp"] as! Double)))
            lblTemp.textColor = .black
            lblTemp.font = UIFont.customFont(name: AppFont.LATO_SEMIBOLD, size: .body)
            svNext.addArrangedSubview(lblTemp)
        }
    }
}
