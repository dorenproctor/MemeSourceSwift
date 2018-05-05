//
//  InitialViewController.swift
//  Meme App
//
//  Created by Doren Proctor on 5/4/18.
//  Copyright © 2018 Doren Proctor. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        performSegue(withIdentifier: "QuadImageViewController", sender: self)
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? QuadImageViewController {
            let defaults = UserDefaults.standard
            if (defaults.string(forKey: "user") != nil) {
                destinationViewController.user = defaults.string(forKey: "user")!
            }
            if (defaults.integer(forKey: "currentNumber") != 0) {
                destinationViewController.currentNumber = defaults.integer(forKey: "currentNumber")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
