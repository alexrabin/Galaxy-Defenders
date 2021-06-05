//
//  GameScene+extension.swift
//  Galaxy Defenders
//
//  Created by Alex Rabin on 12/3/16.
//  Copyright © 2016 Alex Rabin. All rights reserved.
//

import SpriteKit

extension GameScene{
    
    
    
    func spawnEnemy() {
        let randomXStart = random(min:gameArea.minX , max:gameArea.maxX)
        let randomXEnd = random(min: gameArea.minX, max : gameArea.maxX)
        
        let startPoint = CGPoint(x: randomXStart, y: self.size.height * 1.2)
        let endPoint = CGPoint (x: randomXEnd, y:  -self.size.height * 1.2)
        let enemy = SKSpriteNode(imageNamed: "spaceship_enemy_rotated.png")
        enemy.setScale(0.4)
        enemy.position = startPoint
        enemy.zPosition = 2
        enemy.physicsBody = SKPhysicsBody( rectangleOf: enemy.size)
        enemy.physicsBody?.affectedByGravity = false
        enemy.physicsBody?.categoryBitMask = PhysicsCategories.Enemy
        enemy.physicsBody?.collisionBitMask = PhysicsCategories.None
        enemy.physicsBody?.contactTestBitMask = PhysicsCategories.Player | PhysicsCategories.Bullet
        self.addChild(enemy)
        
        let moveEnemy = SKAction.move(to: endPoint, duration: 3.5)
        let deleteEnemy = SKAction.removeFromParent()
        let enemySequence = SKAction.sequence([moveEnemy, deleteEnemy])
        enemy.run(enemySequence)
        
        let dx = endPoint.x  - startPoint.x
        let dy = endPoint.y - startPoint.y
        let amountToRotate = atan2(dy, dx)
        enemy.zRotation = amountToRotate
    }
    
    func spawnMultipleEnemies(){
        let randomNumber : Int = Int(random(min: 3, max: 6))
        let spawnALot = SKAction.run(spawnEnemy)
        let waitToSpawn = SKAction.wait(forDuration: 0.5)
        let spawnSequence = SKAction.sequence([spawnALot, waitToSpawn])
        let spawnForever = SKAction.repeat(spawnSequence, count: randomNumber)
        self.run(spawnForever)
    }
       func spawnRandomAsteriods(){
        
        let randomXStart = random(min:gameArea.minX , max:gameArea.maxX)
        let randomXEnd = random(min: gameArea.minX, max : gameArea.maxX)
        
        let startPoint = CGPoint(x: randomXStart, y: self.size.height * 1.2)
        let endPoint = CGPoint (x: randomXEnd, y:  -self.size.height * 1.2)
        var asteriod = SKSpriteNode()
        let randomAsteriod = arc4random_uniform(3)
        switch randomAsteriod {
        case 0:
            asteriod = SKSpriteNode(imageNamed: "aestroid_dark.png")
            break
        case 1:
            asteriod = SKSpriteNode(imageNamed: "aestroid_gay_2.png")

            break
        case 2:
            asteriod = SKSpriteNode(imageNamed: "aestroid_gray.png")

            break
        default:
            asteriod = SKSpriteNode(imageNamed: "aestroid_dark.png")
        }
        asteriod.setScale(random(min: 0.2, max: 0.8))
        asteriod.physicsBody = SKPhysicsBody(rectangleOf: asteriod.size)
        asteriod.physicsBody?.affectedByGravity = false
        asteriod.physicsBody?.categoryBitMask = PhysicsCategories.Asteriod
        asteriod.physicsBody?.collisionBitMask = PhysicsCategories.None
        asteriod.physicsBody?.contactTestBitMask = PhysicsCategories.Bullet | PhysicsCategories.Player
        //asteriod.physicsBody?.isDynamic = false
        asteriod.position = startPoint
        asteriod.zPosition = 1
        self.addChild(asteriod)
        
        let moveEnemy = SKAction.move(to: endPoint, duration: 8)
        let deleteEnemy = SKAction.removeFromParent()
        let enemySequence = SKAction.sequence([moveEnemy, deleteEnemy])
        asteriod.run(enemySequence)
        
        let i = random(min: 0, max: 1)
        switch i {
        case 0:
            setupRotationWith(direction: .counterClockwise, sprite: asteriod)
            break
        case 1:
            setupRotationWith(direction: .clockwise, sprite: asteriod)
        default:
            setupRotationWith(direction: .counterClockwise, sprite: asteriod)
            
        }
        
    }
    func spawnAsteriodClutter(){
        
        let randomNumber : Int = Int(random(min: 3, max: 7))
        let spawnALot = SKAction.run(spawnRandomAsteriods)
        let waitToSpawn = SKAction.wait(forDuration: 0.5)
        let spawnSequence = SKAction.sequence([spawnALot, waitToSpawn])
        let spawnForever = SKAction.repeat(spawnSequence, count: randomNumber)
        self.run(spawnForever)
    }

