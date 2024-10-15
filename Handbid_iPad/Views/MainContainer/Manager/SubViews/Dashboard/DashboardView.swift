//Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct DashboardView: View {
    @ObservedObject var viewModel: DashboardViewModel
    
    var body: some View {
        HStack {
            ForEach(DashboardGoal.allCases, id: \.self) {goal in
                DashboardGoalView(type: goal, viewModel: viewModel)
            }
        }
    }
}
