//
//  GameScene.swift
//  What Should We Name It
//
//  Created by Bryan Heath on 10/2/17.
//  Copyright © 2017 Swift. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

// Starts an enum for different types of collisions (In Progress)
enum CollisionTypes: UInt32 {
    case player = 1
    case spike = 8
    case finish = 0
}

//Class declares the different types of sprites along with the tilt controls for the game scene
class GameScene: SKScene, SKPhysicsContactDelegate {
    var player: SKSpriteNode!
    var finish: SKSpriteNode!
    var spike: SKSpriteNode!
    var back: SKSpriteNode!
    var lastTouchPosition: CGPoint?
    
    var motionManager: CMMotionManager!
    
    var isGameOver = false
    
    //This loads the gravity function for the tilt control
    //It aslso calls the functions needed to load the level like the sprites
    override func didMove(to view: SKView) {
        
 
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        // loadLevel()
        createPlayer()
        createFinish()
        createSpike()
        createBackground()
        
        motionManager = CMMotionManager()
        motionManager.startAccelerometerUpdates()
    }
    
    //This function creates the background
    func createBackground() {
        back = SKSpriteNode(imageNamed: "background")
        back.position = CGPoint(x:0, y:0)
        back.zPosition = -1
        addChild(back)
        
    }
    
    //This function creates the player
    func createPlayer() {
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: -350, y: -650)
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
        player.zPosition = 1
        player.physicsBody?.allowsRotation = false
        addChild(player)
    }
    
    //This function creates the finish line
    func createFinish() {
        finish = SKSpriteNode(imageNamed: "Check")
        finish.position = CGPoint(x: 315, y: 635)
        addChild(finish)
    }
    
    //This function creates one of the spikes
    func createSpike() {
        spike = SKSpriteNode(imageNamed: "Spike top")
        spike.position = CGPoint(x: 340, y: 590)
        spike.physicsBody = SKPhysicsBody(rectangleOf: spike.size)
        spike.physicsBody?.isDynamic = false
        spike.zPosition = 1
        addChild(spike)
    }
    
    //These next 4 functions are used for the testing on the computer since
    //tilt control cannot be tested on a computer. It uses touch as the direction you are tilting.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            lastTouchPosition = location
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            lastTouchPosition = location
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchPosition = nil
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchPosition = nil
    }
    
    //This function is for the use of tilt control and it updating in real time
    //First prart of the if is for testing on a computer then the else is for testing on an
    //ios device.
    override func update(_ currentTime: TimeInterval) {
        guard isGameOver == false else { return }
        #if (arch(i386) || arch(x86_64))
            if let currentTouch = lastTouchPosition {
                let diff = CGPoint(x: currentTouch.x - player.position.x, y: currentTouch.y - player.position.y)
                physicsWorld.gravity = CGVector(dx: diff.x / 100, dy: diff.y / 100)
            }
        #else
            if let accelerometerData = motionManager.accelerometerData {
                physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.x * 20, dy: accelerometerData.acceleration.y * 20)
            }
        #endif
    }
    
    
}
