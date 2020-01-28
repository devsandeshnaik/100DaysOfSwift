//
//  GameScene.swift
//  Project17
//
//  Created by Sandesh on 27/01/20.
//  Copyright © 2020 Sandesh. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate{
    var starField: SKEmitterNode!
    var player: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    
    var possibleEnimies = ["ball", "hammer", "tv"]
    var gametimer: Timer?
    var isGameOver = false
    var score = 0 {
        didSet{
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var enemyCount = 20
    var timeInterval: TimeInterval = 1.0
    
    override func didMove(to view: SKView) {
          
        starField =  SKEmitterNode(fileNamed: "starfield")!
        starField.position = CGPoint(x: 1024, y: 384)
        starField.advanceSimulationTime(10)
        addChild(starField)
        starField.zPosition = -1
        
        
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x:100, y: 384)
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
        player.physicsBody?.contactTestBitMask = 1
        addChild(player)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        score = 0
        
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
       scheduleTimer(with: timeInterval)
        
    }
    
    
    func scheduleTimer(with duration: TimeInterval) {
        gametimer = Timer.scheduledTimer(timeInterval: duration,
                                                target: self,
                                                selector: #selector(createEnemy),
                                                userInfo: nil,
                                                repeats: true)
    }
    
    @objc func createEnemy() {
        
        enemyCount -= 1
        if enemyCount == 0 {
            gametimer?.invalidate()
            timeInterval -= 0.1
            scheduleTimer(with: timeInterval)
            return
        }
        
        guard  let enemy = possibleEnimies.randomElement() else { return }
        
        let spirit = SKSpriteNode(imageNamed: enemy)
        spirit.position = CGPoint(x: 1200, y: Int.random(in: 20...736))
        addChild(spirit)
        spirit.physicsBody = SKPhysicsBody(texture: spirit.texture!, size: spirit.size)
        spirit.physicsBody?.categoryBitMask =  1
        spirit.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
        spirit.physicsBody?.angularVelocity = 5
        spirit.physicsBody?.linearDamping   = 0
        spirit.physicsBody?.angularDamping  = 0
    }
    
    override func update(_ currentTime: TimeInterval) {
        for node in children {
            if node.position.x < -300 {
                node.removeFromParent()
            }
            if !isGameOver { score += 1 }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        var location = touch.location(in: self)
        
        if location.y < 100 {
            location.y = 100
        } else if location.y > 668 {
            location.y = 668
        }
        
        player.position = location
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let explosion = SKEmitterNode(fileNamed: "explosion")!
        explosion.position = player.position
        addChild(explosion)
        
        player.removeFromParent()
        isGameOver = true
        gametimer?.invalidate() // Stops the time resulting in no more enemy generation
    }
    
//    Challenge 1: Destroy the space ship if user lifts his/her finger
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let explosion = SKEmitterNode(fileNamed: "explosion")!
        explosion.position = player.position
        addChild(explosion)
        
        player.removeFromParent()
        isGameOver = true
        gametimer?.invalidate() // Stops the time resulting in no more enemy generation
    }
    

}
