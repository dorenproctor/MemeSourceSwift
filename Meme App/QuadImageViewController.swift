//
//  ViewController.swift
//  Meme App
//
//  Created by Doren Proctor on 4/15/18.
//  Copyright © 2018 Doren Proctor. All rights reserved.
//

import UIKit

class QuadImageViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet var image1: UIImageView!
    @IBOutlet var image2: UIImageView!
    @IBOutlet var image3: UIImageView!
    @IBOutlet var image4: UIImageView!
    @IBOutlet var images: [UIImageView]!
    
    var currentNumber = 1
    var currentImage: UIImage?
    
    func getImage(image: UIImageView, num: Int) {
        do {
            let string = "https://dorenproctor.000webhostapp.com/memes/"+String(num)+".jpg"
            let url = URL(string: string)
            let data = try Data(contentsOf: url!)
            image.image = UIImage(data: data)
        } catch {
            print("image ",String(num),": ",error)
            image.image = nil
        }
    }
    
    @IBAction func nextButton(_ sender: UIButton) {
        nextImages()
        print("a")
    }
    @IBAction func prevButton(_ sender: UIButton) {
        prevImages()
        print("b")
    }
    
    @objc func nextImages() {
        self.currentNumber += 4
        let n = self.currentNumber
        getImage(image: image1, num: n)
        getImage(image: image2, num: n+1)
        getImage(image: image3, num: n+2)
        getImage(image: image4, num: n+3)
    }
    
    @objc func prevImages() {
        if self.currentNumber > 4 {
            self.currentNumber -= 4
        } else {
            self.currentNumber = 0
        }
        let n = self.currentNumber
        getImage(image: image1, num: n)
        getImage(image: image2, num: n+1)
        getImage(image: image3, num: n+2)
        getImage(image: image4, num: n+3)
    }
    
    func addGestures(image: UIImageView) {
        let tapSelector : Selector = #selector(QuadImageViewController.Tap)
        let tapGesture = UITapGestureRecognizer(target: self, action: tapSelector)
        image.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func Tap(_ sender: UITapGestureRecognizer) {
        let image = sender.view as? UIImageView
        self.currentImage = image?.image
        self.currentNumber += (image?.tag)!-1
        performSegue(withIdentifier: "SingleImageViewController", sender: sender)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGestures(image: image1)
        addGestures(image: image2)
        addGestures(image: image3)
        addGestures(image: image4)
        let n = self.currentNumber
        getImage(image: image1, num: n)
        getImage(image: image2, num: n+1)
        getImage(image: image3, num: n+2)
        getImage(image: image4, num: n+3)
        
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(nextImages))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(prevImages))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? SingleImageViewController {
            destinationViewController.imageData = self.currentImage
            if self.currentNumber > 1 {
                destinationViewController.currentNumber = self.currentNumber - 1
            } else {
                destinationViewController.currentNumber = self.currentNumber
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

