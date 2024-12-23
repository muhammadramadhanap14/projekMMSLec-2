import UIKit

class videoPageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, VideoPageTableViewCellDelegate {

    @IBOutlet weak var tableViewController: UITableView!
    
    var selectedItem: (title: String, image: UIImage)?  // Add a property to store the selected item
    
    // Updated to include URL for each video
    let videos = [
        ("Video 1", UIImage(named: "personal trainer 1") ?? UIImage(), "3:45", "https://www.youtube.com/watch?v=GwR_jzbH8ZY"),
        ("Video 2", UIImage(named: "personal trainer 1") ?? UIImage(), "5:12", "https://www.youtube.com/watch?v=EvF_Jnf9jwg"),
        ("Video 3", UIImage(named: "personal trainer 1") ?? UIImage(), "2:30", "https://www.youtube.com/watch?v=3X0hEHop8ec"),
        ("Video 4", UIImage(named: "personal trainer 1") ?? UIImage(), "3:45", "https://www.youtube.com/watch?v=-p0PA9Zt8zk"),
        ("Video 5", UIImage(named: "personal trainer 1") ?? UIImage(), "3:45", "https://www.youtube.com/watch?v=2MoGxae-zyo"),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewController.dataSource = self
        tableViewController.delegate = self
        
        // Optionally, display selected item info (e.g., title, image)
        if let item = selectedItem {
            print("Selected Item: \(item.title)")
            // You can display additional data like the image or title in a label or header
        }
    }

    // MARK: - UITableView DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "VideoPageCell", for: indexPath) as? videoPageTableViewCell else {
            return UITableViewCell()
        }

        let video = videos[indexPath.row]
        cell.configure(with: video.0, image: video.1, duration: video.2)
        cell.delegate = self
        
        return cell
    }

    // MARK: - UITableView Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedVideo = videos[indexPath.row]
        
        // Open the video URL in Safari
        if let url = URL(string: selectedVideo.3) {
            UIApplication.shared.open(url)
        } else {
            print("Invalid URL for video: \(selectedVideo.0)")
        }
        
        print("Selected video: \(selectedVideo.0)")
    }
    
    // MARK: - VideoPageTableViewCell Delegate
    
    func didTapPlayButton(for cell: videoPageTableViewCell) {
        guard let indexPath = tableViewController.indexPath(for: cell) else { return }
        print("Play button tapped for video: \(videos[indexPath.row].0)")
        // Add logic to play the video here
    }
    
    // MARK: - Prepare for Segue
    
    // This will be called when the segue is performed from HomeViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showVideoPage" {
            if let videoPageVC = segue.destination as? videoPageViewController,
               let selectedItem = sender as? (title: String, image: UIImage) {
                videoPageVC.selectedItem = selectedItem
            }
        }
    }
}
