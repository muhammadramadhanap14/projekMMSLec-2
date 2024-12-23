import UIKit

class PsychiatristListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    // Array of tuple untuk menyimpan data psychiatrists dengan format title dan image
    var psychiatrists: [(title: String, image: UIImage)] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set delegate dan dataSource untuk TableView
        tableView.delegate = self
        tableView.dataSource = self
        
        // Load dummy data
        loadDummyData()
        
        // Log untuk memastikan tableView terhubung
        if tableView != nil {
            print("TableView is connected successfully!")
            tableView.reloadData()
        }
    }
    
    func loadDummyData() {
        // Cek nama gambar yang diminta
        if let doctorImage = UIImage(named: "doctor 1") {
            print("doctor1 image loaded successfully!")
        } else {
            print("doctor1 image not found!")
        }
        
        if let psychiatrist1Image = UIImage(named: "psychiatrist 1") {
            print("psychiatrist1 image loaded successfully!")
        } else {
            print("psychiatrist1 image not found!")
        }
        
        if let psychiatrist2Image = UIImage(named: "psychiatrist 2") {
            print("psychiatrist2 image loaded successfully!")
        } else {
            print("psychiatrist2 image not found!")
        }
        
        if let trainerImage = UIImage(named: "personal trainer 1") {
            print("trainer1 image loaded successfully!")
        } else {
            print("trainer1 image not found!")
        }

        // Jika semua gambar berhasil dimuat
        if let doctorImage = UIImage(named: "doctor 1") ?? UIImage(named: "defaultImage"),
           let psychiatrist1Image = UIImage(named: "psychiatrist 1") ?? UIImage(named: "defaultImage"),
           let psychiatrist2Image = UIImage(named: "psychiatrist 2") ?? UIImage(named: "defaultImage"),
           let trainerImage = UIImage(named: "personal trainer 1") ?? UIImage(named: "defaultImage") {
            
            // Array of psychiatrists dengan data title dan image
            psychiatrists = [
                ("Soyaa", doctorImage),
                ("Gilsuit", psychiatrist1Image),
                ("Rosee", psychiatrist2Image),
                ("Khabib", trainerImage)
            ]
            
            print(psychiatrists)
            
            // Log untuk memastikan data sudah terisi
            print("Data loaded: \(psychiatrists)")
            
            // Reload data setelah data dimuat
            tableView.reloadData()
        } else {
            print("One or more images could not be loaded!")
        }
    }

    
    // MARK: - UITableView DataSource
    
    // Menentukan jumlah baris dalam section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Number of rows: \(psychiatrists.count)") // Log jumlah data
        return psychiatrists.count
    }
    
    // Menyediakan data untuk setiap cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue the custom cell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? PsychiatristTableViewCell else {
            return UITableViewCell()
        }
        
        // Ambil data psychiatrist untuk baris ini
        let psychiatrist = psychiatrists[indexPath.row]
        
        // Konfigurasi cell dengan data yang ada
        cell.configure(image: psychiatrist.image, name: psychiatrist.title, type: "Psychiatrist", rating: 4.5)  // Anda bisa mengubah "type" dan "rating" sesuai kebutuhan
        
        return cell
    }
    
    // MARK: - UITableView Delegate
    
    // Ketika baris dipilih
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Dapatkan data dari psychiatrist yang dipilih
        let selectedPsychiatrist = psychiatrists[indexPath.row]
        print("You selected: \(selectedPsychiatrist.title)")  // Log nama yang dipilih
    }
}
