//
//  GameScene.swift
//  VirtualJoystick
//
//  Created by Luke Lazzaro on 8/1/22.
//

import SpriteKit

// Simple example of a virtual joystick moving a sprite node around.
// This should be encapsulated in its own class or struct so it becomes reusable, and possibly put on SPM.
class GameScene: SKScene {
    var joystickZone: SKNode!
    var joystickSocket: SKSpriteNode!
    var joystickKnob: SKSpriteNode!
    var originalSocketPosition = CGPoint.zero
    var direction = CGPoint.zero
    
    var player: SKSpriteNode!
    var didTouchInsideZone = false

    override func didMove(to view: SKView) {
        // Grab everything from the scene and store them in properties.
        joystickZone = childNode(withName: "joystickzone")!
        joystickSocket = childNode(withName: "joysticksocket")! as? SKSpriteNode
        joystickKnob = joystickSocket.childNode(withName: "joystickknob")! as? SKSpriteNode
        player = childNode(withName: "player")! as? SKSpriteNode
        
        // This joystick returns to its original position when the user lifts their finger, which in this case is where the joystick was when it was created.
        originalSocketPosition = joystickSocket.position
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Ignore multitouch in this project.
        guard let touch = touches.first else { return }
        
        // The joystick can only be moved in a user-defined rectangle.
        guard let joystickZone = joystickZone else { return }
        let touchPos = touch.location(in: self)
        if joystickZone.frame.contains(touchPos) {
            didTouchInsideZone = true
            joystickSocket.position = touchPos
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        // Ignore any dragging if the user didn't start touching inside aforementioned rectangle.
        guard didTouchInsideZone else { return }
        
        // Get the distance and direction from the socket's position to the current touch position, and normalise it for use in player movement.
        let touchPos = touch.location(in: self)
        direction = (touchPos - joystickSocket.position).normalized()
        
        // Make sure the socket follows the user's finger.
        let distanceConstraint = SKConstraint.distance(SKRange(lowerLimit: 0, upperLimit: 80), to: touchPos)
        joystickSocket.constraints = [distanceConstraint]
        
        // Move the knob to where the user's finger is at all times.
        let knobPos = touch.location(in: joystickSocket)
        joystickKnob?.position = knobPos
        
        // Optional contraint for the knob, to make sure it doesn't move too far from the socket. This isn't needed if you use the above constraint.
//        let knobConstraint = SKConstraint.distance(SKRange(lowerLimit: 0, upperLimit: 80), to: joystickSocket!)
//        joystickKnob?.constraints = [knobConstraint]
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Reset constraints and positions.
        joystickSocket.constraints = []
        joystickSocket.position = originalSocketPosition
        joystickKnob.position = CGPoint.zero
        joystickKnob.constraints = []
        direction = CGPoint.zero
        didTouchInsideZone = false
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Move the player based on the joystick's current direction.
        player.position += direction * 4
    }
}
