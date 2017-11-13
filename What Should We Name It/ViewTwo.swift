//
//  ViewTwo.swift
//  What Should We Name It
//
//  Created by Bryan Heath on 11/6/17.
//  Copyright © 2017 Swift. All rights reserved.
//

import UIKit
import GameplayKit

class ViewTwo: UIViewController {
    @IBOutlet weak var start: UIButton!
    @IBOutlet weak var deathlab: UILabel!
    @IBOutlet weak var levelLab: UILabel!
    @IBOutlet weak var image: UIImageView!
    var death = save.integer(forKey: "death")
    var level = save.integer(forKey: "level")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deathlab.text = "Deaths: \(death)"
        levelLab.text = "Level: \(level)"
        self.view.sendSubview(toBack: image)
    }
}
