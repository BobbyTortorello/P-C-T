//
//  LostPetViewController.swift
//  P-C-T
//
//  Created by Bobby Tortorello on 10/2/20.
//  Copyright © 2020 App Industries Inc. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage

class LostPetViewController: UIViewController {

	@IBOutlet var lostPetNameLabel: UILabel!
	@IBOutlet var lostPetTypeLabel: UILabel!
	@IBOutlet var lostPetBreedLabel: UILabel!
	
	@IBOutlet var lostPetImageView: UIImageView!
	
	var petName = String()
//	var petType = String()
//	var petBreed = String()
//	var petImage = UIImage()
	var userPhoneNumber = String()
	
	let db = Firestore.firestore()
	let storage = Storage.storage()
	override func viewDidLoad() {
        super.viewDidLoad()
//		lostPetNameLabel.text = petName
//		lostPetTypeLabel.text = petType
//		lostPetBreedLabel.text = petBreed
//		lostPetImageView.image = petImage
		
		let docRef = db.collection("lostPets").document("\(petName)-\(userPhoneNumber)")
		docRef.getDocument { (document, error) in
		    if let document = document, document.exists {
			   let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
			   print("Document data: \(dataDescription)")
			   self.lostPetNameLabel.text = document.get("petName") as? String
			   self.lostPetTypeLabel.text = document.get("petType") as? String
			   self.lostPetBreedLabel.text = document.get("petBreed") as? String
//			   self.userPhoneNumberLabel.text = document.get("userPhoneNumber") as? String
//			   self.userAddressLabel.text = document.get("userAddress") as? String
//			   self.lklLabel.text = document.get("lkl") as? String
		    } else {
			   print("Document does not exist")
		    }
		}
		
		//Pulling Image from Storage and roating it so it is correct orientation
		let lostPetReference = storage.reference(forURL: "gs://pet-community-tr.appspot.com/lostPets/\(petName)-\(userPhoneNumber).jpg")
		lostPetReference.getData(maxSize: 1000 * 2048 * 2048) { (data, error) in
		    if let error = error {
			   print(error)
		    } else {
				let baseImage = UIImage(data: data!)
				self.lostPetImageView.image = baseImage
		    }
		}
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
