//
//  LoginView.swift
//  Iterra
//
//  Created by mikhey on 2023-10-23.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var appStateManager: AppStateManager
    @EnvironmentObject var userService: UserService
    
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
            
            Button(action: {
                guard !email.isEmpty else {
                    return
                }
                UserDefaults.standard.set(email, forKey: "currentUserEmail")
                
                Task {
                    let user = await userService.fetchUser()
                    await appStateManager.configApp(user: user)
                }
            }, label: {
                Text("Sign in")
                    .font(.title2.bold())
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding()
            })
            .disabled(email.isEmpty)
        })
    }
}

#Preview {
    LoginView()
        .environmentObject(AppStateManager())
        .environmentObject(UserService())
}
