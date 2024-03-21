//Copyright (c) 2024 by Handbid. All rights reserved.

import Foundation

enum AppEnvironment {
    case production
    case development
}

extension AppEnvironment {
    static var currentState: AppEnvironment {
        //Read status from setting
        return .development
    }
}

extension AppEnvironment {
    static var baseURL: String {
        switch AppEnvironment.currentState {
        case .production:
            return Servers.production
        case .development:
            return Servers.development
        }
    }
}

extension AppEnvironment {
    static var showLog: Bool {
        switch AppEnvironment.currentState {
        case .production:
            return false
        case .development:
            return true
        }
    }
}
