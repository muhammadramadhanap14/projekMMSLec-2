import UIKit

class PremiumViewController: UIViewController {

    // Create IBOutlets for all the buttons in your storyboard
    @IBOutlet weak var outlinedButton1: UIButton!
    @IBOutlet weak var outlinedButton2: UIButton!
    @IBOutlet weak var outlinedButton3: UIButton!
    @IBOutlet weak var outlinedButton4: UIButton!

    // Keep track of the currently selected button (which one has the blue circle)
    var selectedButton: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Call the method to style all buttons and set attributed titles
        styleOutlinedButtons()
    }

    // Function to style all buttons as outlined
    func styleOutlinedButtons() {
        // Create an array of all the buttons and titles/subtitles
        let buttonData = [
            (button: outlinedButton1, title: "1 Week", subtitle: "IDR 37.000,00"),
            (button: outlinedButton2, title: "1 Month", subtitle: "IDR 118.000,00"),
            (button: outlinedButton3, title: "6 Month", subtitle: "IDR 567.000,00"),
            (button: outlinedButton4, title: "1 Year", subtitle: "IDR 907.000,00")
        ]
        
        // Loop through each button and its corresponding title/subtitle
        for data in buttonData {
            styleOutlinedButton(data.button)
            setAttributedTitle(for: data.button, title: data.title, subtitle: data.subtitle)
            addOutlinedCircle(to: data.button) // Add outlined circle to the button
        }
    }

    // Function to apply the outlined style to a single button
    func styleOutlinedButton(_ button: UIButton?) {
        guard let button = button else { return }

        // Set the border (outline) color with 50% transparency (alpha = 0.5)
        button.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor  // 50% transparent border
        button.layer.borderWidth = 0.4
        
        // Set the corner radius to make rounded corners
        button.layer.cornerRadius = 15.0
        
        // Set the background color to transparent (no fill)
        button.backgroundColor = .clear
    }

    // Function to create an attributed string with title and subtitle for each button
    func setAttributedTitle(for button: UIButton?, title: String, subtitle: String) {
        guard let button = button else { return }

        // Create a paragraph style with first-line indent
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = 11.0  // Indentation for the first line
        paragraphStyle.lineSpacing = 2.0  // Optional: Add line spacing if needed

        // Title (1 WEEK, etc.) in black and bold
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black, // Color for the title
            .font: UIFont.boldSystemFont(ofSize: 18), // Bold font for the title
            .paragraphStyle: paragraphStyle // Apply the paragraph style with indent
        ]
        
        // Subtitle (IDR 37.000,00, etc.) in custom color using hex (#1BB0E3)
        let subtitleAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(hex: "#1BB0E3"), // Light Blue color using hex
            .font: UIFont.boldSystemFont(ofSize: 18), // Regular font for the subtitle
            .paragraphStyle: paragraphStyle // Apply the paragraph style with indent
        ]
        
        // Create the full text
        let titleString = NSAttributedString(string: title, attributes: titleAttributes)
        let subtitleString = NSAttributedString(string: "\n\(subtitle)", attributes: subtitleAttributes)

        // Combine the title and subtitle
        let fullAttributedString = NSMutableAttributedString()
        fullAttributedString.append(titleString)
        fullAttributedString.append(subtitleString)

        // Set the attributed string to the button
        button.setAttributedTitle(fullAttributedString, for: .normal)
    }

    // Function to add an outlined circle to the right side of the button
    func addOutlinedCircle(to button: UIButton?) {
        guard let button = button else { return }

        // Create a circle view
        let circleView = UIView()
        circleView.layer.cornerRadius = 15.0 // Make the circle
        circleView.layer.borderWidth = 1.5  // Border width
        circleView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor // Transparent border color
        circleView.backgroundColor = .clear // Transparent background
        
        // Set the circle size (e.g., 30x30)
        let circleSize: CGFloat = 30.0
        circleView.frame = CGRect(x: button.frame.width - circleSize - 10, y: (button.frame.height - circleSize) / 2, width: circleSize, height: circleSize)

        // Add the circle to the button
        button.addSubview(circleView)
        
        // Bring the circle to the front to make sure it is visible above the text
        button.bringSubviewToFront(circleView)

        // Add a target to handle the button's tap
        button.addTarget(self, action: #selector(toggleCircleColor(sender:)), for: .touchUpInside)

        // Store the circle view in the button's associated object to update it later
        objc_setAssociatedObject(button, &AssociatedKeys.circleView, circleView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }

    // MARK: - Toggle Circle Color on Button Tap
    @objc func toggleCircleColor(sender: UIButton) {
        // Get the circle view associated with the button
        if let circleView = objc_getAssociatedObject(sender, &AssociatedKeys.circleView) as? UIView {
            
            // If this button was previously selected, make its circle transparent
            if let previouslySelectedButton = selectedButton {
                if previouslySelectedButton != sender {
                    // Get the previously selected circle view and make it transparent
                    if let prevCircleView = objc_getAssociatedObject(previouslySelectedButton, &AssociatedKeys.circleView) as? UIView {
                        prevCircleView.backgroundColor = .clear
                    }
                }
            }
            
            // Toggle the circle color for the selected button
            if circleView.backgroundColor == .clear {
                circleView.backgroundColor = UIColor(hex: "#1BB0E3") // Blue color
            } else {
                circleView.backgroundColor = .clear // Transparent background
            }
            
            // Update the selected button reference
            selectedButton = sender

            // Show the alert for the payment successful message
            showPaymentSuccessAlert(for: sender)
        }
    }

    // Function to show the payment successful alert
    func showPaymentSuccessAlert(for button: UIButton) {
        // Determine the title based on the button pressed
        var title: String
        var message: String

        if button == outlinedButton1 {
            title = "Payment Successful"
            message = "You've successfully paid for 1 Week plan (IDR 37.000,00)."
        } else if button == outlinedButton2 {
            title = "Payment Successful"
            message = "You've successfully paid for 1 Month plan (IDR 118.000,00)."
        } else if button == outlinedButton3 {
            title = "Payment Successful"
            message = "You've successfully paid for 6 Month plan (IDR 567.000,00)."
        } else {
            title = "Payment Successful"
            message = "You've successfully paid for 1 Year plan (IDR 907.000,00)."
        }

        // Create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Add an OK button to dismiss the alert
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        // Present the alert
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - Associated Object Keys
private struct AssociatedKeys {
    static var circleView = "circleViewKey"
}

// MARK: - UIColor Extension to Handle Hex Colors
extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
