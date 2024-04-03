// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

extension View {

    func backgroundImageView(for image: BackgroundContainerImage) -> some View {
        Image(image.rawValue)
            .resizable()
            .scaledToFill()
            .edgesIgnoringSafeArea(.all)
    }
    
    func backgroundView(for background: BackgroundContainer) -> some View {
        switch background {
        case .image(let image):
            return AnyView(Image(image.rawValue)
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all))
        case .color(let color):
            return AnyView(color.edgesIgnoringSafeArea(.all))
        }
    }
    
    func backButtonNavigation(style: NavigationBackButtonStyle) -> some View {
        modifier(NavigationBackButtonModifier(style: style))
    }
}
