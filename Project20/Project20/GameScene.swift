//
//  GameScene.swift
//  Project20
//
//  Created by Sandesh on 17/02/20.
//  Copyright © 2020 Sandesh. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var gameTimer: Timer?
    var fireworks = [SKNode]()
    var leftEdge = -22
    var bottomEdge = -22
    var rightEdge = 1024 + 22
    
    var score = 0 {
        didSet {
            
        }
    }
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        gameTimer =  Timer.scheduledTimer(timeInterval: 6.0,
                                          target: self,
                                          selector: #selector(launchFireWorks),
                                          userInfo: nil,
                                          repeats: true)
    }
    
    func createFireWork( xMovement: CGFloat, x: Int, y: Int) {
        let node = SKNode() //Container for rocket and fireblaze
        node.position = CGPoint(x: x, y: y)
        
        //colorBlendFactor => Allows us to tint sprite in different ways
        
        let firework = SKSpriteNode(imageNamed: "rocket")
        firework.colorBlendFactor = 1
        firework.name = "firework"
        node.addChild(firework)
        
        switch Int.random(in: 0...2) {
        case 0: firework.color = .cyan
        case 1: firework.color = .green
        default: firework.color = .red
        }
        
        let path = UIBezierPath()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: xMovement, y: 1000))
        
        let move = SKAction.follow(path.cgPath,
                                   asOffset: true,
                                   orientToPath: true,
                                   speed: 200)
        node.run(move)
        
        if let emmiter = SKEmitterNode(fileNamed: "fuse") {
            emmiter.position = CGPoint(x: 0, y: -22)
            node.addChild(emmiter)
        }
        
        fireworks.append(node)
        addChild(node)
    }
    
    
    @objc func launchFireWorks() {
        let movementAmont:CGFloat = 1800
        
        switch Int.random(in: 0...3) {
        case 0:
            //            fire five, straight up
            createFireWork(xMovement: 0, x: 512, y: bottomEdge)
            createFireWork(xMovement: 0, x: 512 - 200, y: bottomEdge)
            createFireWork(xMovement: 0, x: 512 - 100, y: bottomEdge)
            createFireWork(xMovement: 0, x: 512 + 100, y: bottomEdge)
            createFireWork(xMovement: 0, x: 512 + 200, y: bottomEdge)
            
        case 1:
            //            fire five, in fan
            createFireWork(xMovement: 0, x: 512, y: bottomEdge)
            createFireWork(xMovement: -200, x: 512 - 200, y: bottomEdge)
            createFireWork(xMovement: -100, x: 512 - 100, y: bottomEdge)
            createFireWork(xMovement: 100, x: 512 + 100, y: bottomEdge)
            createFireWork(xMovement: 200, x: 512 + 200, y: bottomEdge)
            
        case 2:
            //            fire five from left to right
            createFireWork(xMovement: movementAmont, x: leftEdge, y: bottomEdge + 400)
            createFireWork(xMovement: movementAmont, x: leftEdge, y: bottomEdge + 300)
            createFireWork(xMovement: movementAmont, x: leftEdge, y: bottomEdge + 200)
            createFireWork(xMovement: movementAmont, x: leftEdge, y: bottomEdge + 100)
            createFireWork(xMovement: movementAmont, x: leftEdge, y: bottomEdge)
        case 3:
            //            fire five from right to left
            createFireWork(xMovement: -movementAmont, x: rightEdge, y: bottomEdge + 400)
            createFireWork(xMovement: -movementAmont, x: rightEdge, y: bottomEdge + 300)
            createFireWork(xMovement: -movementAmont, x: rightEdge, y: bottomEdge + 200)
            createFireWork(xMovement: -movementAmont, x: rightEdge, y: bottomEdge + 100)
            createFireWork(xMovement: -movementAmont, x: rightEdge, y: bottomEdge)
        default: break
        }
    }
    
    func checkTouches(_ touches: Set<UITouch> ){
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        let nodesAtPoint = nodes(at: location)
        
        for case let node as SKSpriteNode in nodesAtPoint {
            guard node.name == "firework" else { continue }
            
            for parent in fireworks {
                guard let firework = parent.children.first as? SKSpriteNode else { continue }
                
                if firework.name == "selected" && firework.color != node.color {
                    firework.name = "firework"
                    firework.colorBlendFactor = 1
                }
            }
            
            node.name = "selected"
            node.colorBlendFactor = 0
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        checkTouches(touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        checkTouches(touches)
    }
    
    override func update(_ currentTime: TimeInterval) {
        for (index, firework) in fireworks.enumerated().reversed() {
            if firework.position.y > 900 {
                fireworks.remove(at: index)
                firework.removeFromParent()
            }
        }
    }
    
    
    func explode(fireWork: SKNode) {
        if let emitter = SKEmitterNode(fileNamed: "explode") {
            emitter.position = fireWork.position
            addChild(emitter)
        }
        
        fireWork.removeFromParent()
    }
    
    
    func explodeFireWorks() {
        var numExploded = 0
        
        for (index, fireworkContainer) in fireworks.enumerated().reversed() {
            guard  let firework = fireworkContainer.children.first as? SKSpriteNode else {
                continue
            }
            
            if firework.name == "selected" {
                explode(fireWork: fireworkContainer)
                fireworks.remove(at: index)
                numExploded += 1
            }
            
            switch numExploded {
            case 0: break
            case 1: score += 200
            case 2: score += 500
            case 3: score += 1500
            case 4: score += 2500
            default: score += 4000
            }
        }
    }
}
