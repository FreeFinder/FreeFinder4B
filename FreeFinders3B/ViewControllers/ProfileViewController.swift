//
//  ProfileViewController.swift
//  FreeFinders3B
//
//  Created by Ellen Chen on 11/7/22.
//

import Foundation
import UIKit

class ProfileViewController: UIViewController{
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var editProfile: UIButton!
    @IBOutlet weak var signOut: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        profileImage.layer.masksToBounds = true
        profileImage.layer.cornerRadius = profileImage.bounds.width / 2
            
        // TODO: connect to data
        name.text = "Jane Doe"
        email.text = "test@test.com"
    }
}
