//
//  MessagesViewController.swift
//  P-C-T
//
//  Created by Bobby Tortorello on 9/13/20.
//  Copyright © 2020 App Industries Inc. All rights reserved.
//

import UIKit
import MessageKit

class MessageViewController: MessagesViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
	
        // Do any additional setup after loading the view.
	
     }
    
	//768 = y  coordinate for the messages so it doesn't get in the way of toolbar
	
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
}
