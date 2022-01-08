//
//  ContentView.swift
//  VirtualJoystick
//
//  Created by Luke Lazzaro on 8/1/22.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    let scene = SKScene(fileNamed: "GameScene") as! GameScene

    var body: some View {
        SpriteView(scene: scene)
            .ignoresSafeArea()
    }
}
