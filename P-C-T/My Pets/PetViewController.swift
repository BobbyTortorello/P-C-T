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
	
	override func viewDidLoad() {
		super.viewDidLoad()
		petImageView.image = petImage
		petNameLabel.text = petName
		petTypeLabel.text = petType
		petBreedLabel.text = petBreed
	}
	
	@IBAction func markAsMissingButton(_ sender: UIButton) {
		db.collection("lostPets").document("\(petName)-\(123)").setData([
			"petName" : petName,
			"petType" : petType,
			"petBreed" : petBreed
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
	@IBAction func messagesButton(_ sender: UIBarButtonItem) {
		let vc = storyboard?.instantiateViewController(withIdentifier: "messagesVC")
		navigationController?.pushViewController(vc!, animated: false)
	}
}
