//
//  ContentView.swift
//  google_sign_in
//
//  Created by Reinatt Wijaya on 2/23/24.
//

import SwiftUI
import GoogleSignInSwift
import GoogleSignIn

func handleSignInButton(){
    
   guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else {return}

    let signInConfig = GIDConfiguration.init(clientID: "952150031288-70et6ee38ku9fq6t3s65g4r68pjrl6p3.apps.googleusercontent.com")
    guard let presentingViewController = (UIApplication.shared.connectedScenes.first
              as? UIWindowScene)?.windows.first?.rootViewController
          else {return}
    GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { signInResult, error in
        guard error == nil else { return }
        guard let signInResult = signInResult else { return }

        signInResult.user.refreshTokensIfNeeded { user, error in
            guard error == nil else { return }
            guard let user = user else { return }

            let idToken = user.idToken
            // Send ID token to backend (example below).
            print(idToken!)
            tokenSignIn(idToken: idToken!.tokenString)
        }
    }
}

func tokenSignIn(idToken: String) {
    guard let authData = try? JSONEncoder().encode(["idToken": idToken]) else {
        return
    }
    let url = URL(string: "http://127.0.0.1:8000/users/google_oauth/")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    let task = URLSession.shared.uploadTask(with: request, from: authData) { data, response, error in
        // Handle response from your backend.
    }
    task.resume()
}

struct ContentView: View {
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            GoogleSignInButton(action: handleSignInButton)
        }
        .padding()
    }

}
#Preview {
    ContentView()
}
