//
//  ViewController.swift
//  P-C-T
//
//  Created by Bobby Tortorello on 9/2/20.
//  Copyright © 2020 App Industries Inc. All rights reserved.
//

import UIKit
import CoreData

class StartViewController: UIViewController, UITableViewDelegate {

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
          if userDefualts.string(forKey: "userName") == nil {
               let vc = storyboard?.instantiateViewController(withIdentifier: "accountVC")
               navigationController?.show(vc!, sender: nil)
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
          navigationController?.show(vc!, sender: nil)
     }
}

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