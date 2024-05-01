// Copyright (c) 2024 by Handbid. All rights reserved.

import NetworkService
import SwiftUI

struct ChooseOrganizationView<T: PageProtocol>: View {
	@EnvironmentObject private var coordinator: Coordinator<T, Any?>
	@ObservedObject private var viewModel: ChooseOrganizationViewModel
	@State private var isButtonDisabled = true
	@Environment(\.colorScheme) var colorScheme
	@State private var contentLoaded = false
	@State private var isBlurred = false
	@FocusState var focusedField: Field?
	var inspection = Inspection<Self>()

	init(viewModel: ChooseOrganizationViewModel) {
		self.viewModel = viewModel
	}

	var body: some View {
		ZStack {
			if contentLoaded { content } else { content }
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

	private var content: some View {
		OverlayInternalView(cornerRadius: 40) {
			VStack {
				getHeaderText()
				getListView()
				getButtons()
			}
			.blur(radius: isBlurred ? 10 : 0)
			.padding()
		}
	}

	private func getHeaderText() -> some View {
		Text(LocalizedStringKey("chooseOrg_label_selectOrganization"))
			.applyTextStyle(style: .body)
			.accessibilityIdentifier("chooseOrg_label_selectOrganization")
	}

	private func getListView() -> some View {
		VStack(spacing: 0) {
			FormField(fieldType: .searchBar,
			          labelKey: LocalizedStringKey("chooseOrg_label_searchByName"),
			          hintKey: LocalizedStringKey("chooseOrg_label_searchByName"),
			          fieldValue: $viewModel.searchOrganization,
			          focusedField: _focusedField)
				.padding([.leading, .trailing], 30)
			List {
				ForEach(viewModel.filteredOrganizations, id: \.id) { organization in
					Button(action: {
						selectOption(organization)
					}) {
						HStack {
							Text(organization.name ?? "Unknown")
								.foregroundColor(colorScheme == .dark ? Color.black : Color.black)
							Spacer()
							if let selectedOption = viewModel.selectedOrganization?.id, selectedOption == organization.id {
								Image(systemName: "checkmark.circle.fill")
									.foregroundColor(.accentColor)
							}
						}
						.padding([.leading, .trailing], 10)
						.frame(height: 50)
						.contentShape(Rectangle())
						.overlay(
							RoundedRectangle(cornerRadius: 10)
								.stroke(organization.id == viewModel.selectedOrganization?.id ? Color.accentColor : Color.gray, lineWidth: organization.id == viewModel.selectedOrganization?.id ? 2 : 1)
						)
						.onTapGesture {
							selectOption(organization)
						}
					}
				}
				.listRowSeparator(.hidden)
				.listRowBackground(Color.white)
			}
			.scrollIndicators(.hidden)
			.scrollContentBackground(.hidden)
			.frame(height: CGFloat(5 * 60))
		}
	}

	private func getButtons() -> some View {
		VStack(spacing: 10) {
			Button<Text>.styled(config: .secondaryButtonStyle, isDisabled: $isButtonDisabled, action: {
				isBlurred = true
				coordinator.push(MainContainerPage.chooseAuction as! T)
			}) {
				Text(LocalizedStringKey("chooseOrg_btn_selectOrg"))
					.textCase(.uppercase)
			}.accessibilityIdentifier("chooseOrg_btn_selectOrg")
				.disabled(viewModel.selectedOrganization == nil)
		}
	}

	private func deselectAllOptions() {
		viewModel.selectedOrganization = nil
	}

	func selectOption(_ option: OrganizationModel) {
		viewModel.selectedOrganization = (viewModel.selectedOrganization?.id == option.id) ? nil : option
		isButtonDisabled = viewModel.selectedOrganization == nil
	}
}
