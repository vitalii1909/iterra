//
//  LoginView.swift
//  Iterra
//
//  Created by mikhey on 2023-10-23.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var appStateManager: AppStateManager
    @EnvironmentObject var userService: UserFirebaseRepository
    
    @State var email = ""
    
    var body: some View {
        VStack(content: {
            Spacer()
            TextField("Your email", text: $email)
                .font(.title3)
                .textFieldStyle(.roundedBorder)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
                .padding()
            Spacer()
            
            loginBtn
        })
    }
    
    private var loginBtn: some View {
        Button(action: {
            guard !email.isEmpty else {
                return
            }
            UserDefaults.standard.set(email, forKey: "currentUserEmail")
            
            Task {
                
                do {
                    var user: User?
                    user = try await userService.fetchUser()
                    
                    if user == nil {
                        user = try await userService.signUpUser(email: email)
                    }
                    
                    await appStateManager.configApp(user: user)
                } catch let error {
                    
                }
            }
        }, label: {
            Text("Sign in")
        })
        .buttonStyle(BlueButton())
        .padding(.horizontal, 20)
        .disabled(email.isEmpty)
        .animation(.smooth, value: email.isEmpty)
    }
}

#Preview {
    LoginView()
        .environmentObject(AppStateManager())
        .environmentObject(UserFirebaseRepository())
}
