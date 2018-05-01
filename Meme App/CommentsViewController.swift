//
//  ViewController.swift
//  Meme App
//
//  Created by Doren Proctor on 4/15/18.
//  Copyright © 2018 Doren Proctor. All rights reserved.
//

import UIKit

struct CommentPostInfo: Codable {
    var imageId: Int
    var content: String
    var user: String
}

class CommentsViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    var currentNumber = 0
    var imageData: UIImage?
    var user = "someUsername"
    
    @IBAction func sendComment(_ sender: Any) {
        if (textField.text == nil || textField.text!.isEmpty){
            return
        }
        print(textField.text!)
        let post = CommentPostInfo(imageId: currentNumber, content: textField.text!, user: user)
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
            print("jsonData: ", String(data: request.httpBody!, encoding: .utf8) ?? "no body data")
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
                print("response: ", utf8Representation)
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
//                print(data)
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
            destinationViewController.imageData = self.imageData
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(currentNumber)
        getCommentInfo(num: currentNumber) { (commentInfo) in
            if let commentInfo = commentInfo {
                print(commentInfo)
                print("~~~~~")
                for comment in commentInfo {
                    print(comment.content)
                }
            } else {
                print("error")
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}



