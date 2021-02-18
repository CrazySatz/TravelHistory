//
//  LocationViewModel.swift
//  TravelHistory
//
//  Created by user on 18/02/21.
//

import Foundation
import UIKit
import CoreLocation
import CoreData

class LocationViewModel: NSObject, CLLocationManagerDelegate {
    
    private var locationManager: CLLocationManager!

    var reloadClosure : (() -> ()) = {}
    
    func updateLcation()  {

        locationManager = CLLocationManager()
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
        var arr = UserDefaults.standard.object(forKey: "SavedArray") as? [String] ?? [String]()
        arr.append("test")
        UserDefaults.standard.set(arr, forKey: "SavedArray")
        
        let userLocation:CLLocation = locations[0] as CLLocation
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        
        self.saveFileData(lat: "\(userLocation.coordinate.latitude)", long: "\(userLocation.coordinate.longitude)")
        
        reloadClosure()
        locationManager.stopUpdatingLocation()
        
    }
    
   func fetchSavedData(completionHandler: @escaping(_ response: [Location]) -> Void) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Location")
        fetchRequest.returnsObjectsAsFaults = false
  
        do {
            
            let result = try managedObjectContext.fetch(fetchRequest) as?
                [Location]
            
            let sortedUsers = result!.sorted {
               (Double($0.time ?? "") ?? 00) < (Double($1.time ?? "") ?? 00)
            }
            
            
            completionHandler(sortedUsers)
        } catch let error as NSError {
           
        }
        
    }
    
    
    func saveFileData(lat:String, long:String) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        
        let videoEntity = NSEntityDescription.entity(forEntityName: "Location",
                                                     in: managedObjectContext)
        let assertDetails = NSManagedObject(entity: videoEntity!,
                                            insertInto: managedObjectContext) as? Location
        
        
        assertDetails?.latitude = lat
        assertDetails?.long = long
        assertDetails?.time = "\(NSDate().timeIntervalSince1970)"
      
        do {
            
            try managedObjectContext.save()
            
        } catch let error as NSError {

            
        }
    }

    
}
