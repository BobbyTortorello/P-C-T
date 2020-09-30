//
//  LostPets.swift
//  P-C-T
//
//  Created by Bobby Tortorello on 9/19/20.
//  Copyright © 2020 App Industries Inc. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

struct LostPets {
	var petName: String
	var petType: String
	var petBreed: String
	var petImage: String
	var userPhoneNumber: String
	var userAddress: String
	var userName: String
	var userEmail: String
	
	var dictionaryString : [String: Any] {
		return [
			"petName": petName,
			"petType": petType,
			"petBreed": petBreed,
			"petImage": petImage,
			"userPhoneNumber": userPhoneNumber,
			"userAddress": userAddress,
			"userName": userName,
			"userEmail": userEmail
		]
	}
}

extension LostPets: DocumentSerializable {
	init?(dictionary: [String: Any]) {
		guard let petName = dictionary["petName"] as? String,
			 let petType = dictionary["petType"] as? String,
			 let petBreed = dictionary["petBreed"] as? String,
			 let petImage = dictionary["petImage"] as? String,
			 let userPhoneNumber = dictionary["userPhoneNumber"] as? String,
			 let userAddress = dictionary["userAddress"] as? String,
			 let userName = dictionary["userName"] as? String,
			 let userEmail = dictionary["userEmail"] as? String else {return nil}
		self.init(dictionary: [
			petName: petName,
			petType: petType,
			petBreed: petBreed,
			petImage: petImage,
			userPhoneNumber: userPhoneNumber,
			userAddress: userAddress,
			userName: userName,
			userEmail: userEmail
		])
	}
}
