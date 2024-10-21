//Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct DashboardView: View {
    @ObservedObject var viewModel: DashboardViewModel
    
    var body: some View {
        ResponsiveView { params in
            let targetWidth = params.landscape ? params.width * 0.23 : params.width * 0.45
            let targetHeight = params.height * 0.2
            let columns = createGridItems(width: params.width, targetWidth: targetWidth)
            
            return VStack(alignment: .center) {
                LazyVGrid(columns: columns, alignment: .center) {
                    ForEach(DashboardGoal.allCases, id: \.self) {goal in
                        DashboardGoalView(type: goal,
                                          width: targetWidth,
                                          height: targetHeight,
                                          viewModel: viewModel)
                    }
                }
                .padding(.bottom, 16)
                
                DashboardItemsStatsTable(vm: viewModel)
                    .padding(.top, 16)
                
                DashboardBidStatsTable(vm: viewModel)
                Spacer()
            }
            .padding()
        }
        .alert(viewModel.error, isPresented: $viewModel.showError) {
            
        }
    }
}
