// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct ChooseAuctionView<T: PageProtocol>: View {
	@EnvironmentObject private var coordinator: Coordinator<T, Any?>
	@ObservedObject private var viewModel: ChooseAuctionViewModel
	@State private var selectedView: SelectAuctionContainerTypeView
	@State private var isBlurred = false
	private var deviceContext = DeviceContext()
	var inspection = Inspection<Self>()

	@State private var isSelected: [String: Bool] = [
		"open": false,
		"presale": false,
		"preview": false,
		"closed": false,
		"reconciled": false,
		"all": false,
	]

	// Define custom colors using RGB
	let customColors = [
		"green": Color(red: 0.0, green: 0.5, blue: 0.0),
		"pink": Color(red: 1.0, green: 0.75, blue: 0.8),
		"orange": Color(red: 1.0, green: 0.55, blue: 0.0),
		"red": Color(red: 1.0, green: 0.0, blue: 0.0),
		"blue": Color(red: 0.0, green: 0.0, blue: 1.0),
	]

	init(viewModel: ChooseAuctionViewModel, selectedView: SelectAuctionContainerTypeView) {
		self.viewModel = viewModel
		self.selectedView = selectedView
	}

	var body: some View {
		VStack(spacing: 0) {
			TopBar(content: topBarContent(for: selectedView), barHeight: 60)

			// Adding horizontal button list under the TopBar
			ScrollView(.horizontal, showsIndicators: false) {
				HStack(spacing: 10) {
					ForEach(isSelected.sorted(by: { $0.key < $1.key }), id: \.key) { item in
						Button(action: {
							isSelected[item.key]!.toggle()
						}) {
							iconView(color: customColors[iconColor(name: item.key)]!, isSelected: isSelected[item.key]!, label: item.key.capitalized)
						}
					}
				}
				.padding()
			}

			Spacer()
		}
		.background(Color.red)
	}

	private func iconView(color: Color, isSelected: Bool, label: String) -> some View {
		HStack {
			Circle()
				.fill(color)
				.frame(width: 40, height: 40)
				.overlay(
					Image(systemName: "checkmark")
						.foregroundColor(isSelected ? .white : .clear)
				)
			Text(label)
				.font(.caption)
				.foregroundColor(.black)
		}
	}

	private func iconView(color: Color, isSelected: Bool) -> some View {
		VStack {
			Circle()
				.fill(color)
				.frame(width: 40, height: 40)
				.overlay(
					Image(systemName: "checkmark")
						.foregroundColor(isSelected ? .white : .clear)
				)
		}
	}

	private func iconColor(name: String) -> String {
		switch name {
		case "open", "all":
			"green"
		case "presale":
			"pink"
		case "preview":
			"orange"
		case "closed":
			"red"
		case "reconciled":
			"blue"
		default:
			"green"
		}
	}

	private func topBarContent(for viewType: SelectAuctionContainerTypeView) -> TopBarContent {
		switch viewType {
		case .selectAuction:
			GenericTopBarContentFactory(viewModel: viewModel, deviceContext: deviceContext).createTopBarContentWithoutLogo()
		}
	}
}
