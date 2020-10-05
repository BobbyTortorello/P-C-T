//
//  MyPetsViewController.swift
//  P-C-T
//
//  Created by Bobby Tortorello on 9/3/20.
//  Copyright © 2020 App Industries Inc. All rights reserved.
//

import UIKit
import CoreData

class MyPetsViewController: UIViewController, UITableViewDelegate {
     
     var myPets = [MyPets]()
     @IBOutlet weak var myPetsTableView: UITableView!
     
     override func viewDidLoad() {
          super.viewDidLoad()
          myPetsTableView.delegate = self
          myPetsTableView.dataSource = self
          
          let fetchRequest: NSFetchRequest<MyPets> = MyPets.fetchRequest()
          do {
			let myPet = try PersistanceService.context.fetch(fetchRequest)
               myPets = myPet
               print(myPet.count)
               myPetsTableView.reloadData()
          } catch {}
		
     }

     @IBAction func newPetsButton(_ sender: UIButton) {
          let vc = storyboard?.instantiateViewController(withIdentifier: "newPetVC")
          navigationController?.pushViewController(vc!, animated: false)
     }
	
	//MARK: Toolbar Buttons
	@IBAction func homeButton(_ sender: UIBarButtonItem) {
		let vc = storyboard?.instantiateViewController(withIdentifier: "homeVC")
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
	//Segue Function
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let indexPath = myPetsTableView.indexPathForSelectedRow
		let vc = segue.destination as? PetViewController
		vc?.petImage = myPets[(indexPath?.row)!].petImage ?? UIImage()
		vc?.petName = myPets[(indexPath?.row)!].petName ?? String()
		vc?.petType = myPets[(indexPath?.row)!].petType ?? String()
		vc?.petBreed = myPets[(indexPath?.row)!].petBreed ?? String()
	}
}

extension MyPetsViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return myPets.count
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: "myPetsTVC", for: indexPath)
          cell.textLabel?.text = myPets[indexPath.row].petName
          cell.detailTextLabel?.text = myPets[indexPath.row].petType
		cell.imageView?.image = myPets[indexPath.row].petImage
          return cell
     }
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			let alert = UIAlertController(title: "Are you sure you want to delete this pet?", message: "This is permanent!", preferredStyle: .alert)
			let yes = UIAlertAction(title: "Yes", style: .default) { (action) in
				PersistanceService.context.delete(self.myPets.remove(at: indexPath.row))
				PersistanceService.saveContext()
				tableView.deleteRows(at: [indexPath], with: .automatic)
			}
			let no = UIAlertAction(title: "No", style: .cancel, handler: nil)
			alert.addAction(yes)
			alert.addAction(no)
			present(alert, animated: true, completion: nil)
		}
	}
}
