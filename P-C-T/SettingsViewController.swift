//
//  MessagesViewController.swift
//  P-C-T
//
//  Created by Bobby Tortorello on 9/13/20.
//  Copyright © 2020 App Industries Inc. All rights reserved.
//

import UIKit
import MapKit
import CoreData

@available(iOS 13.0, *)
class SettingsViewController: UIViewController, UITableViewDelegate, MKMapViewDelegate, CLLocationManagerDelegate {
	
	let defaults = UserDefaults.standard
	
	override func viewDidLoad() {
		super.viewDidLoad()
		milageLabel.text = "Show me lost pets within \(defaults.integer(forKey: "milage")) of my current location"
		
		milageSlider.value = Float(defaults.integer(forKey: "milage"))
		
		homeViewTableView.delegate = self
		homeViewTableView.dataSource = self
		
		locationManager.delegate = self
		locationManager.requestAlwaysAuthorization()
		locationManager.startUpdatingLocation()
		
		mapKitView.delegate = self
		mapKitView.showsUserLocation = true
     }
	
	
	
	//MARK: MapView Code Area
	
	@IBOutlet var mapView: UIView!
	@IBOutlet var mapKitView: MKMapView!
	@IBOutlet var milageLabel: UILabel!
	@IBOutlet var milageSlider: UISlider!
	var locationManager = CLLocationManager()
	var circle:MKCircle!
	
	@IBAction func milageChanged(_ sender: UISlider) {
		defaults.setValue(milageSlider.value, forKey: "milage")
		milageLabel.text = "Show me lost pets within \(defaults.integer(forKey: "milage")) miles of my current location"
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
	{
	     locationManager.stopUpdatingLocation()
		let userLocation = mapKitView.userLocation.coordinate
		circle = MKCircle(center: userLocation, radius: CLLocationDistance(milageSlider.value))
		let span = MKCoordinateSpan(latitudeDelta: circle.coordinate.latitude, longitudeDelta: circle.coordinate.longitude)
		let region = MKCoordinateRegion(center: userLocation, span: span)
		mapKitView.setRegion(region, animated: true)
		self.mapKitView.addOverlay(circle)
	}
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
	{
	    return
	}

//	func loadOverlayForRegionWithLatitude(latitude: Double, andLongitude longitude: Double) {
//
//	}
	
	func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
		let circleRenderer = MKCircleRenderer(overlay: overlay)
		circleRenderer.fillColor = UIColor.blue.withAlphaComponent(0.1)
		circleRenderer.strokeColor = UIColor.blue
		circleRenderer.lineWidth = 1
		return circleRenderer
	}
	
	//MARK: HomeView Code Area
	@IBOutlet var homeView: UIView!
	@IBOutlet var homeViewTableView: UITableView!
	
	let headers = ["Location Services"]
	let headerPictures = [UIImage.init(systemName: "location.north")]
	
	
	
	//MARK: Toolbar Buttons
	@IBAction func homeButton(_ sender: UIBarButtonItem) {
		let vc = storyboard?.instantiateViewController(withIdentifier: "homeVC")
		navigationController?.pushViewController(vc!, animated: false)
	}
	@IBAction func myPetsButton(_ sender: UIBarButtonItem) {
		let vc = storyboard?.instantiateViewController(withIdentifier: "myPetsVC")
		navigationController?.pushViewController(vc!, animated: false)
	}
	@IBAction func lostPetsButton(_ sender: UIBarButtonItem) {
		let vc = storyboard?.instantiateViewController(withIdentifier: "lostPetsVC")
		navigationController?.pushViewController(vc!, animated: false)
	}
}

@available(iOS 13.0, *)
extension SettingsViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return headers.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "homeTVC", for: indexPath)
		cell.textLabel?.text = headers[indexPath.row]
		cell.imageView?.image = headerPictures[indexPath.row]
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.row == 0 {
			homeView.isHidden = true
			mapView.isHidden = false
		}
	}
}
