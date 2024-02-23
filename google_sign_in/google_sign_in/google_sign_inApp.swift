//
//  google_sign_inApp.swift
//  google_sign_in
//
//  Created by Reinatt Wijaya on 2/23/24.
//

import SwiftUI
import GoogleSignIn

@main
struct google_sign_inApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { url in
                  GIDSignIn.sharedInstance.handle(url)
                }
                .onAppear {
                  GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                    // Check if `user` exists; otherwise, do something with `error`
                  }
                }
        }
    }
}
