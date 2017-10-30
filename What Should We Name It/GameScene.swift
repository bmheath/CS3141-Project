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

var playerX = 0;
var playerY = 0;

// Starts an enum for different types of collisions (In Progress)
enum CollisionTypes: UInt32 {
    case player = 1
    case SKSpriteNode_1 = 2
    case wall = 3
    case spike = 8
    case hole = 9
    case finish = 0
    
}

//Class declares the different types of sprites along with the tilt controls for the game scene
class GameScene: SKScene, SKPhysicsContactDelegate {
    var player: SKSpriteNode!
    var finish: SKSpriteNode!
    var spike: SKSpriteNode!
    var back: SKSpriteNode!
    var lastTouchPosition: CGPoint?
    var scoreLabel: SKLabelNode!
    var levelLabel: SKLabelNode!
    var hole: SKSpriteNode!
    var c1: SKSpriteNode!
    var c2: SKSpriteNode!
    var c3: SKSpriteNode!
    var block: SKSpriteNode!
    
    var SKSpriteNode_1 = SKSpriteNode()
    var SKSpriteNode_2 = SKSpriteNode()
    var SKSpriteNode_3 = SKSpriteNode()
    var SKSpriteNode_4 = SKSpriteNode()
    
    var motionManager: CMMotionManager!
    
    
    var isGameOver = false
    
    //Creates scoreboard
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var level = 1 {
        didSet {
            levelLabel.text = "Level: \(level)"
        }
    }
    
    
    //This loads the gravity function for the tilt control
    //It aslso calls the functions needed to load the level like the sprites
    override func didMove(to view: SKView) {
        
        SKSpriteNode_1 = self.childNode(withName: "SKSpriteNode_1") as! SKSpriteNode
        SKSpriteNode_2 = self.childNode(withName: "SKSpriteNode_2") as! SKSpriteNode
        SKSpriteNode_3 = self.childNode(withName: "SKSpriteNode_3") as! SKSpriteNode
        SKSpriteNode_4 = self.childNode(withName: "SKSpriteNode_4") as! SKSpriteNode
        
        scoreLabel = SKLabelNode(fontNamed: "Papyrus")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: -360, y: 640)
        scoreLabel.zPosition=100
        addChild(scoreLabel)
        
        levelLabel = SKLabelNode(fontNamed: "Papyrus")
        levelLabel.text = "Level: 1"
        levelLabel.horizontalAlignmentMode = .center
        levelLabel.position = CGPoint(x: 0, y: 640)
        levelLabel.zPosition = 100
        addChild(levelLabel)
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        // Set the file path
        
        
        buildLevel(level: "level2")

        // loadLevel()
//         createPlayer()
//        createFinish()
//        createSpike()
//        createHole()
        createBackground()
        

    
        
