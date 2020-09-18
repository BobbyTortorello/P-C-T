//
//  ViewController.swift
//  P-C-T
//
//  Created by Bobby Tortorello on 9/2/20.
//  Copyright © 2020 App Industries Inc. All rights reserved.
//

import UIKit
import CoreData

class StartViewController: UIViewController, UITableViewDelegate, UITabBarDelegate {
	
	@IBOutlet weak var myPetsTableView: UITableView!
     @IBOutlet weak var lostPetsTableView: UITableView!
     @IBOutlet weak var addPetButton: UIButton!
     
     var myPets = [MyPets]()
     var lostPets = [""]
     
     var userDefualts = UserDefaults.standard
     
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
                        print(myPet.count)
                        myPetsTableView.reloadData()
                   } catch {}
		
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
	@IBAction func messagesButton(_ sender: UIBarButtonItem) {
		let vc = storyboard?.instantiateViewController(withIdentifier: "messagesVC")
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
               count = lostPets.count
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
               cell!.textLabel?.text = "This is for lost Pets"
          }
          
          return cell!
     }
}
