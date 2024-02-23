//
//  GoogleAuth.swift
//  google_sign_in
//
//  Created by Reinatt Wijaya on 2/23/24.
//

import SwiftUI
import GoogleSignIn

class UserAuthModel: ObservableObject {
    
    @Published var givenName: String = ""
    @Published var email: String = ""
    @Published var isLoggedIn: Bool = false
    @Published var errorMessage: String = ""
    
    init(){
        check()
    }
    
    func checkStatus(){
        if(GIDSignIn.sharedInstance.currentUser != nil){
            let user = GIDSignIn.sharedInstance.currentUser
            guard let user = user else { return }
            let givenName = user.profile?.givenName
            let email = user.profile!.email
            self.givenName = givenName ?? ""
            self.email = email
            self.isLoggedIn = true
        }else{
            self.isLoggedIn = false
            self.givenName = "Not Logged In"
            self.email = ""
        }
    }
    
    func check(){
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if let error = error {
                self.errorMessage = "error: \(error.localizedDescription)"
            }
            
            self.checkStatus()
        }
    }
    
    func signIn(){
        
       guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else {return}

        let signInConfig = GIDConfiguration.init(clientID: "CLIENT-ID")
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
            }
        }
    }
    
    func tokenSignIn(idToken: String) {
        guard let authData = try? JSONEncoder().encode(["idToken": idToken]) else {
            return
        }
        let url = URL(string: "http://127.0.0.1:8000/google_oauth/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let task = URLSession.shared.uploadTask(with: request, from: authData) { data, response, error in
            // Handle response from your backend.
        }
        task.resume()
    }
    
    func signOut(){
        GIDSignIn.sharedInstance.signOut()
        self.checkStatus()
    }
}
