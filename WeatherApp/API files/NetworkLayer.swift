//
//  NetworkLayer.swift
//  WeatherApp
//
//  Created by Veedepu Srikanth on 06/01/21.
//

import Foundation

class NetworkLayer {
    
    static let shared = NetworkLayer()
    
    private init() {}
    
    func getDataFromAPI(urlString: String, parameters: [String: Any], completionHandler: @escaping ((Result<Data, Error>) -> ())) {
        
        var dictParams = [String: Any]()
        
        if parameters.count == 0 {
            return
        }
        
        parameters.forEach { (key, value) in
            dictParams[key] = value
        }
        
        dictParams["appid"] = "fae7190d7e6433ec3a45285ffcf55c86"
        var strParams = "?"
        for (index, (key, value)) in dictParams.enumerated() {
            
            strParams += key + "=" + (value as! String)
            
            if dictParams.count-1 != index {
                strParams += "&"
            }
        }
        
        let urlStr = urlString + strParams
        print("API Name with params: \(urlStr)")
        
        guard let url = URL(string: urlStr) else {
            
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "API Url not found"])
            return completionHandler(.failure(error))
        }
        
        let urlReq = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 20)
        
        URLSession.shared.dataTask(with: urlReq) { (data, response, error) in
            
            if error == nil {
                
                guard let data = data else { return }
                
//                let strJson = String.init(data: data, encoding: .utf8)!
//                print("Output response: \(strJson)")
                
                completionHandler(.success(data))
            }
            else {
                completionHandler(.failure(error!))
            }
        }.resume()
    }
}
