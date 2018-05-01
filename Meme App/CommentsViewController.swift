//
//  ViewController.swift
//  Meme App
//
//  Created by Doren Proctor on 4/15/18.
//  Copyright © 2018 Doren Proctor. All rights reserved.
//

import UIKit

class CommentsViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    var currentNumber = 0
    
    @IBAction func sendComment(_ sender: Any) {
        print(textField.text)
    }
    var imageData: UIImage?
    
    
    func getCommentInfo(num: Int, completion: @escaping (Array<CommentInfo>?) -> Void) {
        let string = "http://ec2-18-188-44-41.us-east-2.compute.amazonaws.com/commentInfo/"+String(num)
        let url = URL(string: string)!
        let task = URLSession.shared.dataTask(with: url) { (data,
            response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data {
                print(data)
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



