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
    var deathLabel: SKLabelNode!
    var levelLabel: SKLabelNode!
    var death = save.integer(forKey: "death")
    var level = save.integer(forKey: "level")
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deathLabel = SKLabelNode(fontNamed: "Papyrus")
        deathLabel.text = "Deaths: \(death)"
        deathLabel.horizontalAlignmentMode = .center
        deathLabel.position = CGPoint(x: 0, y: 50)
        print(deathLabel)
        
        levelLabel = SKLabelNode(fontNamed: "Papyrus")
        levelLabel.text = "Level: \(level)"
        levelLabel.horizontalAlignmentMode = .center
        levelLabel.position = CGPoint(x: 0, y: 100)
        print(levelLabel)
        
    }
}
