//
//  ViewController.swift
//  P-C-T
//
//  Created by Bobby Tortorello on 9/2/20.
//  Copyright © 2020 App Industries Inc. All rights reserved.
//

import UIKit
import CoreData
import FirebaseStorage
import FirebaseFirestore

class StartViewController: UIViewController, UITableViewDelegate, UITabBarDelegate {
	
	@IBOutlet weak var myPetsTableView: UITableView!
     @IBOutlet weak var lostPetsTableView: UITableView!
     @IBOutlet weak var addPetButton: UIButton!
     
     var myPets = [MyPets]()
     var lostPets = [""]
     
     var userDefualts = UserDefaults.standard
	
	var petCount = Int()
	var petName = [String]()
	var petType = [String]()
	var petBreed = [String]()
	var userPhoneNumber = [String]()
	
	let db = Firestore.firestore()
	let storage = Storage.storage()
     
     override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
          myPetsTableView.delegate = self
          lostPetsTableView.delegate = self
          myPetsTableView.dataSource = self
          lostPetsTableView.dataSource = self
          
          addPetButton.isHidden = true
          if userDefualts.bool(forKey: "accountCreated") == false {
			let alert = UIAlertController(title: "Do you want to create an account?", message: "You need one to add your own pets.", preferredStyle: .alert)
			let yes = UIAlertAction(title: "Yes, please", style: .default) { (action) in
				let vc = self.storyboard?.instantiateViewController(withIdentifier: "accountVC")
				self.navigationController?.pushViewController(vc!, animated: false)
			}
			let no = UIAlertAction(title: "Not Right Now", style: .cancel, handler: nil)
			alert.addAction(yes)
			alert.addAction(no)
			present(alert, animated: true, completion: nil)
          }
          
          let fetchRequest: NSFetchRequest<MyPets> = MyPets.fetchRequest()
                   do {
                        let myPet = try PersistanceService.context.fetch(fetchRequest)
                        myPets = myPet
                        myPetsTableView.reloadData()
                   } catch {}
		
		reloadData()
    }
	
     @IBAction func addPet(_ sender: UIButton) {
          let vc = storyboard?.instantiateViewController(withIdentifier: "newPetVC")
          navigationController?.pushViewController(vc!, animated: false)
     }
	
	//Segue Function
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let indexPath = myPetsTableView.indexPathForSelectedRow
		let vc = segue.destination as? PetViewController
		vc?.petImage = myPets[(indexPath?.row)!].petImage ?? UIImage()
		vc?.petName = myPets[(indexPath?.row)!].petName ?? String()
		vc?.petType = myPets[(indexPath?.row)!].petType ?? String()
		vc?.petBreed = myPets[(indexPath?.row)!].petBreed ?? String()
		
		let indexPathLP = lostPetsTableView.indexPathForSelectedRow
		let nvc = segue.destination as? LostPetViewController
		nvc?.petName = petName[indexPathLP!.row]
		nvc?.userPhoneNumber = userPhoneNumber[indexPathLP!.row]

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
					self.lostPetsTableView.reloadData()
				}
			}
		}
	}
	
	//MARK: Toolbar Buttons
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

//MARK: TableView Functions
extension StartViewController: UITableViewDataSource {
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          var count: Int?
          if tableView == myPetsTableView {
               count = myPets.count
               if count == 0 {
                    myPetsTableView.isHidden = true
                    addPetButton.isHidden = false
               }
          }
          if tableView == lostPetsTableView {
               count = petCount
          }
          return count!
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          var cell: UITableViewCell?
          if tableView == myPetsTableView {
               cell = myPetsTableView.dequeueReusableCell(withIdentifier: "myPetsTVC", for: indexPath)
               cell!.textLabel?.text = myPets[indexPath.row].petName
               cell?.detailTextLabel?.text = myPets[indexPath.row].petType
               cell?.imageView?.image = myPets[indexPath.row].petImage
          }
          
          if tableView == lostPetsTableView {
               cell = lostPetsTableView.dequeueReusableCell(withIdentifier: "lostPetsTVC", for: indexPath)
			cell!.textLabel?.text = petName[indexPath.row]
			cell?.detailTextLabel?.text = "\(petType[indexPath.row])-\(petBreed[indexPath.row])"
			
			//Pulling Image from FirebaseStorage
			let lostPetReference = self.storage.reference(forURL: "gs://pet-community-tr.appspot.com/lostPets/\(petName[indexPath.row])-\(userPhoneNumber[indexPath.row]).jpg")
			lostPetReference.getData(maxSize: 1000 * 2048 * 2048) { (data, error) in
				if let error = error {
					print(error)
				} else {
					let baseImage = UIImage(data: data!)
					cell?.imageView?.image = baseImage
					self.lostPetsTableView.reloadData()
			    }
			}
          }
          
          return cell!
     }
}
