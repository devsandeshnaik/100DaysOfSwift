//
//  WhackSlot.swift
//  Project14
//
//  Created by Sandesh on 02/01/20.
//  Copyright © 2020 Sandesh. All rights reserved.
//

import SpriteKit
import UIKit

class WhackSlot: SKNode {

    var charNode: SKSpriteNode!
    
    var isVisible = false
    var isHit = false
    
    func configure(at position: CGPoint) {
        self.position = position
        
        let spriteNode = SKSpriteNode(imageNamed: "whackHole")
        addChild(spriteNode)
        
        let cropNode = SKCropNode()
        cropNode.position = CGPoint(x: 0, y: 15)
        cropNode.zPosition = 1
        cropNode.maskNode = SKSpriteNode(imageNamed: "whackMask")
        
        
        charNode = SKSpriteNode(imageNamed: "penguinGood")
        charNode.position = CGPoint(x: 0, y: -90)
        cropNode.name = "character"
        cropNode.addChild(charNode)
        addChild(cropNode)
    }
    
    
    func show(hideTime: Double) {
        if isVisible { return }
        charNode.xScale = 1.0
        charNode.yScale = 1.0
        charNode.run(SKAction.moveBy(x: 0, y: 80, duration: 0.05))
        if let dust = SKEmitterNode(fileNamed: "Dust") {
                   dust.position = CGPoint(x: charNode.frame.midX, y: charNode.frame.minY - 5)
                   dust.zPosition = 5
                   addChild(dust)
               }
        isVisible = true
        isHit = false
        
        if Int.random(in: 0 ... 2) == 0 {
            charNode.texture = SKTexture(imageNamed: "penguinGood")
            charNode.name = "charFriend"
        } else {
            charNode.texture = SKTexture(imageNamed: "penguinEvil")
            charNode.name = "charEnemy"
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + hideTime * 3.5) {
            [weak self] in
            self?.hide()
        }
    }
    
    func hide() {
        if !isVisible { return }
        if let dust = SKEmitterNode(fileNamed: "Dust") {
        dust.position = CGPoint(x: charNode.frame.midX, y: charNode.frame.minY - 5)
        dust.zPosition = 5
        addChild(dust)
        charNode.run(SKAction.moveBy(x: 0, y: -80, duration: 0.05))
        isVisible = false
        
        }
    }
    
    func hit() {
        isHit = true
        let delay = SKAction.wait(forDuration: 0.25)
        let hide = SKAction.moveBy(x: 0, y: -80, duration: 0.5)
        let notVisible = SKAction.run { [weak self] in self?.isVisible = false  }
        let sequence = SKAction.sequence([delay,hide,notVisible])
        charNode.run(sequence)
    }
}
