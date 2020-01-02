//
//  ViewController.swift
//  LeiriaMap
//
//  Created by Mohammad Saiful Kabir on 23/12/2019.
//  Copyright © 2019 Mohammad Saiful Kabir. All rights reserved.
//

import UIKit
import MapKit
import os.log

class ViewController: UIViewController {

    var locationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView!
    
    var churches = [Church]()
    
    func fetchData() {
         let fileName = Bundle.main.path(forResource: "Churches", ofType: "json")
    //    let url = "https://www.mocky.io/v2/5e065d573300008be8ec5d89"
        
         let filePath = URL(fileURLWithPath: fileName!) 
         var data: Data?
         do {
             data = try Data(contentsOf: filePath,
                            options: Data.ReadingOptions(rawValue: 0))
         } catch let error {
            data = nil
             print("Report error \(error.localizedDescription)")
         }
         
        if let jsonData = data {
             let json = try? JSON(data: jsonData)
            if let churchJSONs = json?["church"].array {
   //             print(churchJSONs)
                 for churchJSON in churchJSONs {
                     if let value = Church.from(json: churchJSON) {
                        
                         self.churches.append(value)
                     }
                 }
             }
         }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let initialLocation = CLLocation(latitude: 39.74264, longitude: -8.80962)

        zoomMapOn(location: initialLocation)
        
        mapView.delegate = self
        
        fetchData()
        mapView.addAnnotations(churches)
        
    }
    
    let regionRadius: CLLocationDistance = 1000
    
    func zoomMapOn(location: CLLocation) {
        let region = MKCoordinateRegion.init(center: location.coordinate, latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
          mapView.setRegion(region, animated: true)
          
    }
}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if let annotation = annotation as? Church {
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier:
        identifier) as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation as MKAnnotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation as MKAnnotation, reuseIdentifier: identifier)
        view.canShowCallout = true
        view.calloutOffset = CGPoint(x: -5, y: 5)
        view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
      }
        return view
    }
        return nil
  }
}



/*
 guard let url = URL(string: urlString) else {
     os_log("Invalid URL.", log: OSLog.default, type: .error)
     return
     }

     URLSession(configuration: .default).dataTask(with: url) {
         (data, response, error) in
          if let error = error {
             print(error.localizedDescription)
          } else if
            let data = data,
            let response = response as? HTTPURLResponse,
             response.statusCode == 200 {
             
             do {
             // parse json
                 let  church: [Church] = try JSONDecoder().decode([Church].self, from: data)

                 for value in church {
                    
                         churches.add(value)
                //     }
                 }
            }catch let parseError as NSError {
            print(parseError.localizedDescription)
             }
         }
     }.resume()
 
 }
 */
