//
//  GameScene.swift
//  Galaxy Defenders
//
//  Created by Alex Rabin on 12/2/16.
//  Copyright © 2016 Alex Rabin. All rights reserved.
//

import SpriteKit

enum rotationDirection{
    case clockwise
    case counterClockwise
    case none
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    struct PhysicsCategories {
        static let None : UInt32 = 0x1 << 0
        static let Player : UInt32 = 0x1 << 1 //1
        static let Bullet : UInt32 = 0x1 << 2 //2
        static let Enemy : UInt32 = 0x1 << 3 //4
        static let Asteriod : UInt32 = 0x1 << 4 //6
        
    }
    var score : Int = 0
    
    
   var textureAtlas = SKTextureAtlas()
    var textureArray = [SKTexture]()
    
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
    
    // used to demo 8 way scrolling
    var currentDir = 1

    var player = SKSpriteNode()
    
    var gameArea : CGRect
    var currentRotationDirection = rotationDirection.counterClockwise
    var scoreLabel = SKLabelNode()
    var coinLabel = SKLabelNode()
    
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
        self.physicsWorld.contactDelegate = self
        self.view?.backgroundColor = SKColor.black
        self.anchorPoint = CGPoint(x: 0, y: 0)
        createStars()
        createPlayer()
        
        let fireBullet = SKAction.run(){
            self.fireBullet()
        }
        let waitToFireInvaderBullet = SKAction.wait(forDuration: 0.4)
        let invaderFire = SKAction.sequence([fireBullet,waitToFireInvaderBullet])
        let repeatForeverAction = SKAction.repeatForever(invaderFire)
        run(repeatForeverAction, withKey: "FireBullet")
        
        
//        let spawn1 = SKAction.run(spawnRandomAsteriods)
//        let waitALittle = SKAction.wait(forDuration: 0.5)
//        let spawnALot = SKAction.run(spawnAsteriodClutter)
//
//        let waitToSpawn = SKAction.wait(forDuration: 5)
//        let spawnSequence = SKAction.sequence([spawn1,waitALittle, spawn1, waitToSpawn, spawnALot, waitToSpawn])
//        let spawnForever = SKAction.repeatForever(spawnSequence)
//        self.run(spawnForever)
        
        
        startLevel()
        setUpHud()
        
    }
    
    func startLevel() {
        let spawn = SKAction.run(spawnEnemy)
        let spawnAlot = SKAction.run(spawnMultipleEnemies)
        let waitToSpawn = SKAction.wait(forDuration: 3)
        let spawnSequence = SKAction.sequence([spawn, waitToSpawn, spawnAlot, waitToSpawn])
        let spawnForever = SKAction.repeatForever(spawnSequence)
        self.run(spawnForever)
        
        score = 0
    }
    
    func setUpHud(){
        scoreLabel = SKLabelNode(fontNamed: gameFont)
        scoreLabel.fontSize = 90
        scoreLabel.text = "\(score)"
        scoreLabel.fontColor = .white
        
        print(scoreLabel.position)
        self.addChild(scoreLabel)
        
    }
    func createPlayer(){
        textureAtlas = SKTextureAtlas(named: "Blue")
        for i in 1...textureAtlas.textureNames.count {
            let name = "ship_\(i).png"
            textureArray.append(SKTexture(imageNamed: name))
            
        }
        player = SKSpriteNode(imageNamed: textureAtlas.textureNames[0] )
        player.position = CGPoint (x: self.size.width/2, y: self.size.height * 0.2)
        player.setScale(0.4)
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.isDynamic = false
        player.physicsBody?.categoryBitMask = PhysicsCategories.Player
        player.physicsBody?.collisionBitMask = PhysicsCategories.None
        player.physicsBody?.contactTestBitMask = PhysicsCategories.Enemy | PhysicsCategories.Asteriod
        player.zPosition = 2
        self.addChild(player)
        
        player.run(SKAction.repeatForever(SKAction.animate(with: textureArray, timePerFrame: 0.5)))
    }
    func fireBullet()  {
        let bullet = SKSpriteNode(imageNamed: "bullet.png")
        bullet.size = CGSize(width:80, height: 200)
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.frame.size)
        bullet.physicsBody!.affectedByGravity = false
        bullet.physicsBody?.categoryBitMask = PhysicsCategories.Bullet
        bullet.physicsBody?.collisionBitMask = PhysicsCategories.None
        bullet.physicsBody?.contactTestBitMask = PhysicsCategories.Enemy //| PhysicsCategories.Asteriod
        bullet.position = player.position
        bullet.zPosition = 1
        
        self.addChild(bullet)
        
        let moveBullet = SKAction.moveTo(y: self.size.height + bullet.size.height, duration: 1)
        let  deletBullet = SKAction .removeFromParent()
        let bulletSequence = SKAction.sequence([ moveBullet, deletBullet])
        bullet.run(bulletSequence)
        
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var body1 = SKPhysicsBody()
        var body2 = SKPhysicsBody()
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask{
            body1 = contact.bodyA
            body2 = contact.bodyB
        }
        else {
            body1 = contact.bodyB
            body2 = contact.bodyA
        }
        if body1.categoryBitMask == PhysicsCategories.Player  && body2.categoryBitMask == PhysicsCategories.Enemy {
            print("Player and Enemy Collided")
            if body1.node != nil && body2.node != nil{
                explosion(position: body1.node!.position)
                explosion(position: body2.node!.position)
                removeAction(forKey: "FireBullet")
            }
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            let wait = SKAction.wait(forDuration: 1.5)
            let over = SKAction.run(gameOver)
            let sequence = SKAction.sequence([wait, over])
            run(sequence)
            
        }
        if body1.categoryBitMask == PhysicsCategories.Bullet && body2.categoryBitMask == PhysicsCategories.Enemy && (body2.node?.position.y)! < self.size.height {
            print("Bullet and Enemy Collided")
            if  body2.node != nil{
                explosion(position: body2.node!.position)
                
            }
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            score = score + 10
            scoreLabel.text = "\(score)"

        }
        if body1.categoryBitMask == PhysicsCategories.Bullet && body2.categoryBitMask == PhysicsCategories.Asteriod && (body2.node?.position.y)! < self.size.height{
            print("Bullet and Asteriod Collided")
            if  body2.node != nil{
                explosion(position: body2.node!.position)
                
            }
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            score = score + 5
            scoreLabel.text = "\(score)"
        }
        if body1.categoryBitMask == PhysicsCategories.Player && body2.categoryBitMask == PhysicsCategories.Asteriod && (body2.node?.position.y)! < self.size.height{
            print("Player and Asteriod Collided")
            if body1.node != nil && body2.node != nil{
                explosion(position: body1.node!.position)
                explosion(position: body2.node!.position)
                removeAction(forKey: "FireBullet")

            }
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            let wait = SKAction.wait(forDuration: 1.5)
            let over = SKAction.run(gameOver)
            let sequence = SKAction.sequence([wait, over])
            run(sequence)
        }
    }
    func explosion(position: CGPoint){
        let explosion = SKEmitterNode(fileNamed: "Explosion")!
        explosion.position = position
        self.addChild(explosion)
        self.run(SKAction.wait(forDuration: 2)) {
            explosion.removeFromParent()
        }
           }
    
    func gameOver(){
        if let view = self.view {
            // Load the SKScene from 'GameScene.sks'
            let scene = GameOverScene(size:CGSize(width: 1536, height: 2048))
            
            // Set the scale mode to scale to fit the window
            scene.backgroundColor = UIColor.black
            scene.scaleMode = .aspectFill
            
            // Present the scene
            scene.getScore(score: score)
            view.presentScene(scene, transition: SKTransition.fade(withDuration: 0.5))
            //view.presentScene(scene)
            
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = false
            view.showsNodeCount = false
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            var location = touch.location(in: self)
            player.run(SKAction.move(to: location, duration: 0.1))

            if location.x > gameArea.maxX - player.size.width/2
            {
                location.x = gameArea.maxX - player.size.width/2
                
                player.run(SKAction.move(to: location, duration: 0.1))
                
                
            }
           else if location.x < gameArea.minX + player.size.width/2
            {
                location.x = gameArea.minX + player.size.width/2
                player.run(SKAction.move(to: location, duration: 0.1))
                
                
            }
            else if location.y > gameArea.maxY - player.size.height/2 {
                location.y = gameArea.maxY - player.size.height/2
                
                player.run(SKAction.move(to: location, duration: 0.1))
            }
            else if location.y < gameArea.minY + player.size.height/2 {
                location.y = gameArea.minY + player.size.height/2
                
                player.run(SKAction.move(to: location, duration: 0.1))
            }
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            var location = touch.location(in: self)
            player.run(SKAction.move(to: location, duration: 0.1))

            if location.x > gameArea.maxX - player.size.width/2
            {
                location.x = gameArea.maxX - player.size.width/2

                player.run(SKAction.move(to: location, duration: 0.1))
                x_dir = 5
                
            }
            if location.x < gameArea.minX + player.size.width/2
            {
                location.x = gameArea.minX + player.size.width/2
                player.run(SKAction.move(to: location, duration: 0.1))
                x_dir = -5

                
            }
            else if location.y > gameArea.maxY - player.size.height/2 {
                location.y = gameArea.maxY - player.size.height/2
                
                player.run(SKAction.move(to: location, duration: 0.1))
            }
            else if location.y < gameArea.minY + player.size.height/2 {
                location.y = gameArea.minY + player.size.height/2
                
                player.run(SKAction.move(to: location, duration: 0.1))
            }

        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        scoreLabel.position = CGPoint(x: gameArea.maxX - scoreLabel.frame.size.width, y: gameArea.maxY - scoreLabel.frame.size.height)
        for index in 0...2 {
            
            MoveSingleLayer(star_layer[index], speed: star_layer_speed[index])
            
        }

    }
    


  }

