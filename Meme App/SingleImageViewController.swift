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
    var imageData: UIImage?
    var currentNumber = 0
    
    func getImage(image: UIImageView, num: Int) {
        do {
            let string = "https://dorenproctor.000webhostapp.com/memes/"+String(num)+".jpg"
            let url = URL(string: string)
            let data = try Data(contentsOf: url!)
            image.image = UIImage(data: data)
        } catch {
            print("image ",String(num),": ",error)
        }
    }
    
    @IBAction func nextButton(_ sender: UIButton) {
        nextImage()
        print("a")
    }
    @IBAction func prevButton(_ sender: UIButton) {
        prevImage()
        print("b")
    }
    
    @objc func nextImage() {
        self.currentNumber += 1
        let n = self.currentNumber
        getImage(image: image, num: n)
    }
    
    @objc func prevImage() {
        if self.currentNumber > 0 {
            self.currentNumber -= 1
        }
        let n = self.currentNumber
        getImage(image: image, num: n)
    }
    
    @IBAction func returnButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: "QuadImageViewController", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? QuadImageViewController {
            destinationViewController.currentNumber = self.currentNumber
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        image.image = imageData
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


