//
//  YogmithraApp.swift
//  Yogmithra
//
//  Created by Mohamed Fiyaz on 12/09/24.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

// AppDelegate to configure Firebase
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

// Sign In View
struct SignInView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isSignedIn = false // New state for checking if sign-in is successful
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Text("YOGMITHRA")
                .font(.system(size: 36, weight: .bold))
            
            Text("Sign in your account")
                .font(.system(size: 18))
                .padding(.bottom, 10)
            
            TextField("Email", text: $email)
                .autocapitalization(.none)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .frame(height: 50)
            
            SecureField("Password", text: $password)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .frame(height: 50)
                .textContentType(.none)

            
            Button(action: signIn) {
                Text("SIGN IN")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            Text("or sign in with")
                .padding(.top, 10)
            
            HStack(spacing: 20) {
                Button(action: {}) {
                    Image("google_logo")
                }
                Button(action: {}) {
                    Image("apple_logo")
                }
                Button(action: {}) {
                    Image("microsoft_logo")
                }
            }
            
            Spacer()
            
            HStack {
                Text("Don't have an account?")
                NavigationLink(destination: SignUpView()) {
                    Text("SIGN UP")
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }
            }
            .font(.system(size: 14))
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .navigationBarHidden(true) // Hides the navigation bar
        .fullScreenCover(isPresented: $isSignedIn) {
            MainScreenView() // Show the main view after sign-in
        }
    }
    
    func signIn() {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                alertMessage = error.localizedDescription
                showAlert = true
            } else {
                isSignedIn = true // Navigate to the main screen
            }
        }
    }
}

// Sign Up View
struct SignUpView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isChecked = false // State for toggleable checkbox
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showSuccessAlert = false // Separate success alert
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Text("YOGMITHRA")
                .font(.system(size: 36, weight: .bold))
            
            Text("Create your account")
                .font(.system(size: 18))
                .padding(.bottom, 10)
            
            TextField("Name", text: $name)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .frame(height: 50)
            
            TextField("Email", text: $email)
                .autocapitalization(.none)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .frame(height: 50)
            
            SecureField("Password", text: $password)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .frame(height: 50)
                .textContentType(.none)
            
            SecureField("Confirm Password", text: $confirmPassword)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .frame(height: 50)
                .textContentType(.none)

            
            HStack {
                Button(action: {
                    isChecked.toggle()
                }) {
                    Image(systemName: isChecked ? "checkmark.square" : "square")
                }
                Text("I understood the terms & policy.")
            }
            .padding(.vertical)
            
            Button(action: signUp) {
                Text("SIGN UP")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(isChecked ? Color.black : Color.gray) // Disable button if unchecked
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.vertical, 10)
            .disabled(!isChecked) // Disable signup button unless checkbox is checked
            
            Text("or sign up with")
                .padding(.top, 10)
            
            HStack(spacing: 20) {
                Button(action: {}) {
                    Image("google_logo")
                }
                Button(action: {}) {
                    Image("apple_logo")
                }
                Button(action: {}) {
                    Image("microsoft_logo")
                }
            }
            
            Spacer()
            
            HStack {
                Text("Have an account?")
                NavigationLink(destination: SignInView()) {
                    Text("SIGN IN")
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }
            }
            .font(.system(size: 14))
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .alert(isPresented: $showSuccessAlert) {
            Alert(title: Text("Success"), message: Text("User created successfully"), dismissButton: .default(Text("OK")))
        }
        .navigationBarHidden(true) // Hides the navigation bar
    }
    
    func signUp() {
        if password != confirmPassword {
            alertMessage = "Passwords do not match."
            showAlert = true
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                alertMessage = error.localizedDescription
                showAlert = true
            } else {
                showSuccessAlert = true // Show success alert
            }
        }
    }
}

// MainScreenView (for successful sign-in)
struct MainScreenView: View {
    var body: some View {
        Text("Welcome to the Main Screen")
            .font(.largeTitle)
            .padding()
    }
}

// Main Content Screen with Navigation
struct ContentScreenView: View {
    var body: some View {
        NavigationView {
            SignInView()
        }
    }
}

// Main App Declaration
@main
struct YogmithraApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentScreenView()
        }
    }
}

