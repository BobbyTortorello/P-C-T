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

class SettingsViewController: UIViewController {

	@IBOutlet var mapView: MKMapView!
	@IBOutlet var milageLabel: UILabel!
	@IBOutlet var milageSlider: UISlider!
	
	let defaults = UserDefaults.standard
	
	override func viewDidLoad() {
		super.viewDidLoad()
		milageLabel.text = "Show me lost pets within \(defaults.integer(forKey: "milage")) of my current location"
		
		milageSlider.value = Float(defaults.integer(forKey: "milage"))
     }
	
	@IBAction func milageChanged(_ sender: UISlider) {
		defaults.setValue(milageSlider.value, forKey: "milage")
		milageLabel.text = "Show me lost pets within \(defaults.integer(forKey: "milage")) of my current location"
	}
	
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
