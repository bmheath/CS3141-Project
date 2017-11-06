//
//  ViewOne.swift
//  What Should We Name It
//
//  Created by Bryan Heath on 11/6/17.
//  Copyright © 2017 Swift. All rights reserved.
//

import UIKit

class ViewOne: UIViewController {
    @IBOutlet weak var new: UIButton!
    @IBOutlet weak var con: UIButton!
    @IBAction func New(_ sender: Any) {
        save.set(save.integer(forKey: "death"), forKey: "olddeath")
        save.set(save.integer(forKey: "level"), forKey: "oldlevel")
        save.set(0, forKey: "death")
        save.set(1, forKey: "level")
    }
    @IBAction func Con(_ sender: Any) {
        save.set(save.integer(forKey: "olddeath"), forKey: "death")
        save.set(save.integer(forKey: "oldlevel"), forKey: "level")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
