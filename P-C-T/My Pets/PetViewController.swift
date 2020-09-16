//
//  PetViewController.swift
//  P-C-T
//
//  Created by Bobby Tortorello on 9/14/20.
//  Copyright © 2020 App Industries Inc. All rights reserved.
//

import UIKit

class PetViewController: UIViewController {

     @IBOutlet weak var petNameLabel: UILabel!
	@IBOutlet weak var petTypeLabel: UILabel!
	@IBOutlet weak var petBreedLabel: UILabel!
	@IBOutlet weak var petImageView: UIImageView!

    override func viewDidLoad() {
		super.viewDidLoad()
	
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
	@IBAction func messagesButton(_ sender: UIBarButtonItem) {
		let vc = storyboard?.instantiateViewController(withIdentifier: "messagesVC")
		navigationController?.pushViewController(vc!, animated: false)
	}
}
