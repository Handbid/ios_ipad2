//Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct ManagerSubViewFactory: View {
    @ObservedObject var viewModel: ManagerViewModel
    
    var body: some View {
        switch viewModel.selectedTab {
        case .dashboard:
            DashboardView()
        case .guestList:
            GuestListView()
        case .live:
            LiveView()
        case .activity:
            ActivityView()
        case .stream:
            StreamView()
        case .appeals:
            AppealsView()
        }
    }
}
