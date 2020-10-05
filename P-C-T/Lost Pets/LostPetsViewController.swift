//
//  LostPetsViewController.swift
//  P-C-T
//
//  Created by Bobby Tortorello on 9/16/20.
//  Copyright © 2020 App Industries Inc. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage

class LostPetsViewController: UIViewController, UITableViewDelegate {

	@IBOutlet var lostPetsTableView: UITableView!
		
	let db = Firestore.firestore()
	let storage = Storage.storage()
	
	var petName = [String]()
	var petType = [String]()
	var petBreed = [String]()
	var userPhoneNumber = [String]()
	var petCount = Int()
	var lostPetText = String()
	var petImage = [UIImage]()
	
	let indexPath2 : IndexPath = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		lostPetsTableView.delegate = self
		lostPetsTableView.dataSource = self
		
		lostPetsTableView.reloadData()
		reloadData()
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
	@IBAction func settingsButton(_ sender: UIBarButtonItem) {
	    let vc = storyboard?.instantiateViewController(withIdentifier: "settingsVC")
	    navigationController?.pushViewController(vc!, animated: false)
	}
	
	@IBAction func lostPetsButton(_ sender: UIBarButtonItem) {
		let vc = storyboard?.instantiateViewController(withIdentifier: "lostPetsVC")
		navigationController?.pushViewController(vc!, animated: false)
	}
	
	func reloadData() {
		self.db.collection("lostPets").getDocuments { (snapshot, err) in
			if let err = err {
				print("Error getting documents: \(err)")
			} else {
				for document in snapshot!.documents {
					self.petCount = snapshot?.documents.count ?? Int()
					self.petName.append(document.get("petName") as? String ?? String())
					self.petType.append(document.get("petType") as? String ?? String())
					self.petBreed.append(document.get("petBreed") as? String ?? String())
					self.userPhoneNumber.append(document.get("userPhoneNumber") as? String ?? String())
					self.lostPetText.append(document.get("petImage") as? String ?? String())
					self.lostPetsTableView.reloadData()
				}
			}
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let indexPath = lostPetsTableView.indexPathForSelectedRow
		let nvc = segue.destination as? LostPetViewController
		nvc?.petName = petName[indexPath!.row]
		nvc?.userPhoneNumber = userPhoneNumber[indexPath!.row]
	}
}

extension LostPetsViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return petCount
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "lostPetsTVC", for: indexPath)
		cell.textLabel?.text = petName[indexPath.row]
		cell.detailTextLabel?.text = "\(petType[indexPath.row])"
		
		//Pulling Image from FirebaseStorage
		let lostPetReference = self.storage.reference(forURL: "gs://pet-community-tr.appspot.com/lostPets/\(petName[indexPath.row])-\(userPhoneNumber[indexPath.row]).jpg")
		lostPetReference.getData(maxSize: 1000 * 2048 * 2048) { (data, error) in
			if let error = error {
				print(error)
			} else {
				let baseImage = UIImage(data: data!)
				cell.imageView?.image = baseImage
				self.lostPetsTableView.reloadData()
		    }
		}
		
		return cell
	}
}

//MARK: UIImage Rotate Function
extension UIImage {
    func rotate(radians: Float) -> UIImage? {
	   var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
	   // Trim off the extremely small float value to prevent core graphics from rounding it up
	   newSize.width = floor(newSize.width)
	   newSize.height = floor(newSize.height)

	   UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
	   let context = UIGraphicsGetCurrentContext()!

	   // Move origin to middle
	   context.translateBy(x: newSize.width/2, y: newSize.height/2)
	   // Rotate around middle
	   context.rotate(by: CGFloat(radians))
	   // Draw the image at its center
	   self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))

	   let newImage = UIGraphicsGetImageFromCurrentImageContext()
	   UIGraphicsEndImageContext()

	   return newImage
    }
}
