//
//  ShowForeCastViewController.swift
//  WeatherApp
//
//  Created by Veedepu Srikanth on 06/01/21.
//

import UIKit

class ShowForeCastViewController: UIViewController {
    
    let dictForecastInfo: [String: Any]
    
    init(_ forecastData: [String: Any]) {
        self.dictForecastInfo = forecastData
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
        
        var arrDayWise = [[String: Any]]()
        
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
                arrDayWise.append(filteredData)
            }
            else {
                
                arr1.append(dict)
                let dict1 = ["name": newStr, newStr: arr1] as [String : Any]
                arrDayWise.append(dict1)
            }
        }
        
        print(arrDayWise)
    }
    
    func displayData() {
        
        let scrollViewMain = UIScrollView()
        view.addSubview(scrollViewMain)
        scrollViewMain.translatesAutoresizingMaskIntoConstraints = false
        [
            scrollViewMain.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
        ]
    }
}
