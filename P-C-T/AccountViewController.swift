//
//  AccountViewController.swift
//  P-C-T
//
//  Created by Bobby Tortorello on 9/3/20.
//  Copyright © 2020 App Industries Inc. All rights reserved.
//

import UIKit
import GooglePlaces

class AccountViewController: UIViewController {
     
     let userDefaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
	
	//MARK: ToolBar Buttons

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
