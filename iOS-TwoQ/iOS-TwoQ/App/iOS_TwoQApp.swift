//
//  iOS_TwoQApp.swift
//  iOS-TwoQ
//
//  Created by Alfredo Sandoval-Luis on 4/2/25.
//

import SwiftUI
import FirebaseCore // Import Firebase so we can configure it when the app starts

// MARK: - AppDelegate
// This class is responsible for setting up things when the app launches (before showing any screens).
class AppDelegate: NSObject, UIApplicationDelegate {
    
    // This function is called automatically when the app finishes launching.
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        
        // Configure Firebase services (like Authentication, Firestore, Storage, etc.)
        FirebaseApp.configure()
        
        // Returning true tells the system everything is ready
        return true
    }
}

// MARK: - Main App Entry Point
// The main struct where your app actually starts running.
@main
struct iOS_TwoQApp: App {
    
    // We tell SwiftUI to use our custom AppDelegate for setting up Firebase
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            // Set the first view that the user will see: ContentView
            ContentView()
                .background(Color("backgroundColor").ignoresSafeArea())
        }
    }
}
