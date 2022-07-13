import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var myButton: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var mySwitch: UISwitch!
        
    var isBlack: Bool = false {
        didSet {
            if isBlack {
                self.view.backgroundColor = .black
            } else {
                self.view.backgroundColor = .white
            }
        }
    }
    
    let queue = DispatchQueue(label: "myQueue", qos: .userInteractive, attributes: .concurrent)
    
    @IBAction func onBut(_ sender: Any) {
        isBlack.toggle()
    }
    
    @IBAction func passGen(_ sender: Any) {
        let len = mySwitch.isOn ? 3 : 2
        
        let pswdChars = String().printable
        let rndPswd = String((0..<len).compactMap{ _ in pswdChars.randomElement() })
        textField.text = rndPswd
        
        queue.async {
            self.bruteForce(passwordToUnlock: rndPswd)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    func setupView() {
        spinner.isHidden = true
        textField.isSecureTextEntry = false
    }
    
    func bruteForce(passwordToUnlock: String) {
        
        DispatchQueue.main.async {
            self.spinner.isHidden = false
            self.spinner.startAnimating()
        }
        
        let ALLOWED_CHARACTERS:   [String] = String().printable.map { String($0) }

        var password: String = ""

        
        while password != passwordToUnlock {
            password = generateBruteForce(password, fromArray: ALLOWED_CHARACTERS)
        }
                
        DispatchQueue.main.async {
            self.spinner.stopAnimating()
            self.spinner.isHidden = true
            self.label.text = password
            self.textField.isSecureTextEntry = true
        }
    }
}
