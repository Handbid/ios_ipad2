//Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI
import ProgressIndicatorView
import Combine

enum DashboardGoal: CaseIterable, Hashable {
    case goal, bidders, guests, performance
    
    var title: LocalizedStringKey {
        switch self {
        case .goal: return .init("dashboard_label_overallGoal")
        case .bidders: return .init("dashboard_label_bidders")
        case .guests: return .init("dashboard_label_guests")
        case .performance: return .init("dashboard_label_auctionPerformance")
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
    
    var progressAmountLabel: LocalizedStringKey {
        switch self {
        case .goal: .init("dashboard_label_raised")
        case .bidders: .init("dashboard_label_active")
        case .guests: .init("dashboard_label_checkedIn")
        case .performance: .init("dashboard_label_raised")
        }
    }
    
    var progressGoalLabel: LocalizedStringKey {
        switch self {
        case .goal: .init("dashboard_label_goal")
        case .bidders: .init("dashboard_label_registered")
        case .guests: .init("dashboard_label_registered")
        case .performance: .init("dashboard_label_fmv")
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
    var width: CGFloat
    var height: CGFloat
    @ObservedObject var viewModel: DashboardViewModel
    @State var progress: CGFloat = 0.5
    
    var body: some View {
        VStack {
            Text(type.title)
                .font(TypographyStyle.small.asFont())
                .fontWeight(.bold)
                .padding()
            
            HStack {
                ZStack(alignment: .center) {
                    ProgressIndicatorView(isVisible: .constant(true),
                                          type: .circle(
                                            progress: $progress,
                                            lineWidth: 9,
                                            strokeColor: type.color,
                                            backgroundColor: type.color.opacity(0.5)))
                    .padding()
                    
                    Text(progress, format: .percent.precision(
                        .fractionLength(0))
                        .rounded(rule: .toNearestOrEven)
                    )
                        .font(TypographyStyle.regular.asFont())
                        .fontWeight(.bold)
                }
                .frame(maxWidth: .infinity)
                
                VStack(alignment: .leading) {
                    Text(type.getProgressAmount(from: viewModel.dashboardModel))
                        .font(TypographyStyle.regular.asFont())
                        .fontWeight(.bold)
                        .foregroundStyle(.bodyText)
                        .padding(.bottom, 4)
                    
                    Text(type.progressAmountLabel)
                        .font(TypographyStyle.small.asFont())
                        .textCase(.uppercase)
                        .foregroundStyle(.managerTab)
                        .padding(.bottom, 8)
                    
                    Text(type.getProgressGoal(from: viewModel.dashboardModel))
                        .font(TypographyStyle.regular.asFont())
                        .fontWeight(.bold)
                        .foregroundStyle(.bodyText)
                        .padding(.bottom, 4)
                    
                    Text(type.progressGoalLabel)
                        .font(TypographyStyle.small.asFont())
                        .textCase(.uppercase)
                        .foregroundStyle(.managerTab)
                        .padding(.bottom, 8)
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.all, 16)
            .background {
                RoundedRectangle(cornerRadius: 18.0)
                    .foregroundStyle(.white)
            }
        }
        .frame(width: width, height: height)
        .padding(.all, 8)
        .onReceive(viewModel.$dashboardModel) { model in
            progress = type.getProgress(from: model)
        }
        .onAppear {
            progress = type.getProgress(from: viewModel.dashboardModel)
        }
    }
}
