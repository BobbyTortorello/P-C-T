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
	var userPhoneNumber = String()
	var petCount = Int()
	
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
	@IBAction func messagesButton(_ sender: UIBarButtonItem) {
	    let vc = storyboard?.instantiateViewController(withIdentifier: "messagesVC")
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
					self.userPhoneNumber = document.get("userPhoneNumber") as? String ?? String()
					self.lostPetsTableView.reloadData()
				}
			}
		}
	}
}

extension LostPetsViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return petCount
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "lostPetsTVC", for: indexPath)
		cell.textLabel?.text = petName[indexPath.row]
		cell.detailTextLabel?.text = "\(petType[indexPath.row])-\(petBreed[indexPath.row])"
		cell.imageView?.image = #imageLiteral(resourceName: "P-C-T Logo")
		return cell
	}
}
