import UIKit
import CoreData

class ProfileViewController: UIViewController {

    @IBOutlet weak var userUsername: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userPhone: UILabel!
    @IBOutlet weak var userPassword: UILabel!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let uuid = UserDefaults.standard.string(forKey: "userUUID")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let uuidString = uuid {
            fetchUserData(userUUID: uuidString)
        } else {
            showAlert(message: "No User Logged in.")
        }
    }
    
    func fetchUserData(userUUID: String) {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "userID == %@", userUUID)
        
        print("User UUID from UserDefaults: \(uuid ?? "No UUID found")")
        
        do {
            let users = try context.fetch(fetchRequest)
            
            print("Found \(users.count) users matching the UUID")
            
            if let user = users.first {
                print(user.username as Any)
                userUsername.text = "Hello, \(user.username ?? "No Name")"
                userEmail.text = user.email ?? "No Email"
                userPhone.text = user.phone ?? "No Phone"
                userPassword.text = user.password ?? "No Password"
            } else {
                showAlert(message: "User not found.")
            }
        } catch {
            showAlert(message: "Error fetching user data.")
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Info", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true, completion: nil)
    }

    func showAlertLog(message: String, onConfirm: @escaping () -> Void) {
        let alert = UIAlertController(title: "Info", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
            onConfirm()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    @IBAction func getPremiumBtn(_ sender: Any) {
        // Perform the segue to the PremiumViewController
        performSegue(withIdentifier: "showPremiumPage", sender: self)
    }
    
    @IBAction func logoutBtn(_ sender: Any) {
        showAlertLog(message: "Are you sure you want to logout?") {
            self.navigateToOnboarding()
            UserDefaults.standard.removeObject(forKey: "userUUID")
        }
    }
    
    func navigateToOnboarding() {
        if let onboardingVC = storyboard?.instantiateViewController(withIdentifier: "OnboardingViewController") {
            if let window = UIApplication.shared.windows.first {
                window.rootViewController = onboardingVC
                window.makeKeyAndVisible()
            }
        }
    }
}
