//
//  ViewController.swift
//  Meme App
//
//  Created by Doren Proctor on 4/15/18.
//  Copyright © 2018 Doren Proctor. All rights reserved.
//

import UIKit

class SingleImageViewController: UIViewController {
    
    @IBOutlet var image: UIImageView!
    @IBOutlet var upvoteButton: UIBarButtonItem!
    @IBOutlet var downvoteButton: UIBarButtonItem!
    var user = "someUsername"
    var likedImage = false
    var dislikedImage = false
    var imageData: UIImage?
    var currentNumber = 0
    @IBAction func commentsButton(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "CommentsViewController", sender: sender)
    }
    
    @IBAction func upvote(_ sender: UIBarButtonItem) {
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
                        print("You upvoted the image")
                        sender.title = "👍"
                        self.dislikedImage = false
                        self.downvoteButton.title = "👎🏻"
                    } else {
                        print("Upvote removed")
                        sender.title = "👍🏻"
                    }
                }
            }
        }
        task.resume()
    }
    @IBAction func downvote(_ sender: UIBarButtonItem) {
        let string = "http://ec2-18-188-44-41.us-east-2.compute.amazonaws.com/downImage/"+user+"/"+String(currentNumber)
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
                        print("You downvoted the image")
                        sender.title = "👎"
                        self.likedImage = false
                        self.upvoteButton.title = "👍🏻"
                    } else {
                        print("downvote removed")
                        sender.title = "👎🏻"
                    }
                }
            }
        }
        task.resume()
    }
    
    func getImageInfo(num: Int) {
        fetchImageInfo(num: num) { (imageInfo) in
            if let imageInfo = imageInfo {
                DispatchQueue.main.async() {
                    if imageInfo.upvoters.contains(self.user) {
                        print("You have upvoted this in the past")
                        self.upvoteButton.title = "👍"
                        self.likedImage = true
                    } else {
                        print("You have not upvoted this before")
                        self.upvoteButton.title = "👍🏻"
                        self.likedImage = false
                    }
                    
                    if imageInfo.downvoters.contains(self.user) {
                        print("You have downvoted this in the past")
                        self.downvoteButton.title = "👎"
                        self.dislikedImage = true
                    } else {
                        print("You have not downvoted this before")
                        self.downvoteButton.title = "👎🏻"
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
    
    
    @IBAction func nextButton(_ sender: UIBarButtonItem) {
        nextImage()
    }
    @IBAction func prevButton(_ sender: UIBarButtonItem) {
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
        }
        if let destinationViewController = segue.destination as? CommentsViewController {
            destinationViewController.currentNumber = self.currentNumber
            destinationViewController.imageData = self.imageData
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        image.image = imageData
        getImageInfo(num: currentNumber)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
