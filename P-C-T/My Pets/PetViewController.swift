//
//  PetViewController.swift
//  P-C-T
//
//  Created by Bobby Tortorello on 9/14/20.
//  Copyright © 2020 App Industries Inc. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage
import CoreData

class PetViewController: UIViewController {

     @IBOutlet weak var petNameLabel: UILabel!
	@IBOutlet weak var petTypeLabel: UILabel!
	@IBOutlet weak var petBreedLabel: UILabel!
	@IBOutlet weak var petImageView: UIImageView!

	
	var petImage = UIImage()
	var petName = String()
	var petType = String()
	var petBreed = String()
	
	var db = Firestore.firestore()
	var storage = Storage.storage()
	let defaults = UserDefaults.standard
	
	override func viewDidLoad() {
		super.viewDidLoad()
		petImageView.image = petImage
		petNameLabel.text = petName
		petTypeLabel.text = petType
		petBreedLabel.text = petBreed
	}
	
	@IBAction func markAsMissingButton(_ sender: UIButton) {
		let storageRef = storage.reference()
		print(storage.reference())
		let fileName = "\(petName)-\(defaults.string(forKey: "userPhoneNumber") ?? String())"
		let data = petImage.pngData()
		
		let lostPetRef = storageRef.child("lostPets/\(fileName).jpg")
		db.collection("lostPets").document("\(petName)-\(defaults.string(forKey: "userPhoneNumber") ?? String())").setData([
			"petName" : petName,
			"petType" : petType,
			"petBreed" : petBreed,
			"petImage": lostPetRef.fullPath,
			"userName" : defaults.string(forKey: "userName") ?? String(),
			"userEmail" : defaults.string(forKey: "userEmail") ?? String(),
			"userPhoneNumber" : defaults.string(forKey: "userPhoneNumber") ?? String(),
			"userAddress" : defaults.string(forKey: "userAddress") ?? String()
		]) { err in
			if let err = err {
				print("Could not upload file due to \(err)")
			} else {
				let alert = UIAlertController(title: "Your pet has been marked as missing.", message: "People can now start looking for it!", preferredStyle: .alert)
				let okay = UIAlertAction(title: "Okay", style: .default, handler: nil)
				alert.addAction(okay)
				self.present(alert, animated: true, completion: nil)
			}
		
		}
		
		//MARK: Firebase Storage Function
		// Upload the file to the path "lostPets/petName-userPhoneNumber.jpg"
		let uploadTask = lostPetRef.putData(data!, metadata: nil) { (metadata, error) in
		    guard let metadata = metadata else {
			print(error as Any)
			   return
		    }
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let vc = segue.destination as? MyPetsViewController
		let indexPath = vc?.myPetsTableView.indexPathForSelectedRow
		petName = (vc?.myPets[(indexPath?.row)!].petName) ?? String()
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
	@IBAction func settingsButton(_ sender: UIBarButtonItem) {
	    let vc = storyboard?.instantiateViewController(withIdentifier: "settingsVC")
	    navigationController?.pushViewController(vc!, animated: false)
	}
}
