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
import AVFoundation

var playerX = 0;
var playerY = 0;
let save = UserDefaults.standard

var HoleDeathEffet: AVAudioPlayer?
var SpikeDeathEffect: AVAudioPlayer?
var WinEffect: AVAudioPlayer?

let path1 = Bundle.main.path(forResource: "Death_Holes.mp3", ofType:nil)!
let url1 = URL(fileURLWithPath: path1)

let path2 = Bundle.main.path(forResource: "Death_Spikes.mp3", ofType:nil)!
let url2 = URL(fileURLWithPath: path2)

let path3 = Bundle.main.path(forResource: "Win.mp3", ofType:nil)!
let url3 = URL(fileURLWithPath: path3)

// Starts an enum for different types of collisions (In Progress)
enum CollisionTypes: UInt32 {
    case player = 1
    case SKSpriteNode_1 = 2
    case wall = 3
    case spike = 4
    case hole = 5
    case header = 6
    case finish = 7
    
}

//Class declares the different types of sprites along with the tilt controls for the game scene
class GameScene: SKScene, SKPhysicsContactDelegate {
    var player: SKSpriteNode!
    var finish: SKSpriteNode!
    var spike: SKSpriteNode!
    var back: SKSpriteNode!
    var lastTouchPosition: CGPoint?
    var deathLabel: SKLabelNode!
    var levelLabel: SKLabelNode!
    var hole: SKSpriteNode!
    var c1: SKSpriteNode!
    var c2: SKSpriteNode!
    var c3: SKSpriteNode!
    var block: SKSpriteNode!
    var header: SKSpriteNode!
    var enemy: SKSpriteNode!
    
    var SKSpriteNode_1 = SKSpriteNode()
    var SKSpriteNode_2 = SKSpriteNode()
    var SKSpriteNode_3 = SKSpriteNode()
    var SKSpriteNode_4 = SKSpriteNode()
    
    var motionManager: CMMotionManager!

    
    var isGameOver = false
    
    //Creates scoreboard
    var death = save.integer(forKey: "death") {
        didSet {
            deathLabel.text = "Deaths: \(death)"
            save.set(death, forKey: "death")
            save.set(death, forKey: "olddeath")
        }
    }
    
    var level = save.integer(forKey: "level") {
        didSet {
            levelLabel.text = "Level: \(level)"
            save.set(level, forKey: "level")
            save.set(level, forKey: "oldlevel")
        }
    }
    
    
    //This loads the gravity function for the tilt control
    //It aslso calls the functions needed to load the level like the sprites
    override func didMove(to view: SKView) {
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        // Set the file path
        
        
        buildLevel(levels: "level\(level)")
        
        SKSpriteNode_1 = self.childNode(withName: "SKSpriteNode_1") as! SKSpriteNode
        SKSpriteNode_2 = self.childNode(withName: "SKSpriteNode_2") as! SKSpriteNode
        SKSpriteNode_3 = self.childNode(withName: "SKSpriteNode_3") as! SKSpriteNode
        SKSpriteNode_4 = self.childNode(withName: "SKSpriteNode_4") as! SKSpriteNode
        
        motionManager = CMMotionManager()
        motionManager.startAccelerometerUpdates()
    }
    
