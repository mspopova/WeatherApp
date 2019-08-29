//
//  MapViewController.swift
//  Weather
//
//  Created by Марина Попова on 22/08/2019.
//  Copyright © 2019 Марина Попова. All rights reserved.
//

import UIKit
import MapKit
import MBProgressHUD

class MapViewController: UIViewController {
    

    let annotationIdentifier = "annotationIdentifier"
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var gridStepLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func getCenter(_ sender: Any) {
        let points = self.CalculateGrid(region: mapView.region)
        
        self.checkButton.isEnabled = false
        let secondsToDelay = 4.0
        MBProgressHUD.showAdded(to: view, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
            //print("Returned points")
            
            self.checkButton.isEnabled = true
            
            var annotations = [MKPointAnnotation]()
            for point in points {
                
                if (point.getCity()=="none"){
                    continue
                }
                
                let annotation = MKPointAnnotation()
                let temperature = String(Int(point.getTemp()))
                annotation.title = "\(temperature)ºC \(point.getState())"
                annotation.subtitle = point.getCity()
                annotation.coordinate = point.getCoord()
                
                annotations.append(annotation)
                
                //print(point.getState())
                //point.printWeather()
                
            }
            self.mapView.removeAnnotations(self.mapView.annotations)
            MBProgressHUD.hide(for: self.view, animated: true)
            self.mapView.showAnnotations(annotations, animated: true)
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.showsScale = true
        mapView.isRotateEnabled = false
        self.checkButton.layer.cornerRadius = 10
        self.gridStepLabel.layer.cornerRadius = 10
        
    }
    
    func CalculateGrid(region: MKCoordinateRegion) -> [PointWeather] {
        let gridCoordinates = self.CalculateGridCoordinates(region: region)
        var resArray = [PointWeather]()
        
        for cur_coordiantes in gridCoordinates {
            let tempPoint = PointWeather(new_coord: cur_coordiantes)
            tempPoint.setWeather()
            resArray.append(tempPoint)
        }
        return resArray
    }

    func CalculateGridSize(delta: CLLocationDegrees) -> Int {
        print("delta:", delta)
        if (delta > 54) {
            return 7
        }
        else if (delta <= 54 && delta > 15) {
            return 6
        }
        else if (delta <= 15 && delta > 8) {
            return 5
        }
        else if (delta <= 8 && delta > 5.5) {
            return 4
        }
        else if (delta <= 5.5 && delta > 3.2) {
            return 3
        } else if (delta <= 3.2 && delta > 0.9) {
            return 2
        }
        return 1
    }
    
    func CalculateGridCoordinates(region: MKCoordinateRegion) -> [CLLocationCoordinate2D]{
        let gridSize = self.CalculateGridSize(delta: region.span.latitudeDelta)
        gridStepLabel.text = "Grid step: \(gridSize)x\(gridSize)"
        var grid = [CLLocationCoordinate2D]()
        
        if (gridSize>1) {
            let k = 0.3
            let firstPoint = CLLocationCoordinate2D(latitude: region.center.latitude-region.span.latitudeDelta*k, longitude: region.center.longitude - region.span.longitudeDelta*k)
            
            let dlon = 2 * region.span.longitudeDelta/(Double(gridSize)-1.0)
            let dlat = 2 * region.span.latitudeDelta/(Double(gridSize)-1.0)
            for i in 0...gridSize-1 {
                for j in 0...gridSize-1{
                    let point = CLLocationCoordinate2D(latitude: firstPoint.latitude+dlat*Double(j)*k, longitude: firstPoint.longitude+dlon*Double(i)*k)
                    grid.append(point)
                }
            }
            //calculate for grid
        } else {
            grid.append(region.center)
        }
        
        if (gridSize==2) {
            grid.append(region.center)
        }
        return grid
    }
}

