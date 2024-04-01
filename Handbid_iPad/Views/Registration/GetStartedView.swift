// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import NetworkService
import SwiftUI

struct GetStartedView<T: PageProtocol>: View {
    @EnvironmentObject private var coordinator: Coordinator<T, Any?>
    @ObservedObject private var viewModel = GetStartedViewModel()
    @State private var contentLoaded = false
    @State private var isBlurred = false
    
    var body: some View {
        ZStack {
            if contentLoaded { content } else { content }
        }
        .background {
            backgroundImageView(for: .registrationWelcome)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                contentLoaded = true
            }
            isBlurred = false
        }
        .ignoresSafeArea()
    }
    
    private var content: some View {
        OverlayInternalView(cornerRadius: 40) {
            VStack {
                getLogoImage()
                    .animation(.easeInOut(duration: 0.3), value: contentLoaded)
                getHeaderText()
                    .animation(.easeInOut(duration: 0.3), value: contentLoaded)
                getButtons()
                    .animation(.easeInOut(duration: 0.3), value: contentLoaded)
                
            }.padding()
        }
        .blur(radius: isBlurred ? 10 : 0)
        .padding()
    }
    
    private func getLogoImage() -> some View {
        Image("LogoSplash")
            .resizable()
            .scaledToFit()
            .frame(height: 50)
            .onLongPressGesture(minimumDuration: 0.5) {
                isBlurred = true
                coordinator.push(RegistrationPage.chooseEnvironment as! T)
            }
            .accessibilityIdentifier("AppLogo")
    }
    
    private func getHeaderText() -> some View {
        Text(LocalizedStringKey("welcomeToHandbid"))
            .applyTextStyle(style: .headerTitle)
            .accessibilityIdentifier("GetStartedView")
    }
    
    private func getButtons() -> some View {
        VStack(spacing: 10) {
            Button<Text>.styled(config: .primaryButtonStyle, action: {
                isBlurred = true
                coordinator.push(RegistrationPage.logIn as! T)
            }) {
                Text(LocalizedStringKey("login"))
                    .textCase(.uppercase)
            }.accessibilityIdentifier("LoginButton")
            
            Button<Text>.styled(config: .secondaryButtonStyle, action: {
                viewModel.logInAnonymously()
            }) {
                Text(LocalizedStringKey("demoVersion"))
                    .textCase(.uppercase)
            }.accessibilityIdentifier("DemoButton")
            
            Button<Text>.styled(config: .thirdButtonStyle, action: {
                viewModel.openHandbidWebsite()
            }) {
                Text(LocalizedStringKey("btnAboutHandbid"))
                    .textCase(.uppercase)
            }.accessibilityIdentifier("AboutHandbidButton")
        }
    }
}
