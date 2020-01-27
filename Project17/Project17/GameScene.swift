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
    var isGmeOver = false
    var score = 0 {
        didSet{
            scoreLabel.text = "Score: \(score)"
        }
    }
    
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
        
        gametimer = Timer.scheduledTimer(timeInterval: 0.35,
                                         target: self,
                                         selector: #selector(createEnemy),
                                         userInfo: nil,
                                         repeats: true)
        
    }
    
    @objc func createEnemy() {
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
            
            if !isGmeOver { score += 1 }
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
        isGmeOver = true
    }
    

}