        motionManager = CMMotionManager()
        motionManager.startAccelerometerUpdates()
    }
    
    func buildLevel(level: String) {
        let levelPath = Bundle.main.path(forResource: level, ofType: "txt")
        let levelString = try? String(contentsOfFile: levelPath!)
        let lines = levelString?.components(separatedBy: "\n")
      
                // x -> 680
                // y -> 1280
        
        var y = 640

        for line in lines! {
            var x = -340
            for c in line{
                 switch c {
                    
                case "x":
                    createObstacle(x: x, y: y)
                    
                case "o":
                    createHole(x: x, y: y)
                    
                 case "l":
                    createLSpike(x: x - 27, y: y)
                    
                 case "r":
                    createRSpike(x: x + 27, y: y)
                    
                 case "t":
                    createTSpike(x: x, y: y + 26)
                    
                 case "b":
                    createBSpike(x: x, y: y - 28)
                    
                 case "f":
                    createFinish(x: x, y: y)
                    
                 case "p":
                    playerX = x
                    playerY = y
                    createPlayer(x: x, y: y)
                    
                case " ":
                    print("_", terminator: "")
                    
                case "n":
                    print("newline")
                    break
                    
                default:
                    print("done")
                }
                x += 75
            }
            y -= 75;
        }
    }
    
    //This function creates the background
    func createBackground() {
        back = SKSpriteNode(imageNamed: "background")
        back.position = CGPoint(x:0, y:0)
        back.zPosition = -2
        addChild(back)
        
    }
    
    //This function creates the player
    func createPlayer(x: Int  ,y: Int) {
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: x, y: y)
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
        player.zPosition = 1
        player.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        //player.physicsBody?.contactTestBitMask = CollisionTypes.spike.rawValue
        player.physicsBody?.collisionBitMask = CollisionTypes.SKSpriteNode_1.rawValue
        player.physicsBody?.collisionBitMask = CollisionTypes.spike.rawValue
        player.physicsBody?.allowsRotation = false
        addChild(player)
    }
    
    //This function creates the finish line
    func createFinish(x: Int  ,y: Int) {
        finish = SKSpriteNode(imageNamed: "Check")
        finish.position = CGPoint(x: x, y: y)
        finish.name = "Check"
        finish.physicsBody = SKPhysicsBody(rectangleOf: finish.size)
        finish.physicsBody?.isDynamic = false
        finish.physicsBody?.categoryBitMask = CollisionTypes.spike.rawValue
        finish.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        finish.physicsBody?.collisionBitMask = 0
        finish.zPosition = 1
        addChild(finish)
    }
    
    //This function creates one of the spikes
    func createTSpike(x: Int  ,y: Int) {
        spike = SKSpriteNode(imageNamed: "Spike top")
        spike.position = CGPoint(x: x, y: y)
        spike.name = "Spike"
        spike.physicsBody = SKPhysicsBody(rectangleOf: spike.size)
        spike.physicsBody?.isDynamic = false
        spike.physicsBody?.categoryBitMask = CollisionTypes.spike.rawValue
        spike.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        spike.physicsBody?.collisionBitMask = 0
        spike.zPosition = 1
        addChild(spike)
    }
    
    func createLSpike(x: Int  ,y: Int) {
        spike = SKSpriteNode(imageNamed: "Spike left")
        spike.position = CGPoint(x: x, y: y)
        spike.name = "Spike"
        spike.physicsBody = SKPhysicsBody(rectangleOf: spike.size)
        spike.physicsBody?.isDynamic = false
        spike.physicsBody?.categoryBitMask = CollisionTypes.spike.rawValue
        spike.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        spike.physicsBody?.collisionBitMask = 0
        spike.zPosition = 1
        addChild(spike)
    }
    
    func createRSpike(x: Int  ,y: Int) {
        spike = SKSpriteNode(imageNamed: "Spike right")
        spike.position = CGPoint(x: x, y: y)
        spike.name = "Spike"
        spike.physicsBody = SKPhysicsBody(rectangleOf: spike.size)
        spike.physicsBody?.isDynamic = false
        spike.physicsBody?.categoryBitMask = CollisionTypes.spike.rawValue
        spike.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        spike.physicsBody?.collisionBitMask = 0
        spike.zPosition = 1
        addChild(spike)
    }
    
    func createBSpike(x: Int  ,y: Int) {
        spike = SKSpriteNode(imageNamed: "Spike bottom")
        spike.position = CGPoint(x: x, y: y)
        spike.name = "Spike"
        spike.physicsBody = SKPhysicsBody(rectangleOf: spike.size)
        spike.physicsBody?.isDynamic = false
        spike.physicsBody?.categoryBitMask = CollisionTypes.spike.rawValue
        spike.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        spike.physicsBody?.collisionBitMask = 0
        spike.zPosition = 1
        addChild(spike)
    }
    
    func createObstacle (x: Int  ,y: Int){
        
        block = SKSpriteNode(imageNamed: "block")
        block.physicsBody = SKPhysicsBody(rectangleOf: block.size)
        block.physicsBody?.categoryBitMask = CollisionTypes.wall.rawValue
        block.position = CGPoint(x: x, y: y)
        block.physicsBody?.isDynamic = false
        block.physicsBody?.categoryBitMask = CollisionTypes.spike.rawValue
        block.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        block.physicsBody?.collisionBitMask = 0
        
        block.zPosition=1
        addChild(block)
        
    }
    
    
    //This function creates a hole
    func createHole(x: Int  ,y: Int) {
        hole = SKSpriteNode(imageNamed: "hole")
        hole.position = CGPoint(x: x, y: y)
        hole.name = "Hole"
        hole.physicsBody = SKPhysicsBody(rectangleOf: hole.size)
        hole.physicsBody?.isDynamic = false
        hole.physicsBody?.categoryBitMask = CollisionTypes.hole.rawValue
        hole.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        hole.physicsBody?.collisionBitMask = 0
        hole.zPosition = -1
        addChild(hole)
    }
    
    //Tells if things touch eachother
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node == player {
            playerCollided(with: contact.bodyB.node!)
        } else if contact.bodyB.node == player {
            playerCollided(with: contact.bodyA.node!)
        }
    }
    
    //what happens when things collide
    func playerCollided(with node: SKNode) {
        if node.name == "Spike" {
            score -= 1
            let position = player.position
            let scale = SKAction.scale(to: 1, duration: 0.25)
            let scale2 = SKAction.scale(to: 1, duration: 0.5)
            player.removeFromParent()
            c1 = SKSpriteNode(imageNamed: "crack1")
            c1.position = position
            c1.zPosition = 3
            addChild(c1)
            c1.run(scale) { [unowned self] in
                self.c1.removeFromParent()
                self.c2 = SKSpriteNode(imageNamed: "crack2")
                self.c2.position = position
                self.c2.zPosition = 4
                self.addChild(self.c2)
                self.c2.run(scale) { [unowned self] in
                    self.c2.removeFromParent()
                    self.c3 = SKSpriteNode(imageNamed: "crack3")
                    self.c3.position = position
                    self.c3.zPosition = 5
                    self.addChild(self.c3)
                    self.c3.run(scale2) { [unowned self] in
                        self.c3.removeFromParent()
                        self.createPlayer(x: playerX,y: playerY)
                    }
                }
            }
            
            
            
            
        } else if node.name == "Hole" {
            player.physicsBody?.isDynamic = false
            let move = SKAction.move(to: node.position, duration: 0.25)
            let scale = SKAction.scale(to: 0.000001, duration: 0.5)
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([move, scale, remove])
            player.run(sequence) { [unowned self] in
                self.score -= 1
            self.createPlayer(x: -340,y: 640)
            }
        } else if node.name == "Check" {
            player.physicsBody?.isDynamic = false
            let move = SKAction.move(to: node.position, duration: 0.25)
            let scale = SKAction.scale(to: 0.000001, duration: 0.5)
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([move, scale, remove])
            player.run(sequence) {[unowned self] in
                self.score += 1
                self.level += 1
                self.removeAllChildren()
                self.addChild(self.SKSpriteNode_1)
                self.addChild(self.SKSpriteNode_2)
                self.addChild(self.SKSpriteNode_3)
                self.addChild(self.SKSpriteNode_4)
                self.createPlayer(x: playerX,y: playerY)
            }
        }
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