    func buildLevel(levels: String) {
        let levelPath = Bundle.main.path(forResource: levels, ofType: "txt")
        let levelString = try? String(contentsOfFile: levelPath!)
        let lines = levelString?.components(separatedBy: "\n")
      
                // x -> 680
                // y -> 1280
        
        var y = 645

        for line in lines! {
            var x = -352
            for c in line{
                switch c {     // based on the character read load a different object into the game
                    
                case "x":                                  // x - z = wall/block obstacles
                    createObstacle(x: x, y: y,texture:0)
                    
                case "y":
                    createObstacle(x: x, y: y,texture:1)
                    
                case "z":
                    createObstacle(x: x, y: y,texture:2)
                    
                case "o":                                // o = hole
                    createHole(x: x, y: y)
                    
                case "l":                               // l = spike pointing left
                    createLSpike(x: x - 18, y: y)
                    
                case "r":                               // r = spike pointing right
                    createRSpike(x: x + 18, y: y)
                    
                case "h":                               //  h = header fil
                    createheader(x: x + 352, y: y)
                    
                case "t":                               // t = spike pointing down
                    createTSpike(x: x, y: y + 18)
                    
                case "b":                               // b = spike pointing up
                    createBSpike(x: x, y: y - 18)
                    
                case "f":                               // f = finish line horizontal
                    createFinish(x: x, y: y ,orientation:0)
                    
                case "g":                                // g = finish line vertical
                    createFinish(x: x, y: y ,orientation:1)
                    
                case "0":                                 // 0 = game will have wood background
                    back = SKSpriteNode(imageNamed: "background_wood")
                    
                 case "1":
                    back = SKSpriteNode(imageNamed: "background_stone")
                    
                 case "2":
                    back = SKSpriteNode(imageNamed: "background_brick")
                    
                 case "p":
                    playerX = x
                    playerY = y
                    createPlayer(x: x, y: y)
                    
    
                case "n":
                    break
                    
                default:
                    break
                }
                x += 64
            }
            y -= 64;
        }
        save.set(death, forKey: "death")
        save.set(death, forKey: "olddeath")
        save.set(level, forKey: "level")
        save.set(level, forKey: "oldlevel")
        
        deathLabel = SKLabelNode(fontNamed: "Papyrus")
        deathLabel.text = "Deaths: \(death)"
        deathLabel.horizontalAlignmentMode = .left
        deathLabel.position = CGPoint(x: -360, y: 630)
        deathLabel.zPosition=100
        addChild(deathLabel)
        
        levelLabel = SKLabelNode(fontNamed: "Papyrus")
        levelLabel.text = "Level: \(level)"
        levelLabel.horizontalAlignmentMode = .center
        levelLabel.position = CGPoint(x: 0, y: 630)
        levelLabel.zPosition = 100
        addChild(levelLabel)
        
        //back = SKSpriteNode(imageNamed: "background")
        back.position = CGPoint(x:0, y:0)
        back.zPosition = -2
        addChild(back)
        
        
        addChild(SKSpriteNode_1)
        addChild(SKSpriteNode_2)
        addChild(SKSpriteNode_3)
        addChild(SKSpriteNode_4)
        
    }

    
    func createheader(x: Int, y: Int) {
        header = SKSpriteNode(imageNamed: "header")
        header.position = CGPoint(x: x, y: y)
        header.zPosition = 99
        header.physicsBody = SKPhysicsBody(rectangleOf: header.size)
        header.physicsBody?.categoryBitMask = CollisionTypes.header.rawValue
        header.physicsBody?.isDynamic = false
        header.physicsBody?.categoryBitMask = CollisionTypes.spike.rawValue
        header.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        header.physicsBody?.collisionBitMask = 0
        addChild(header)
    }
    
