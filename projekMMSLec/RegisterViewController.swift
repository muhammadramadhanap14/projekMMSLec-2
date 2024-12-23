//
//  RegisterViewController.swift
//  projekMMSLec
//
//  Created by prk on 19/12/24.
//

import UIKit
import CoreData

class RegisterViewController: UIViewController {

    @IBOutlet weak var EmailTF: UITextField!
    @IBOutlet weak var UsernameTF: UITextField!
    @IBOutlet weak var PhoneTF: UITextField!
    @IBOutlet weak var PasswordTF: UITextField!
    @IBOutlet weak var cpasswordTF: UITextField!
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func unwindRegister(unwindSegue: UIStoryboardSegue){
        print("succes")
    }
    
    @IBAction func RegisterClicked(_ sender: Any) {
        
        let username = UsernameTF.text
        let email = EmailTF.text
        let phone = PhoneTF.text
        let password = PasswordTF.text
        let cpassword = cpasswordTF.text
        
        let validation = validateInputs(username: username, email: email, phone: phone, password: password, cpassword: cpassword)
        
        if !validation.isValid{
            showAlert(message: validation.message ?? "Error")
            return
        }
        
        let userUUID = generateUUID()
        
        let user = User(context: context)
        user.userID = userUUID
        user.username = username
        user.email = email
        user.phone = phone
        user.password = password
        
        do{
            try context.save()
            showAlert(message: "Register Successful")
        } catch{
            print("Error: \(error)")
            showAlert(message: "Error at saving data")
        }
    }
    
    func validateInputs(username: String?, email: String?, phone: String?, password: String?, cpassword: String?) -> (isValid: Bool, message: String?) {
        
        // Cek apakah semua field sudah terisi
        if username?.isEmpty ?? true || email?.isEmpty ?? true || phone?.isEmpty ?? true || password?.isEmpty ?? true {
            return (false, "All credentials must be filled")
        }
        if (password != cpassword) {
            return(false, "Password does not match")
        }
        // Validasi format email
        if let email = email, !isValidEmail(email) {
            return (false, "Format email must end with @gmail.com")
        }
        
        // Validasi nomor telepon
        if let phone = phone, !isValidPhoneNumber(phone) {
            return (false, "Format phone number must begin with 08...")
        }
        
        // Validasi password
        if let password = password, !isValidPassword(password) {
            return (false, "Password must at least 8 character")
        }
        
        // Jika semua validasi lolos
        return (true, nil)
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@gmail\\.com$"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }

    // Fungsi untuk memvalidasi nomor telepon yang dimulai dengan 08 dan panjang 10-13 karakter
    func isValidPhoneNumber(_ phone: String) -> Bool {
        let phoneRegex = "^08\\d{8,11}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: phone)
    }
    
    func isValidPassword(_ password: String) -> Bool {
        return password.count >= 8
    }
    
    func generateUUID() -> UUID {
        return UUID()
    }
    
    func showAlert(message: String) {
            let alert = UIAlertController(title: "Info", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true, completion: nil)
        }
}
