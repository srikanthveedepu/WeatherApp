
import UIKit
import MapKit


class PlacesBookmarkedViewController: UITableViewController, UISearchResultsUpdating {
    
    var locations = [String]()
    let cellId = "Location_cellId"
    var searchResults = [String]()
    let searchController = UISearchController(searchResultsController: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        searchController.searchResultsUpdater = self
        self.definesPresentationContext = true
        
        self.navigationItem.titleView = searchController.searchBar
        
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewLocation))
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        locations.append(contentsOf: AppDelegate.getFromUserDefaults())
    }
    
    @objc func addNewLocation() {
        
        let mapVC = MapViewController()
        mapVC.delegate = self
        let navMapVC = UINavigationController(rootViewController: mapVC)
        navMapVC.modalPresentationStyle = .fullScreen
        present(navMapVC, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return searchController.isActive ? searchResults.count : locations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId)!
        let location = searchController.isActive ?
                            searchResults[indexPath.row] : locations[indexPath.row]
        cell.textLabel?.text = location
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cityName = locations[indexPath.row]
        let urlString = API.Forecast_5Days
        let params = ["q": cityName]
        
        NetworkLayer.shared.getDataFromAPI(urlString: urlString, parameters: params) { [weak self] result in
            
            guard let self = self else { return }
            switch result {
            case .success(let data):
                do {
                    guard let forecastData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else { return }
                    DispatchQueue.main.async {
                        tableView.deselectRow(at: indexPath, animated: true)
                        
                        let showFCVC = ShowForeCastViewController(forecastData, city: cityName)
                        self.navigationController?.pushViewController(showFCVC, animated: true)
                    }
                }
                catch let err {
                    print(err.localizedDescription)
                }
                break
            case .failure(let err):
                print(err.localizedDescription)
                break
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            locations.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            AppDelegate.saveToUserDefaults(locations)
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        if let searchText = searchController.searchBar.text {
            filterContent(for: searchText)
            tableView.reloadData()
        }
    }
    
    func filterContent(for searchText: String) {
        
        searchResults = locations.filter({ title -> Bool in
            let match = title.range(of: searchText, options: .caseInsensitive)
            return match != nil
        })
    }
}

extension PlacesBookmarkedViewController: MapViewControllerDelegate {
    
    func didAddLocation(_ place: CLPlacemark) {
        
        if !locations.contains(place.locality!) {
            locations.append(place.locality!)
            AppDelegate.saveToUserDefaults(locations)
            self.tableView.reloadData()
        }
    }
}


