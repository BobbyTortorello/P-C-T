//
//  LostPetsViewController.swift
//  P-C-T
//
//  Created by Bobby Tortorello on 9/16/20.
//  Copyright © 2020 App Industries Inc. All rights reserved.
//

import UIKit

class LostPetsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
}
