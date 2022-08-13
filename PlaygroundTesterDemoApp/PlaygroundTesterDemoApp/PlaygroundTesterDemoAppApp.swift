//
//  PlaygroundTesterDemoAppApp.swift
//  PlaygroundTesterDemoApp
//
//  Created by Pawel Lopusinski on 22/1/22.
//

import SwiftUI
import PlaygroundTester

@main
struct PlaygroundTesterDemoAppApp: App {
    
    init() {
        PlaygroundTester.PlaygroundTesterConfiguration.isTesting = true
    }
    
    var body: some Scene {
        WindowGroup {
            PlaygroundTester.PlaygroundTesterView {
                Text("isTesting is false")
            }
        }
    }
}
