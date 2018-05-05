//
//  ViewController.swift
//  Meme App
//
//  Created by Doren Proctor on 4/15/18.
//  Copyright © 2018 Doren Proctor. All rights reserved.
//

import UIKit

class SingleImageViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet var image: UIImageView!
    @IBOutlet var upvoteButton: UIButton!
    @IBOutlet var downvoteButton: UIButton!
    @IBOutlet var signInButton: UIBarButtonItem!
    
    var currentNumber = 0
    var imageData: UIImage?
    var imageInfo: ImageInfo?
    var user = ""
    
    var likedImage = false
    var dislikedImage = false
    @IBAction func commentsButton(_ sender: UIButton) {
        performSegue(withIdentifier: "CommentsViewController", sender: sender)
    }
    
    @IBAction func upvote(_ sender: UIButton) {
        if (user.isEmpty) {
            let alert = UIAlertController(title: "You must be signed in to vote", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "Primary action"), style: .`default`, handler: { _ in
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        let string = "http://ec2-18-188-44-41.us-east-2.compute.amazonaws.com/upvoteImage/"+user+"/"+String(currentNumber)
        let url = URL(string: string)!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            if (error != nil) {
                print("error: ",error!)
            } else {
                DispatchQueue.main.async() {
                    self.likedImage = !self.likedImage
                    if (self.likedImage) {
                        self.upvoteButton.setTitle("👍", for: .normal)
                        self.downvoteButton.setTitle("👎🏻", for: .normal)
                        self.imageInfo?.upvotes += 1
                        if (self.dislikedImage) {
                            self.imageInfo?.downvotes -= 1
                            self.dislikedImage = false
                        }
                    } else {
                        self.upvoteButton.setTitle("👍🏻", for: .normal)
                        self.imageInfo?.upvotes -= 1
                    }
                }
            }
        }
        task.resume()
    }
    @IBAction func downvote(_ sender: UIButton) {
        if (user.isEmpty) {
            let alert = UIAlertController(title: "You must be signed in to vote", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "Primary action"), style: .`default`, handler: { _ in
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        let string = "http://ec2-18-188-44-41.us-east-2.compute.amazonaws.com/downvoteImage/"+user+"/"+String(currentNumber)
        let url = URL(string: string)!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            if (error != nil) {
                print("error: ",error!)
            } else {
                DispatchQueue.main.async() {
                    self.dislikedImage = !self.dislikedImage
                    if (self.dislikedImage) {
                        self.downvoteButton.setTitle("👎", for: .normal)
                        self.upvoteButton.setTitle("👍🏻", for: .normal)
                        self.imageInfo?.downvotes += 1
                        if (self.likedImage) {
                            self.imageInfo?.upvotes -= 1
                            self.likedImage = false
                        }
                    } else {
                        self.downvoteButton.setTitle("👎🏻", for: .normal)
                        self.imageInfo?.downvotes -= 1
                    }
                }
            }
        }
        task.resume()
    }
    
    func getImageInfo(num: Int) {
        fetchImageInfo(num: num) { (imageInfo) in
            if let imageInfo = imageInfo {
                self.imageInfo = imageInfo
                DispatchQueue.main.async() {
                    if imageInfo.upvoters.contains(self.user) {
                        self.upvoteButton.setTitle("👍", for: .normal)
                        self.likedImage = true
                    } else {
                        self.upvoteButton.setTitle("👍🏻", for: .normal)
                        self.likedImage = false
                    }
                    
                    if imageInfo.downvoters.contains(self.user) {
                        self.downvoteButton.setTitle("👎", for: .normal)
                        self.dislikedImage = true
                    } else {
                        self.downvoteButton.setTitle("👎🏻", for: .normal)
                        self.dislikedImage = false
                    }
                }
            }
        }
    }
    
    
    func fetchImageInfo(num: Int, completion: @escaping (ImageInfo?) -> Void) {
        let string = "http://ec2-18-188-44-41.us-east-2.compute.amazonaws.com/imageInfo/"+String(num)
        let url = URL(string: string)!
        let task = URLSession.shared.dataTask(with: url) { (data,
            response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data {
                if let imageInfo = try?
                    jsonDecoder.decode(ImageInfo.self, from: data) {
                    completion(imageInfo)
                } else {
                    let alert = UIAlertController(title: "Data was not serialized.", message: String(data: data, encoding: .utf8), preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .`default`, handler: { _ in
                    }))
                    UIApplication.shared.windows[0].rootViewController?.present(alert, animated: true, completion: nil)
                    completion(nil)
                }
            } else {
                print("No data was returned.")
                let alert = UIAlertController(title: "No data was returned.", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .`default`, handler: { _ in
                }))
                UIApplication.shared.windows[0].rootViewController?.present(alert, animated: true, completion: nil)
                completion(nil)
            }
        }
        task.resume()
    }
    
    
    func getImage(image: UIImageView, num: Int) {
        do {
            let string = "http://ec2-18-188-44-41.us-east-2.compute.amazonaws.com/getImage/"+String(num)
            let url = URL(string: string)
            let data = try Data(contentsOf: url!)
            image.image = UIImage(data: data)
        } catch {
            print("image ",String(num),": ",error)
            image.image = nil
        }
    }
    
    
    @IBAction func nextButton(_ sender: UIButton) {
        nextImage()
    }
    @IBAction func prevButton(_ sender: UIButton) {
        prevImage()
    }
    
    @objc func nextImage() {
        self.currentNumber += 1
        getImageInfo(num: self.currentNumber)
        getImage(image: image, num: self.currentNumber)
    }
    
    @objc func prevImage() {
        if self.currentNumber > 0 {
            self.currentNumber -= 1
        }
        getImageInfo(num: self.currentNumber)
        getImage(image: image, num: self.currentNumber)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? QuadImageViewController {
            destinationViewController.currentNumber = self.currentNumber
            destinationViewController.user = self.user
        }
        if let destinationViewController = segue.destination as? CommentsViewController {
            destinationViewController.currentNumber = self.currentNumber
            destinationViewController.imageInfo = self.imageInfo
            destinationViewController.imageData = self.imageData
            destinationViewController.user = self.user
        }
        if let destinationViewController = segue.destination as? SignInViewController {
            destinationViewController.currentNumber = self.currentNumber
            destinationViewController.imageInfo = self.imageInfo
            destinationViewController.imageData = self.imageData
            destinationViewController.user = self.user
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        image.image = imageData
        getImageInfo(num: currentNumber)
        if (!user.isEmpty) {
            signInButton.title = user
        }
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(nextImage))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(prevImage))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        // Do any additional setup after loading the view, typically from a nib.
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
}
