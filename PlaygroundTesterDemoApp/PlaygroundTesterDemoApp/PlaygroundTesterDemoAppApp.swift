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
        PlaygroundTester.PlaygroundTesterConfigurator.isTesting = true
    }
    
    var body: some Scene {
        WindowGroup {
            PlaygroundTester.PlaygroundTesterWrapperView {
                Text("isTesting is false")
            }
        }
    }
}
