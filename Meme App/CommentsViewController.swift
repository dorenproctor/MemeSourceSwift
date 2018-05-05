//
//  ViewController.swift
//  Meme App
//
//  Created by Doren Proctor on 4/15/18.
//  Copyright © 2018 Doren Proctor. All rights reserved.
//

import UIKit

struct CommentPostInfo: Codable {
    var imageId: String
    var content: String
    var user: String
}

class CommentsViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet var commentBox: UITextView!
    
    var currentNumber = 0
    var imageData: UIImage?
    var imageInfo: ImageInfo?
    var user = ""
    
    @IBAction func sendComment(_ sender: Any) {
        if (textField.text == nil || textField.text!.isEmpty){
            return
        }
        if (user.isEmpty) {
            let alert = UIAlertController(title: "You must be signed in to comment", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "Primary action"), style: .`default`, handler: { _ in
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        let post = CommentPostInfo(imageId: String(currentNumber), content: textField.text!, user: user)
        postComment(post: post) { (error) in
            if let error = error {
                print(error)
            }
        }
    }
    
    
    func postComment(post: CommentPostInfo, completion:((Error?) -> Void)?) {
        let string = "http://ec2-18-188-44-41.us-east-2.compute.amazonaws.com/postComment"
        let url = URL(string: string)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        var headers = request.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        request.allHTTPHeaderFields = headers
        
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(post)
            request.httpBody = jsonData
//            print("jsonData: ", String(data: request.httpBody!, encoding: .utf8) ?? "no body data")
        } catch {
            completion?(error)
        }
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { (data, response, error) in
//            guard error == nil else {
//                completion?(error!)
//                return
//            }
            
            if let data = data, let utf8Representation = String(data: data, encoding: .utf8) {
                if (utf8Representation.range(of:"\"statusCode\":200") != nil) {
                    DispatchQueue.main.async() {
                        let string = self.user + ":  " + post.content + "\n\n\n"
                        self.commentBox.text = self.commentBox.text + string
                    }
                }
                else {
                    print(utf8Representation)
                }
                
            } else {
                print("no readable data received in response")
            }
        }
        task.resume()
    }
    
    func getCommentInfo(num: Int, completion: @escaping (Array<CommentInfo>?) -> Void) {
        let string = "http://ec2-18-188-44-41.us-east-2.compute.amazonaws.com/commentInfo/"+String(num)
        let url = URL(string: string)!
        let task = URLSession.shared.dataTask(with: url) { (data,
            response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data {
                if let commentInfo = try?
                    jsonDecoder.decode(Array<CommentInfo>.self, from: data) {
                    completion(commentInfo)
                } else {
                    print("Data was not serialized")
                }
            } else {
                print("No data was returned.")
            }
        }
        task.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? SingleImageViewController {
            destinationViewController.currentNumber = self.currentNumber
            destinationViewController.imageInfo = self.imageInfo
            destinationViewController.imageData = self.imageData
            destinationViewController.user = self.user
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let imageInfo = self.imageInfo {
            let votesString = "upvotes: " + String(describing: imageInfo.upvotes) + "  downvotes: " + String(describing: imageInfo.downvotes) + "\n\n\n"
            self.commentBox.text = self.commentBox.text + votesString
        }
        getCommentInfo(num: currentNumber) { (commentInfo) in
            if let commentInfo = commentInfo {
                DispatchQueue.main.async() {
                    for comment in commentInfo {
                        let string = comment.user + ":\n" + comment.content + "\n\n\n"
                        self.commentBox.text = self.commentBox.text + string
                    }
                }
            } else {
                print("error")
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let defaults = UserDefaults.standard
        defaults.set(user, forKey: "user")
        defaults.set(currentNumber, forKey: "currentNumber")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}



