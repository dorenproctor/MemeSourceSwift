//
//  SignInViewController.swift
//  Meme App
//
//  Created by Doren Proctor on 5/4/18.
//  Copyright © 2018 Doren Proctor. All rights reserved.
//

import UIKit


struct AccountCreationInfo: Codable {
    var username: String
    var password: String
    var passwordConf: String
    var email: String
}

class SignInViewController: UIViewController {
    @IBOutlet var usernameBox: UITextField!
    @IBOutlet var passwordBox: UITextField!
    
    var currentNumber = 0
    var imageData: UIImage?
    var user = ""
    
    var userChanged = false
    
    @IBAction func signIn(_ sender: Any) {
        if (usernameBox.text == nil || usernameBox.text!.isEmpty || passwordBox.text == nil || passwordBox.text!.isEmpty){
            return
        }
        do {
            let string = "http://ec2-18-188-44-41.us-east-2.compute.amazonaws.com/signIn/" + String(usernameBox.text!) + "/" + String(passwordBox.text!)
            let url = URL(string: string)
            let data = try Data(contentsOf: url!)
            let utf8Representation = String(data: data, encoding: .utf8)
            if (utf8Representation?.range(of:"\"statusCode\":200") != nil) {
                self.user = usernameBox.text!
                performSegue(withIdentifier: "SingleImageViewController", sender: sender)
            } else if (utf8Representation?.range(of:"Didn't find user") != nil) {
                let alert = UIAlertController(title: "Username does not exist", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "Primary action"), style: .`default`, handler: { _ in
                }))
                self.present(alert, animated: true, completion: nil)
            } else if (utf8Representation?.range(of:"Password doesn't match") != nil) {
                let alert = UIAlertController(title: "Wrong password", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "Primary action"), style: .`default`, handler: { _ in
                }))
                self.present(alert, animated: true, completion: nil)
            }
        } catch {
            print(error)
        }
    }
    
    @IBAction func createAccount(_ sender: Any) {
        if (usernameBox.text == nil || usernameBox.text!.isEmpty || passwordBox.text == nil || passwordBox.text!.isEmpty){
            return
        }
        let accountInfo = AccountCreationInfo(username: usernameBox.text!, password: passwordBox.text!, passwordConf: passwordBox.text!, email: "N/A")
        accountCreation(accountInfo: accountInfo)  { (error) in
            if let error = error {
                print(error)
            }
        }
    }
    
    
    func accountCreation(accountInfo: AccountCreationInfo, completion:((Error?) -> Void)?) {
        let string = "http://ec2-18-188-44-41.us-east-2.compute.amazonaws.com/createUser"
        let url = URL(string: string)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        var headers = request.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        request.allHTTPHeaderFields = headers
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(accountInfo)
            request.httpBody = jsonData
                        print("jsonData: ", String(data: request.httpBody!, encoding: .utf8) ?? "no body data")
        } catch {
            completion?(error)
        }
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if let data = data, let utf8Representation = String(data: data, encoding: .utf8) {
                if (utf8Representation.range(of:"\"statusCode\":200") != nil) {
                    DispatchQueue.main.async() {
                        print("Created account")
                        self.user = self.usernameBox.text!
                        self.performSegue(withIdentifier: "SingleImageViewController", sender: self)
                    }
                }
                else {
                    print(utf8Representation)
                    let alert = UIAlertController(title: "Failed to create account", message: "utf8Representation", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "Primary action"), style: .`default`, handler: { _ in
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
                
            } else {
                print("no readable data received in response")
            }
        }
        task.resume()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? SingleImageViewController {
            destinationViewController.currentNumber = self.currentNumber
            destinationViewController.imageData = self.imageData
            destinationViewController.user = self.user
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let defaults = UserDefaults.standard
        defaults.set(user, forKey: "user")
        defaults.set(currentNumber, forKey: "currentNumber")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
