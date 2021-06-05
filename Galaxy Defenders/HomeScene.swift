//
//  HomeScene.swift
//  Galaxy Defenders
//
//  Created by Alex Rabin on 12/4/16.
//  Copyright © 2016 Alex Rabin. All rights reserved.
//

import SpriteKit

let gameFont = "The Bold Font"

class HomeScene: SKScene {
    
    // scene bounderies
    let lower_x_boud : CGFloat = 0.0
    let lower_y_boud : CGFloat = 0.0
    var higher_x_bound : CGFloat = 0.0
    var higher_y_bound : CGFloat = 0.0
    
    //star layers one properties
    var star_layer : [[SKSpriteNode]] = []
    var star_layer_speed : [CGFloat]  = []
    var star_layer_color : [SKColor] = []
    var star_layer_count : [Int] = []
    
    // scroll direction
    var x_dir: CGFloat = 0.0
    var y_dir: CGFloat = -40.0
    
    
    //deltaTime
    var lastUpdate : TimeInterval = 0
    // 1/60 ~> 0.0166
    var deltaTime : CGFloat = 0.00666
    
    
    var gameArea : CGRect
    var currentRotationDirection = rotationDirection.counterClockwise
    
    var highScore = UserDefaults.standard.integer(forKey: "HighScore")

    var titleLabel = SKLabelNode()
    var playButton = SKSpriteNode()
    
    var textureAtlas = SKTextureAtlas()
    var textureArray = [SKTexture]()

    let playName = "Play Game"
    override init(size: CGSize) {
        let maxAspectRatio : CGFloat = 16.0/9.0
        let playableWidth = size.height / maxAspectRatio
        let margin = (size.width - playableWidth) / 2
        gameArea = CGRect(x: margin, y: 0, width: playableWidth, height: size.height)
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func didMove(to view: SKView) {
        
        setUpScene()
        
        
    }
    
    
    func setUpScene(){
        titleLabel = SKLabelNode(fontNamed: gameFont)
        titleLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.8)
        titleLabel.zPosition = 3
        titleLabel.fontColor = UIColor(r: 255, g: 205, b: 0)
        titleLabel.text = "Galaxy Defenders"
        titleLabel.fontSize = 110
        self.addChild(titleLabel)
        
        createStars()
        
        let highScoreLabel = SKLabelNode(fontNamed: gameFont)
        highScoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.6)
        highScoreLabel.text = "High Score:\(highScore)"
        highScoreLabel.fontColor = UIColor(r: 46, g: 228, b: 88)
        highScoreLabel.alpha = 0.8
        highScoreLabel.zPosition = 3
        highScoreLabel.fontSize = 100
        self.addChild(highScoreLabel)
        
        let spawnALot = SKAction.run(spawnAsteriodClutter)
        let waitToSpawn = SKAction.wait(forDuration: 5)
        let spawnSequence = SKAction.sequence([spawnALot, waitToSpawn])
        let spawnForever = SKAction.repeatForever(spawnSequence)
        self.run(spawnForever)

        textureAtlas = SKTextureAtlas(named: "Blue")
        for i in 1...textureAtlas.textureNames.count {
            let name = "ship_\(i).png"
            textureArray.append(SKTexture(imageNamed: name))
            
        }
        playButton = SKSpriteNode(imageNamed: textureAtlas.textureNames[0] )
        playButton.position = CGPoint (x: self.size.width/2, y: self.size.height * 0.4)
        playButton.setScale(0.6)
        playButton.zPosition = 3
        playButton.name = playName
        self.addChild(playButton)
        
        playButton.run(SKAction.repeatForever(SKAction.animate(with: textureArray, timePerFrame: 0.5)))
        
        let tapToPlay = SKLabelNode(fontNamed: gameFont)
        tapToPlay.position = CGPoint(x: self.size.width/2, y: self.size.height*0.28)
        tapToPlay.fontSize = 60
        tapToPlay.zPosition = 3
        tapToPlay.text = "Tap To Play"
        self.addChild(tapToPlay)
        
        let fadeOut = SKAction.fadeAlpha(by: 1.0, duration: 1.5)
        let fadeIn = SKAction.fadeAlpha(to: 0.0, duration: 1.5)
        let sequence = SKAction.sequence([fadeIn, fadeOut])
        tapToPlay.run(SKAction.repeatForever(sequence))
        
        let finger = SKSpriteNode(imageNamed: "clicker.png")
        finger.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.37)
        finger.color = SKColor.white
        finger.setScale(1.0)
        finger.name = playName
        finger.alpha = 0.7
        finger.zPosition = 4
        self.addChild(finger)
        
        let pulseUp = SKAction.scale(to: 2.0, duration: 1.5)
        let pulseDown = SKAction.scale(to: 1.0, duration: 1.5)
        let pulse = SKAction.sequence([pulseUp, pulseDown])
        let repeatPulse = SKAction.repeatForever(pulse)
        finger.run(repeatPulse)
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = self.atPoint(location)
            if touchedNode.name == playName {
                playGame()
            }

        }
    }
    
    func playGame(){
        
        if let view = self.view {
            // Load the SKScene from 'GameScene.sks'
            let scene = GameScene(size:CGSize(width: 1536, height: 2048))
            
            // Set the scale mode to scale to fit the window
            scene.backgroundColor = UIColor.black
            scene.scaleMode = .aspectFill
            
            // Present the scene
            view.presentScene(scene, transition: SKTransition.fade(withDuration: 0.5))
            //view.presentScene(scene)
            
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = false
            view.showsNodeCount = false
        }

    }
    
   
}
