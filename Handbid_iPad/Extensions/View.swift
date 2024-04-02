// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

extension View {
    /// Apply BaseTextFieldStyle to TextField or view's subviews that are TextFields
    func basicTextFieldStyle() -> some View {
        textFieldStyle(
            BaseTextFieldStyle(cornerRadius: 8, backgroundColor: .white, borderColor: .hbGray, textColor: .bodyText)
        )
    }
    
    func textFieldLabelStyle() -> some View {
        baseTextStyle(color: .hbGray, size: 13.0)
    }
    
    /// Apply BaseLabelModifier with params to View
    private func baseTextStyle(
        color: Color,
        size: CGFloat,
        weight: Font.Weight = Font.Weight.semibold,
        toUppercase: Bool = false
    ) -> some View {
        modifier(BaseLabelModifier(
            textColor: color,
            font: Font.custom("Inter", size: size),
            fontWeight: weight,
            toUppercase: toUppercase
        )
        )
    }
    
    /// Style designed for use in Button labels
    func buttonLabelStyle(color: Color, uppercase: Bool = true) -> some View {
        baseTextStyle(color: color, size: 16.0, toUppercase: uppercase)
    }
    
    /// Style designed for title sections in screens, similar to system .title style
    func titleTextStyle() -> some View {
        baseTextStyle(color: .headerText, size: 40.0)
    }
    
    /// Style designed for second level title sections, similar to system .title2
    func subTitleTextStyle() -> some View {
        baseTextStyle(color: .headerText, size: 32.0)
    }
    
    /// Style designed for body text sections of screens, like descriptions etc
    func bodyTextStyle() -> some View {
        baseTextStyle(color: .bodyText, size: 16.0, weight: Font.Weight.regular)
    }
    
    /// Easily apply modifier that makes view take up as much space horizontally as possible
    func fullWidthStyle() -> some View {
        modifier(FullWidthModifier())
    }
    
    /// Apply button style with solid background and AccentColor
    func solidAccentButtonStyle() -> some View {
        buttonStyle(SolidButtonStyle.accent)
    }
    
    /// Apply button style with solid backgroun and PrimaryButtonColor
    func solidPrimaryButtonStyle() -> some View {
        buttonStyle(SolidButtonStyle.primary)
    }
    
    /// Apply button style with bordered background and AccentColor
    func borderAccentButtonStyle() -> some View {
        buttonStyle(BorderButtonStyle.accent)
    }
    
    /// Apply button style without background and text in AccentColor
    func noBackgroundAccentButtonStyle() -> some View {
        buttonStyle(NoBackgroundButtonStyle.accent)
    }
    
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
