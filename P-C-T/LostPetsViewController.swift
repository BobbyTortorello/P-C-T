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
	
	var petName = [String]()
	var petType = [String]()
		
	let db = Firestore.firestore()
	let storage = Storage.storage()
	
	private var lostPets: [LostPets] = []
	private var documents: [DocumentSnapshot] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		lostPetsTableView.delegate = self
		lostPetsTableView.dataSource = self
		
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
	
	func reloadData() {
		db.collection("lostPets").getDocuments { (querySnapshot, err) in
			if let err = err {
				print("Error getting documents: \(err)")
			} else {
				for document in querySnapshot!.documents {
					print("\(document.documentID) => \(document.data())")
					let documents = LostPets.init(dictionary: document.data())
					self.lostPets.append(documents!)
				}
			}
		}
	}
}

extension LostPetsViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return lostPets.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "lostPetsTVC", for: indexPath)
		cell.textLabel?.text = lostPets[indexPath.row].petName
		cell.detailTextLabel?.text = lostPets[indexPath.row].petType
		cell.imageView?.image = #imageLiteral(resourceName: "P-C-T Logo")
		return cell
	}
}
