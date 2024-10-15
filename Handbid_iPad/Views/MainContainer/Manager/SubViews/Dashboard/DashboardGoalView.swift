//Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI
import ProgressIndicatorView

enum DashboardGoal: CaseIterable, Hashable {
    case goal, bidders, guests, performance
    
    var title: LocalizedStringKey {
        switch self {
        case .goal: return .init("")
        case .bidders: return .init("")
        case .guests: return .init("")
        case .performance: return .init("")
        }
    }
    
    var isCurrency: Bool {
        switch self {
        case .goal: true
        default : false
        }
    }
    
    var color: Color {
        switch self {
        case .goal: .dashboardGoalProgress
        case .bidders: .dashboardBiddersProgress
        case .guests: .dashboardGuestsProgress
        case .performance: .dashboradPreformanceProgress
        }
    }
    
    func getProgress(from model: DashboardModel?) -> Double {
        switch self {
        case .goal: model?.overallRatio ?? 0.0
        case .bidders:
            Double(model?.biddersActive ?? 0) /
            Double(model?.biddersRegistered ?? 1)
        case .guests:
            Double(model?.guestsCheckedIn ?? 0) /
            Double(model?.guestsRegistered ?? 1)
        case .performance: model?.performanceRatio ?? 0.0
        }
    }
    
    func getProgressAmount(from model: DashboardModel?) -> String {
        switch self {
        case .goal: model?.overallRaised ?? ""
        case .bidders: String(model?.biddersActive ?? -1)
        case .guests: String(model?.guestsCheckedIn ?? -1)
        case .performance: model?.performanceRaised ?? ""
        }
    }
    
    func getProgressGoal(from model: DashboardModel?) -> String {
        switch self {
        case .goal: model?.overallGoal ?? ""
        case .bidders: String(model?.biddersRegistered ?? -1)
        case .guests: String(model?.guestsRegistered ?? -1)
        case .performance: model?.performanceFmv ?? ""
        }
    }
}

struct DashboardGoalView: View {
    var type: DashboardGoal
    @ObservedObject var viewModel: DashboardViewModel
    @State var progress: CGFloat = 0.5
    
    var body: some View {
        VStack {
            Text(type.title)
                .font(TypographyStyle.small.asFont())
                .fontWeight(.bold)
                .padding()
            
            HStack {
                ProgressIndicatorView(isVisible: .constant(true),
                                      type: .circle(
                                        progress: $progress,
                                        lineWidth: 9,
                                        strokeColor: type.color,
                                        backgroundColor: type.color.opacity(0.5)))
                
                VStack(alignment: .leading) {
                    Text(type.getProgressAmount(from: viewModel.dashboardModel))
                    
                    Text(type.getProgressGoal(from: viewModel.dashboardModel))
                }
            }
        }
        .background {
            RoundedRectangle(cornerRadius: 18.0)
                .foregroundStyle(.white)
        }
    }
}
