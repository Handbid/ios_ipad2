// Copyright (c) 2024 by Handbid. All rights reserved.

import NetworkService
import SwiftUI

struct ChooseOrganizationView<T: PageProtocol>: View {
	@EnvironmentObject private var coordinator: Coordinator<T, Any?>
	@ObservedObject private var viewModel: ChooseOrganizationViewModel
	@Environment(\.colorScheme) var colorScheme
	@State private var isButtonDisabled = true
	@State private var contentLoaded = false
	@State private var isBlurred = false
	@FocusState private var focusedField: Field?
	var inspection = Inspection<Self>()

	init(viewModel: ChooseOrganizationViewModel) {
		self.viewModel = viewModel
	}

	var body: some View {
		ZStack {
			if contentLoaded { contentView } else { contentView }
		}
		.onAppear {
			isBlurred = false
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
				contentLoaded = true
			}
			viewModel.fetchOrganizationsIfNeeded()
		}
		.background {
			backgroundView(for: .color(colorScheme == .dark ? Color.black.opacity(0.7) : Color.accentViolet.opacity(0.7)))
		}
		.onTapGesture {
			hideKeyboard()
		}
		.onReceive(inspection.notice) {
			inspection.visit(self, $0)
		}
		.keyboardResponsive()
		.navigationBarBackButtonHidden()
		.ignoresSafeArea(.keyboard, edges: .bottom)
	}

	private var contentView: some View {
		OverlayInternalView(cornerRadius: 40) {
			VStack {
				headerText
				listView
				buttons
			}
			.blur(radius: isBlurred ? 10 : 0)
			.padding()
		}
	}

	private var headerText: some View {
		Text(LocalizedStringKey("chooseOrg_label_selectOrganization"))
			.applyTextStyle(style: .body)
			.accessibilityIdentifier("chooseOrg_label_selectOrganization")
	}

	private var listView: some View {
		VStack(spacing: 0) {
			searchBar
			organizationList
		}
	}

	private var searchBar: some View {
		FormField(
			fieldType: .searchBar,
			labelKey: LocalizedStringKey("chooseOrg_label_searchByName"),
			hintKey: LocalizedStringKey("chooseOrg_label_searchByName"),
			fieldValue: $viewModel.searchOrganization,
			focusedField: _focusedField
		)
		.padding([.leading, .trailing], 30)
	}

	private var organizationList: some View {
		List {
			ForEach(viewModel.filteredOrganizations, id: \.identity) { organization in
				OrganizationRow(
					organization: organization,
					isSelected: viewModel.selectedOrganization?.identity == organization.identity,
					colorScheme: colorScheme,
					selectAction: selectOption
				)
			}
			.listRowSeparator(.hidden)
			.listRowBackground(Color.white)
		}
		.scrollIndicators(.hidden)
		.scrollContentBackground(.hidden)
		.frame(height: CGFloat(5 * 60))
	}

	private var buttons: some View {
		VStack(spacing: 10) {
			selectOrganizationButton
		}
	}

	private var selectOrganizationButton: some View {
		Button<Text>.styled(config: .secondaryButtonStyle, isDisabled: $isButtonDisabled, action: {
			isBlurred = true
			coordinator.push(MainContainerPage.chooseAuction as! T, with: viewModel.selectedOrganization)
		}) {
			Text(LocalizedStringKey("chooseOrg_btn_selectOrg"))
				.textCase(.uppercase)
		}
		.accessibilityIdentifier("chooseOrg_btn_selectOrg")
		.disabled(viewModel.selectedOrganization == nil)
	}

	private func selectOption(_ option: OrganizationModel) {
		viewModel.selectedOrganization = (viewModel.selectedOrganization?.identity == option.identity) ? nil : option
		isButtonDisabled = viewModel.selectedOrganization == nil
	}
}

struct OrganizationRow: View {
	let organization: OrganizationModel
	let isSelected: Bool
	let colorScheme: ColorScheme
	let selectAction: (OrganizationModel) -> Void

	var body: some View {
		Button(action: {
			selectAction(organization)
		}) {
			HStack {
				Text(organization.name ?? "Unknown")
					.foregroundColor(colorScheme == .dark ? Color.black : Color.black)
				Spacer()
				if isSelected {
					Image(systemName: "checkmark.circle.fill")
						.foregroundColor(.accentColor)
				}
			}
			.padding([.leading, .trailing], 10)
			.frame(height: 50)
			.contentShape(Rectangle())
			.overlay(
				RoundedRectangle(cornerRadius: 10)
					.stroke(isSelected ? Color.accentColor : Color.gray, lineWidth: isSelected ? 2 : 1)
			)
		}
		.onTapGesture {
			selectAction(organization)
		}
	}
}
