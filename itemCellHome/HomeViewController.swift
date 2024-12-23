import UIKit
import CoreData

class HomeViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var scheduleToday: UILabel!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var SearchBox: UISearchBar!
    @IBOutlet weak var username: UILabel!

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let uuid = UserDefaults.standard.string(forKey: "userUUID")
    
    // Array of Tuples to replace the Item struct
    var items: [(title: String, image: UIImage)] = []
    var originalItems: [(title: String, image: UIImage)] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let userUUID = uuid {
            fetchUserData(userUUID: userUUID) // Fetch user data using the UUID
        } else {
            print("User UUID not found in UserDefaults.")
        }

        // Sample data with safe image loading (using Tuples instead of struct)
        items = [
            ("Warm Up", UIImage(named: "Warm Up") ?? UIImage(named: "defaultImage") ?? UIImage()),
            ("Yoga", UIImage(named: "Yoga") ?? UIImage(named: "defaultImage") ?? UIImage()),
            ("Squats", UIImage(named: "Squats") ?? UIImage(named: "defaultImage") ?? UIImage()),
            ("Body Build", UIImage(named: "Body Builder") ?? UIImage(named: "defaultImage") ?? UIImage())
        ]
        
        // Save original items for search functionality
        originalItems = items
        
        // Image profile setup
        imageProfile.layer.masksToBounds = true
        imageProfile.layer.cornerRadius = imageProfile.frame.height / 2
        
        // Set the search bar delegate
        SearchBox.delegate = self
        
        // Set the collection view delegate and data source
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Register the custom cell for collection view programmatically (if using custom class)
        collectionView.register(UINib(nibName: "itemCellHomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "itemCellHome")
        
        // Set the collection view layout (UICollectionViewFlowLayout)
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.itemSize = CGSize(width: 150, height: 180)  // Set item size
            flowLayout.minimumInteritemSpacing = 10  // Horizontal spacing
            flowLayout.minimumLineSpacing = 10  // Vertical spacing
        }
    }
    
    // Fetch user data from Core Data
    func fetchUserData(userUUID: String) {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "userID == %@", userUUID)

        print("User UUID from UserDefaults: \(uuid ?? "No UUID found")")
        
        do {
            let users = try context.fetch(fetchRequest)
            print("Found \(users.count) users matching the UUID")
            
            if let user = users.first {
                username.text = "Hello, Welcome \(user.username ?? "Unknown")"
            } else {
                showAlert(message: "User not found.")
            }
        } catch {
            showAlert(message: "Error fetching user data.")
        }
    }
    
    // Show alert function
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Info", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true, completion: nil)
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    // Return the number of items in the section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    // Configure each cell with data
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Dequeue the reusable cell using the correct reuse identifier
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCellHome", for: indexPath) as? itemCellHomeCollectionViewCell else {
            return UICollectionViewCell() // Return a default cell if the identifier is incorrect
        }
        
        // Get the current item data (using tuple instead of Item struct)
        let item = items[indexPath.row]
        
        // Set title and image for each cell
        cell.configureCell(withTitle: item.title, andImage: item.image)
        
        // Set dynamic background color based on the index
        let colors: [UIColor] = [
            UIColor.lightText,    // First item
            UIColor.lightText,        // Second item
            UIColor.lightText,         // Third item
            UIColor.lightText        // Fourth item
        ]
        
        let colorIndex = indexPath.row % colors.count
        cell.setBackgroundColorOrImage(colors[colorIndex]) // Set the background color
        
        return cell
    }
    
    // Handle item click event
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Get the selected item
        let selectedItem = items[indexPath.row]
        
        // Action to perform when item is clicked
        print("Selected item: \(selectedItem.title)")
        
        // Navigate to video page (or another view controller)
        performSegue(withIdentifier: "showVideoPage", sender: selectedItem)
    }
}

extension HomeViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            items = originalItems
        } else {
            items = originalItems.filter { $0.title.lowercased().contains(searchText.lowercased()) }
        }
        collectionView.reloadData()
        
        // Dismiss the keyboard when search is finished
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Dismiss the keyboard when search button is clicked
        searchBar.resignFirstResponder()
    }
}

// Prepare for segue to video page
extension HomeViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showVideoPage", let videoPageVC = segue.destination as? videoPageViewController, let selectedItem = sender as? (title: String, image: UIImage) {
            // Pass the selected item to the next view controller
            print("Preparing to navigate to Video Page with item: \(selectedItem.title)")
            // You can customize the next screen with data passed here if needed
        }
    }
}
