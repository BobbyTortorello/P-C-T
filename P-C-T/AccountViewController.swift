//
//  AccountViewController.swift
//  P-C-T
//
//  Created by Bobby Tortorello on 9/3/20.
//  Copyright © 2020 App Industries Inc. All rights reserved.
//

import UIKit
import GooglePlaces
import FirebaseFirestore

class AccountViewController: UIViewController {
     
     let userDefaults = UserDefaults.standard

	@IBOutlet var userNameView: UIView!
	@IBOutlet var userAddressView: UIView!
	@IBOutlet var nextButtonLabel: UILabel!
	
	
	@IBOutlet var userNameTextField: UITextField!
	@IBOutlet var userEmailTextField: UITextField!
	@IBOutlet var userPhoneNumberTextField: UITextField!
	@IBOutlet var userAddressLabel: UILabel!
	
	var resultsViewController: GMSAutocompleteResultsViewController?
	var searchController: UISearchController?
	var resultView: UITextView?
	
	let db = Firestore.firestore()
	
	override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
		resultsViewController = GMSAutocompleteResultsViewController()
		resultsViewController?.delegate = self
		searchController = UISearchController(searchResultsController: resultsViewController)
		searchController?.searchResultsUpdater = resultsViewController

		let subView = UIView(frame: CGRect(x: 0, y: -8.0, width: 350.0, height: 50.0))

		subView.addSubview((searchController?.searchBar)!)
		userAddressView.addSubview(subView)
		searchController?.searchBar.sizeToFit()
		searchController?.hidesNavigationBarDuringPresentation = false
		// When UISearchController presents the results view, present it in
		// this view controller, not one further up the chain.
		definesPresentationContext = true
		
		userAddressView.isHidden = true
		
		//Setting the background depending on if the device is in Dark Mode or not
		if #available(iOS 13.0, *) {
		    resultsViewController?.tableCellBackgroundColor = UIColor.systemBackground
		} else {
		    // Fallback on earlier versions
		    resultsViewController?.tableCellBackgroundColor = UIColor.white
		}
	}
	
	//MARK: ToolBar Buttons
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
	
	@IBAction func messagesButton(_ sender: UIBarButtonItem) {
		let vc = storyboard?.instantiateViewController(withIdentifier: "messagesVC")
		navigationController?.pushViewController(vc!, animated: false)
	}
	
	@IBAction func nextButton(_ sender: UIButton) {
		if nextButtonLabel.text == "Next" {
			nextButtonLabel.text = "Done"
			userNameView.isHidden = true
			userAddressView.isHidden = false
			
			userDefaults.setValue(userNameTextField.text, forKey: "userName")
			userDefaults.setValue(userEmailTextField.text, forKey: "userEmail")
			userDefaults.setValue(userPhoneNumberTextField.text, forKey: "userPhoneNumber")
		} else if nextButtonLabel.text == "Done" {
			userDefaults.setValue(userAddressLabel.text, forKey: "userAddress")
			
			let alert = UIAlertController(title: "Do you want to add a pet?", message: "You can always add one later.", preferredStyle: .alert)
			let yes = UIAlertAction(title: "Yes", style: .default) { (action) in
				let vc = self.storyboard?.instantiateViewController(withIdentifier: "addPetVC")
				self.navigationController?.pushViewController(vc!, animated: false)
				self.userDefaults.setValue(true, forKey: "accountCreated")
			}
			let no = UIAlertAction(title: "No", style: .default) { (action) in
				let vc = self.storyboard?.instantiateViewController(withIdentifier: "homeVC")
				self.navigationController?.pushViewController(vc!, animated: false)
				self.userDefaults.setValue(true, forKey: "accountCreated")
			}
			alert.addAction(yes)
			alert.addAction(no)
			present(alert, animated: true, completion: nil)
			
			db.collection("users").document("\(userNameTextField.text!)-\(userPhoneNumberTextField.text!)").setData([
				"userName" : userDefaults.string(forKey: "userName") ?? String(),
				"userEmail" : userDefaults.string(forKey: "userEmail") ?? String(),
				"userPhoneNumber" : userDefaults.string(forKey: "userPhoneNumber") ?? String(),
				"userAddress": userDefaults.string(forKey: "userAddress") ?? String()
			]) { err in
				if let err = err {
					print("Could not add document due to \(err)")
				}
			}
		}
	}
}

extension AccountViewController: GMSAutocompleteResultsViewControllerDelegate {
	func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didAutocompleteWith place: GMSPlace) {
	    searchController?.isActive = false
	    // Do something with the selected place.
		userAddressLabel.text = place.formattedAddress
		if #available(iOS 13.0, *) {
			userAddressLabel.textColor = UIColor.label
		} else {
			userAddressLabel.textColor = UIColor.black
		}
	  }

	  func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didFailAutocompleteWithError error: Error){
	    // TODO: handle the error.
	    print("Error: ", error.localizedDescription)
	  }

	  // Turn the network activity indicator on and off again.
	  func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
	    UIApplication.shared.isNetworkActivityIndicatorVisible = true
	  }

	  func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
	    UIApplication.shared.isNetworkActivityIndicatorVisible = false
	  }
}
