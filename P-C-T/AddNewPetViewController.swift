//
//  AddNewPetViewController.swift
//  P-C-T
//
//  Created by Bobby Tortorello on 9/3/20.
//  Copyright © 2020 App Industries Inc. All rights reserved.
//

import UIKit

class AddNewPetViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

     @IBOutlet weak var petNameTextField: UITextField!
     @IBOutlet weak var petTypeTextField: UITextField!
     @IBOutlet weak var petBreedTextField: UITextField!
     @IBOutlet weak var petImageView: UIImageView!
     @IBOutlet weak var selectImageLabel: UILabel!
     @IBOutlet weak var selectImageButton: UIButton!
     
     let myPets = [MyPets]()
     let imagePicker = UIImagePickerController()
     
     override func viewDidLoad() {
        super.viewDidLoad()
          imagePicker.delegate = self
        // Do any additional setup after loading the view.
    }
    
     @IBAction func doneAction(_ sender: UIButton) {
          let myPet = MyPets(context: PersistanceService.context)
          myPet.petName = petNameTextField.text!
          myPet.petType = petTypeTextField.text!
          myPet.petBreed = petBreedTextField.text!
          myPet.petImage = petImageView.image!
          
          PersistanceService.saveContext()
          
          let vc = storyboard?.instantiateViewController(withIdentifier: "myPetsVC")
          //tabBarController?.show(vc!, sender: nil)
//          navigationController?.show(vc!, sender: nil)
          navigationController?.tabBarController?.show(vc!, sender: nil)
          navigationController?.tabBarController?.hidesBottomBarWhenPushed = false
     }
     
     @IBAction func selectImageAction(_ sender: UIButton) {
          let alert = UIAlertController(title: "Location of Image", message: "Please Select Camera or Photo Library", preferredStyle: .alert)
          let photoLibrary = UIAlertAction(title: "Photo Library", style: .default) { (action) in
               self.imagePicker.sourceType = .photoLibrary
               self.present(self.imagePicker, animated: true, completion: nil)
          }
          let camera = UIAlertAction(title: "Camera", style: .default) { (action) in
               self.imagePicker.sourceType = .camera
               self.present(self.imagePicker, animated: true, completion: nil)
          }
          let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
          alert.addAction(photoLibrary)
          alert.addAction(camera)
          alert.addAction(cancel)
          present(alert, animated: true, completion: nil)
     }
     
     func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
     {
          picker.dismiss(animated:true) {
               self.petImageView.image = info [UIImagePickerController.InfoKey.originalImage] as? UIImage
          }
          selectImageLabel.text = "Touch Here to Change Selected Image"
     }
}