    //This function creates the player
    func createPlayer(x: Int  ,y: Int) {
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: x, y: y)
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
        player.zPosition = 1
        player.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player.physicsBody?.collisionBitMask = CollisionTypes.SKSpriteNode_1.rawValue
        player.physicsBody?.collisionBitMask = CollisionTypes.spike.rawValue
        player.physicsBody?.allowsRotation = false
        addChild(player)
    }
    
    //This function creates the finish line
    func createFinish(x: Int  ,y: Int ,orientation: Int) {
        if orientation == 0 {
            finish = SKSpriteNode(imageNamed: "Check")
        }
        else if orientation == 1 {
            finish = SKSpriteNode(imageNamed: "Checkrotated")
        }
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
        spike.physicsBody = SKPhysicsBody(texture: spike.texture!, size: spike.texture!.size())
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
        spike.physicsBody = SKPhysicsBody(texture: spike.texture!, size: spike.texture!.size())
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
        spike.physicsBody = SKPhysicsBody(texture: spike.texture!, size: spike.texture!.size())
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
        spike.physicsBody = SKPhysicsBody(texture: spike.texture!, size: spike.texture!.size())
        spike.physicsBody?.isDynamic = false
        spike.physicsBody?.categoryBitMask = CollisionTypes.spike.rawValue
        spike.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        spike.physicsBody?.collisionBitMask = 0
        spike.zPosition = 1
        addChild(spike)
    }
    
    func createObstacle (x: Int  ,y: Int , texture: Int){
        if texture == 0 {
            block = SKSpriteNode(imageNamed: "block")
        }
        else if texture == 1 {
            block = SKSpriteNode(imageNamed: "Rock_Block")
        }
        else if texture == 2 {
            block = SKSpriteNode(imageNamed: "brick")
        }
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
        hole.physicsBody = SKPhysicsBody(circleOfRadius: hole.size.width / 2)
        hole.physicsBody?.isDynamic = false
        hole.physicsBody?.categoryBitMask = CollisionTypes.hole.rawValue
        hole.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        hole.physicsBody?.collisionBitMask = 0
        hole.zPosition = -1
        addChild(hole)
    }
    
    
    func createEnemy(x: Int ,y: Int){
        let leftWall = -352
        let rightWall = 352
        
        let moveThere = SKAction.move(to: CGPoint(x:leftWall, y:y), duration: 2)
        let movingback = SKAction.move(to: CGPoint(x:rightWall, y:y), duration: 2)
        
        let moveAndMoveBack = SKAction.sequence([moveThere, movingback])
        
        let repeatForEver = SKAction.repeatForever(moveAndMoveBack)
        
    
        enemy = SKSpriteNode(imageNamed: "player")
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody?.categoryBitMask = CollisionTypes.wall.rawValue
        enemy.position = CGPoint(x: x, y: y)
        enemy.physicsBody?.isDynamic = false
        enemy.physicsBody?.categoryBitMask = CollisionTypes.spike.rawValue
        enemy.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        enemy.physicsBody?.collisionBitMask = 0
        enemy.zPosition=1
        enemy.run(repeatForEver)
        self.addChild(enemy)
        
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
            do {
                SpikeDeathEffect = try AVAudioPlayer(contentsOf: url2)
                SpikeDeathEffect?.play()
            } catch {
                // couldn't load file :(
            }
            death += 1
            let position = player.position
            let scale = SKAction.scale(to: 1, duration: 0.05)
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
                    self.c3.run(scale) { [unowned self] in
                        self.c3.removeFromParent()
                    }
                }
            }
            save.set(death, forKey: "death")
            save.set(death, forKey: "olddeath")
            self.createPlayer(x: playerX, y: playerY)
        } else if node.name == "Hole" {
            do {
                HoleDeathEffet = try AVAudioPlayer(contentsOf: url1)
                HoleDeathEffet?.play()
            } catch {
                // couldn't load file :(
            }
            player.physicsBody?.isDynamic = false
            let move = SKAction.move(to: node.position, duration: 0.25)
            let scale = SKAction.scale(to: 0.000001, duration: 0.5)
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([move, scale, remove])
            player.run(sequence) { [unowned self] in
                self.death += 1
                self.createPlayer(x: playerX,y: playerY)
            }
            save.set(death, forKey: "death")
            save.set(death, forKey: "olddeath")
        } else if node.name == "Check" {
            do {
                WinEffect = try AVAudioPlayer(contentsOf: url3)
                WinEffect?.play()
            } catch {
                // couldn't load file :(
            }
            player.physicsBody?.isDynamic = false
            player.zPosition = 101
            let scalep = SKAction.scale(to: 75, duration: 1.0)
            player.run(scalep) {[unowned self] in
                self.level += 1
                self.removeAllChildren()
                self.buildLevel(levels: "level\(self.level)")
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

