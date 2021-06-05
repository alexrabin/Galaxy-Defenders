//
//  GameOverScene+extension.swift
//  Galaxy Defenders
//
//  Created by Alex Rabin on 12/4/16.
//  Copyright © 2016 Alex Rabin. All rights reserved.
//

import SpriteKit

extension GameOverScene{
    
    
    
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
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        for index in 0...2 {
            
            MoveSingleLayer(star_layer[index], speed: star_layer_speed[index])
            
        }
        
    }

    
    
}
