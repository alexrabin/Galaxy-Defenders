//
//  GameOverScene.swift
//  Galaxy Defenders
//
//  Created by Alex Rabin on 12/4/16.
//  Copyright © 2016 Alex Rabin. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {
    
    
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
    
    var yourScore = SKLabelNode()
    var scoreLabel = SKLabelNode()
    
    var highScore = UserDefaults.standard.integer(forKey: "HighScore")

    override func didMove(to view: SKView) {
        
        createStars()
        
        let tapToPlay = SKLabelNode(fontNamed: gameFont)
        tapToPlay.position = CGPoint(x: self.size.width/2, y: self.size.height*0.3)
        tapToPlay.fontSize = 90
        tapToPlay.zPosition = 3
        tapToPlay.name = "play"
        tapToPlay.text = "Play Again"
        self.addChild(tapToPlay)
        
       
        
        let backHome = SKLabelNode(fontNamed: gameFont)
        backHome.position = CGPoint(x: self.size.width/2, y: self.size.height*0.2)
        backHome.fontSize = 90
        backHome.zPosition = 3
        backHome.name = "menu"
        backHome.text = "Main Menu"
        self.addChild(backHome)
        
    }
    
    func getScore(score: Int){
        
        if score > highScore {
            highScore = score
            UserDefaults.standard.set(highScore, forKey: "HighScore")
            
            yourScore = SKLabelNode(fontNamed: gameFont)
            yourScore.fontColor = UIColor(r: 46, g: 228, b: 88)
            yourScore.fontSize = 140
            yourScore.text = "New High Score"
            yourScore.position = CGPoint(x: self.size.width/2, y: self.size.height*0.9)
            self.addChild(yourScore)
            
            scoreLabel = SKLabelNode(fontNamed: gameFont)
            scoreLabel.fontColor = .white
            scoreLabel.fontSize = 150
            scoreLabel.text = "\(score)"
            scoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.8)
            self.addChild(scoreLabel)
        }
        else {
            yourScore = SKLabelNode(fontNamed: gameFont)
            yourScore.fontColor = UIColor(r: 255, g: 205, b: 0)
            yourScore.fontSize = 140
            yourScore.text = "Your Score"
            yourScore.position = CGPoint(x: self.size.width/2, y: self.size.height*0.9)
            self.addChild(yourScore)
            
            scoreLabel = SKLabelNode(fontNamed: gameFont)
            scoreLabel.fontColor = .white
            scoreLabel.fontSize = 150
            scoreLabel.text = "\(score)"
            scoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.8)
            self.addChild(scoreLabel)
            
            let bestLabel = SKLabelNode(fontNamed: gameFont)
            bestLabel.fontColor = UIColor(r: 255, g: 205, b: 0)
            bestLabel.fontSize = 90
            bestLabel.text = "Your Best"
            bestLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.7)
            self.addChild(bestLabel)
            
            let highscorelabel = SKLabelNode(fontNamed: gameFont)
            highscorelabel.fontColor = .white
            highscorelabel.fontSize = 80
            highscorelabel.text = "\(highScore)"
            highscorelabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.65)
            self.addChild(highscorelabel)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = self.atPoint(location)
            if touchedNode.name == "play" {
                playGame()
            }
            else if touchedNode.name == "menu" {
                mainMenu()
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
    
    func mainMenu(){
        
        if let view = self.view {
            // Load the SKScene from 'GameScene.sks'
            let scene = HomeScene(size:CGSize(width: 1536, height: 2048))
            
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
