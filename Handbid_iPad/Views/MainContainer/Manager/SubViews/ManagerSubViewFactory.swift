//Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI
import NetworkService

struct ManagerSubViewFactory: View {
    @ObservedObject var viewModel: ManagerViewModel
    private let network = DependencyMainAppProvider.shared.networkClient
    
    var body: some View {
        switch viewModel.selectedTab {
        case .dashboard:
            let repository = DashboardRepositoryImpl(network: network)
            let viewModel = DashboardViewModel(dashboardRepository: repository)
            DashboardView(viewModel: viewModel)
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
