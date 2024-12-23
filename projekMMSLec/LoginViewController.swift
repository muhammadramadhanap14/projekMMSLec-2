//
//  LoginViewController.swift
//  projekMMSLec
//
//  Created by prk on 19/12/24.
//

import UIKit
import CoreData

class LoginViewController: UIViewController {

    
    @IBOutlet weak var usernameTF: UITextField!
    
    @IBOutlet weak var passwordTF: UITextField!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func unwindLogin(unwindSegue: UIStoryboardSegue){
        print("success")
    }
    
    @IBAction func loginClicked(_ sender: Any) {
        guard let username = usernameTF.text, !username.isEmpty,
              let password = passwordTF.text, !password.isEmpty else{
            showAlert(message: "Please fill username and password")
            return
        }
        
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "username == %@ AND password == %@", username, password)
        
        do{
            let users = try context.fetch(fetchRequest)
            if users.count > 0{
                let user = users.first
                if let userID = user?.userID{
                    UserDefaults.standard.set(userID.uuidString, forKey: "userUUID")
                    navigateToHome()
                }
                showAlert(message:"Login successful")
            }else{
                showAlert(message: "Error fetching user")
            }
        }catch{
            showAlert(message: "Error")
        }
        
        
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Info", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true, completion: nil)
    }
    
    func navigateToHome() {
            if let onboardingVC = storyboard?.instantiateViewController(withIdentifier: "HomeViewController") {
                
            if let window = UIApplication.shared.windows.first {
                window.rootViewController = onboardingVC
                window.makeKeyAndVisible()
            }
        }
    }

}
