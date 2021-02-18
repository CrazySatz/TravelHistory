//
//  ViewController.swift
//  TravelHistory
//
//  Created by user on 17/02/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var listView: UITableView!
    
    var locationViewModel : LocationViewModel!
    
    var locationList = [Location]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setInitial()
        
    }
    
    func setInitial() {
        self.locationViewModel = LocationViewModel()
        
        self.locationViewModel.fetchSavedData { (location) in
            self.locationList = location
            self.listView.delegate = self
            self.listView.dataSource = self
        }
        
        self.locationViewModel.reloadClosure = {
            
            self.locationViewModel.fetchSavedData { (location) in
                self.locationList = location
                self.listView.reloadData()
            }
        }
        
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { timer in
            self.locationViewModel.updateLcation()
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.locationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
        var cell2 = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if cell2 == nil {
            cell2 = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "Cell")
            let location = self.locationList[indexPath.row]
            cell2!.textLabel?.text = "Lat: \(location.latitude ?? "") \nLon: \(location.latitude ?? "") \n\(location.time ?? "")"
            cell2!.textLabel?.numberOfLines = 0
            
        }
            
        return cell2!
        
    }
    
}



