//Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct EmptyAuctionView<T: PageProtocol>: View {
    @EnvironmentObject private var coordinator: Coordinator<T, Any?>
    @EnvironmentObject var authManager: AuthManager

    var body: some View {
        Button("log out") {
            authManager.clearKeychainAndLogOut(logOut: true)
        }
    }
}
