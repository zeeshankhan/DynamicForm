//
//  ViewController.swift
//  SignupPOC
//
//  Created by Zeeshan Khan on 4/2/17.
//  Copyright © 2017 Zeeshan Khan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var btnSignup: UIButton!
    @IBOutlet weak var btnSignin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Dynamic Form"
        btnSignup.layer.cornerRadius = 4.0
        btnSignin.layer.cornerRadius = 4.0
    }

    @IBAction func pushSignUp() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignupSigninVC") as! SignupSigninVC
        vc.viewType = .signUp
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func pushSignIn() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignupSigninVC") as! SignupSigninVC
        vc.viewType = .signIn
        navigationController?.pushViewController(vc, animated: true)
    }

}

