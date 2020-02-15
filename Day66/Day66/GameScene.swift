//
//  GameScene.swift
//  Day66
//
//  Created by Sandesh on 02/02/20.
//  Copyright © 2020 Sandesh. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    
    private var backGround      : SKEmitterNode!
    private var timeLabel       : SKLabelNode!
    private var scoreLabel      : SKLabelNode!
    
    private var timer           : Timer!
    private var enemyTimer      : Timer!
    
    private var time = 0 {
        didSet {
            timeLabel.text = "Time \(time)"
        }
    }
    
    private let yPositions = [ 100, 250, 400]
    
    override func didMove(to view: SKView) {
        
        backGround = SKEmitterNode(fileNamed: "starfield")
        backGround.position = CGPoint(x: 1024, y: 384)
        backGround.advanceSimulationTime(10)
        addChild(backGround)
        backGround.zPosition = -1
        
        
        timeLabel = SKLabelNode(fontNamed: "Chalkduster")
        timeLabel.position = CGPoint(x: 880, y: 730)
        addChild(timeLabel)
        time = 60
        
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 20, y: 730)
        
        enemyTimer = Timer.scheduledTimer(timeInterval: 0.40, target: self, selector: #selector(createTarget), userInfo: nil, repeats: true)
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {[unowned self] _ in
            if self.time > 0 {
                self.time -= 1
            } else {
                self.timer.invalidate()
                self.enemyTimer.invalidate()
                self.removeAllChildren()
            }
        })
    }
    
    @objc private func createTarget() {
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      
    }
    
    
}
