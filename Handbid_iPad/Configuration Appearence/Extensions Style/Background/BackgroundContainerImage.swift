// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

enum BackgroundContainerImage: String {
	case registrationWelcome = "SplashBackground"
	case anotherImage
}

enum BackgroundContainer {
    case image(BackgroundContainerImage)
    case color(Color)
}
