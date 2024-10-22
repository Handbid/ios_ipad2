// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import SwiftUI

struct ItemsStatsRow: Identifiable {
	var id: Int
	var label: String
	var silent: String
	var live: String
	var purchases: String
	var donations: String
	var tickets: String
	var total: String
}

struct DashboardItemsStatsTable: View {
	@ObservedObject var viewModel: DashboardViewModel
	@State private var rows: [ItemsStatsRow] = []

	init(vm: DashboardViewModel) {
		self.viewModel = vm
		createRows(from: vm.dashboardModel)
	}

	var body: some View {
		Table(rows) {
			TableColumn("") { row in
				Text(row.label)
					.fontWeight(.bold)
					.textCase(.uppercase)
			}
			TableColumn("dashboard_label_silent", value: \.silent)
			TableColumn("manager_label_live", value: \.live)
			TableColumn("dashboard_label_purchases", value: \.purchases)
			TableColumn("dashboard_label_donations", value: \.donations)
			TableColumn("dashboard_label_tickets", value: \.tickets)
			TableColumn("dashboard_label_total", value: \.total)
		}
		.onReceive(viewModel.$dashboardModel) { model in
			createRows(from: model)
		}
		.scrollContentBackground(.hidden)
	}

	private func createRows(from model: DashboardModel?) {
		let silentCount = model?.itemsSilent ?? 0
		let liveCount = model?.itemsLive ?? 0
		let purchaseCount = model?.itemsPurchase ?? 0
		let donationsCount = model?.itemsDonation ?? 0
		let ticketsCount = model?.itemsTicket ?? 0

		rows = [
			ItemsStatsRow(id: 1,
			              label: String(localized: "dashboard_label_items"),
			              silent: String(silentCount),
			              live: String(liveCount),
			              purchases: String(purchaseCount),
			              donations: String(donationsCount),
			              tickets: String(ticketsCount),
			              total: String(silentCount + liveCount +
			              	purchaseCount + donationsCount + ticketsCount)),
			ItemsStatsRow(id: 2,
			              label: String(localized: "dashboard_label_revenue"),
			              silent: model?.revenueSilent ?? "",
			              live: model?.revenueLive ?? "",
			              purchases: model?.revenuePurchase ?? "",
			              donations: model?.revenueDonation ?? "",
			              tickets: model?.revenueTicket ?? "",
			              total: model?.revenueTotal ?? ""),
		]
	}
}
