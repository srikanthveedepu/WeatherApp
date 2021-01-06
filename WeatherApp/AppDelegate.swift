//
//  AppDelegate.swift
//  WeatherApp
//
//  Created by Veedepu Srikanth on 06/01/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let placesVC = PlacesBookmarkedViewController()
        let navVC = UINavigationController(rootViewController: placesVC)
        window?.rootViewController = navVC
        window?.makeKeyAndVisible()
        return true
    }
    
    static func saveToUserDefaults(_ locations: [String]) {
        
        let ud = UserDefaults.standard
        
        if locations.count == 0 {
            ud.removeObject(forKey: Constants.locations)
            ud.synchronize()
            return
        }
        
        let data = try! JSONSerialization.data(withJSONObject: locations, options: .fragmentsAllowed)
        guard let strJson = String(data: data, encoding: .utf8) else { return }
        
        ud.setValue(strJson, forKey: Constants.locations)
        ud.synchronize()
    }
    
    static func getFromUserDefaults() -> [String] {
        
        let ud = UserDefaults.standard
        guard let strjson = ud.value(forKey: Constants.locations) as? String else { return [String]() }
        let data = Data(strjson.utf8)
        
        guard let locations = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String] else { return [String]() }
        return locations
    }
}

