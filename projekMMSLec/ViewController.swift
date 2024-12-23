//
//  ViewController.swift
//  projekMMSLec
//
//  Created by prk on 19/12/24.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func loginClicked(_ sender: Any) {
        performSegue(withIdentifier: "LoginSegue", sender: self)
    }
    
    @IBAction func registerClicked(_ sender: Any) {
        performSegue(withIdentifier: "RegisterSegue", sender: self)
    }
}

