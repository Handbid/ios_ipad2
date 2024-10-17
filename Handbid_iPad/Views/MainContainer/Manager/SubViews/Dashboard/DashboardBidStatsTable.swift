//Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI
import Combine

struct BidStatsRow: Identifiable {
    var id: Int
    var label: String
    var itemsNoBids: String
    var biddersNoBids: String
    var bidPerBidder: String
}

struct DashboardBidStatsTable: View {
    @ObservedObject var viewModel: DashboardViewModel
    @State private var row: BidStatsRow? = nil
    
    init(vm: DashboardViewModel) {
        viewModel = vm
        createRow(from: vm.dashboardModel)
    }
    
    var body: some View {
        Table(of: BidStatsRow.self) {
            TableColumn("") { row in
                Text(row.label)
                    .fontWeight(.bold)
            }
            TableColumn("dashboard_label_itemsNoBids", value: \.itemsNoBids)
            TableColumn("dashboard_label_biddersNoBids", value: \.biddersNoBids)
            TableColumn("dashboard_label_bidPerBidder", value: \.bidPerBidder)
        } rows: {
            if let row = self.row {
                TableRow(row)
            }
        }
        .onReceive(viewModel.$dashboardModel) { model in
            createRow(from: model)
        }
        .scrollContentBackground(.hidden)
    }
    
    private func createRow(from model: DashboardModel?) {
        row = BidStatsRow(id: 1,
                          label: String(localized: "dashboard_label_bidStats"),
                          itemsNoBids: String(model?.itemsNoBids ?? 0),
                          biddersNoBids: String(model?.bidderNoBids ?? 0),
                          bidPerBidder: String(format: "%.2f", model?.bidsPerBidders ?? 0.0)
        )
    }
}