    func setupRotationWith(direction: rotationDirection, sprite : SKSpriteNode){
        let angle : Float = (direction == .clockwise) ? Float(M_PI) : -Float(M_PI)
        let rotate = SKAction.rotate(byAngle: CGFloat(angle), duration: 1)
        let repeatAction = SKAction.repeatForever(rotate)
        sprite.run(repeatAction, withKey: "rotate")
    }
    
    func createStars(){
        higher_x_bound = self.frame.width
        higher_y_bound = self.frame.height
        
        
        // create a dummy sprite
        let dummySprite = SKSpriteNode(imageNamed: "star")
        
        // create the 3 star layers
        star_layer = [[dummySprite],[dummySprite],[dummySprite]]
        
        //set layer 0
        star_layer_count.append(50)
        star_layer_speed.append(30.0)
        star_layer_color.append(SKColor.white)
        
        //set layer 1
        star_layer_count.append(50)
        star_layer_speed.append(20.0)
        star_layer_color.append(SKColor.yellow)
        
        //set layer 2
        star_layer_count.append(50)
        star_layer_speed.append(10.0)
        star_layer_color.append(SKColor.red)
        
        //draw all the stars in all the layers
        for starLayers in 0...2 {
            
            //draw all the stars in a single layer
            for _ in 1...star_layer_count[starLayers] {
                
                
                let sprite = SKSpriteNode(imageNamed: "star")
                // get a random position for the star
                let x_pos = CGFloat(Float(arc4random()) / Float(UINT32_MAX)) * higher_x_bound
                let y_pos = CGFloat(Float(arc4random()) / Float(UINT32_MAX)) * higher_y_bound
                sprite.position = CGPoint(x: x_pos, y: y_pos)
                // set the correct color for the star in that layer
                sprite.colorBlendFactor = 1.0
                sprite.color = star_layer_color[starLayers]
                star_layer[starLayers].append(sprite)
                self.addChild(sprite)
                
            }
        }
        
    }
    func MoveSingleLayer(_ star_layer:[SKSpriteNode],speed:CGFloat) {
        
        var sprite:SKSpriteNode
        var new_x:CGFloat = 0.0
        var new_y:CGFloat = 0.0
        
        for index in 0...star_layer.count-5 {
            
            sprite = star_layer[index]
            new_x = sprite.position.x + x_dir * speed * deltaTime
            new_y = sprite.position.y + y_dir * speed * deltaTime
            
            sprite.position = boundCheck( CGPoint(x: new_x, y: new_y) )
        }
        
        
    }
    func boundCheck(_ pos: CGPoint) -> CGPoint {
        var x = pos.x
        var y = pos.y
        
        
        if x < 0 {
            x += higher_x_bound
        }
        
        if y < 0 {
            
            y += higher_y_bound
        }
        
        if x > higher_x_bound {
            x -= higher_x_bound
        }
        
        if y > higher_y_bound {
            y -= higher_y_bound
        }
        
        return CGPoint(x: x, y: y)
        
    }
    
    func random() ->CGFloat{
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    func random(min:CGFloat, max:CGFloat) -> CGFloat{
        return random() * (max - min) + min
    }

}
