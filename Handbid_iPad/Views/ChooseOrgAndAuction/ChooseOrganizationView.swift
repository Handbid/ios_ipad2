// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct ChooseOrganizationView<T: PageProtocol>: View {
	@EnvironmentObject private var coordinator: Coordinator<T, Any?>
	@ObservedObject private var viewModel: ChooseOrganizationViewModel
	@State private var isBlurred = false
	@FocusState var focusedField: Field?

	var inspection = Inspection<Self>()

	init(viewModel: ChooseOrganizationViewModel) {
		self.viewModel = viewModel
	}

	var body: some View {
		ZStack {
			content
		}
		.onAppear {
			isBlurred = false
		}
		.background {
			backgroundView(for: .color(.accentViolet.opacity(0.7)))
		}
		.onTapGesture {
			hideKeyboard()
		}
		.onReceive(inspection.notice) {
			inspection.visit(self, $0)
		}
		.keyboardResponsive()
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
				ForEach(viewModel.environmentOptions, id: \.self) { option in
					Button(action: {
						// selectOption(option) would be implemented here
					}) {
						HStack {
							Text(option.rawValue)
								.foregroundColor(.primary)
							Spacer()
							if let selectedOption = viewModel.selectedOption, selectedOption == option {
								Image(systemName: "checkmark.circle.fill")
									.foregroundColor(.accentColor)
							}
						}
						.padding([.leading, .trailing], 10)
						.frame(height: 50)
						.overlay(
							RoundedRectangle(cornerRadius: 10)
								.stroke(option == viewModel.selectedOption ? Color.accentColor : Color.accentGrayBorder,
								        lineWidth: option == viewModel.selectedOption ? 2 : 1)
						)
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
			Button<Text>.styled(config: .secondaryButtonStyle, action: {
				viewModel.saveEnvironment()
			}) {
				Text(LocalizedStringKey("chooseOrg_btn_selectOrg"))
					.textCase(.uppercase)
			}.accessibilityIdentifier("chooseOrg_btn_selectOrg")
		}
	}

	private func deselectAllOptions() {
		viewModel.selectedOption = nil
	}

	//    private func selectOption(_ option: AppEnvironmentType) {
	//        viewModel.selectedOption = option
	//    }
}
