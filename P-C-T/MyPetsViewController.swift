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
          //let vc = storyboard?.instantiateViewController(identifier: "newPetVC")
          let vc = storyboard?.instantiateViewController(withIdentifier: "newPetVC")
          navigationController?.show(vc!, sender: nil)
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
     
     
}
