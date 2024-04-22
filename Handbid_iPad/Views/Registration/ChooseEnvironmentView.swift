// Copyright (c) 2024 by Handbid. All rights reserved.

import NetworkService
import SwiftUI

struct ChooseEnvironmentView<T: PageProtocol>: View {
	@EnvironmentObject private var coordinator: Coordinator<T, Any?>
	@ObservedObject private var viewModel: ChooseEnvironmentViewModel
	@State private var isBlurred = false
	var inspection = Inspection<Self>()

	init(viewModel: ChooseEnvironmentViewModel) {
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
			backgroundView(for: .color(.accentViolet))
		}
		.onReceive(inspection.notice) {
			inspection.visit(self, $0)
		}
		.backButtonNavigation(style: .registration)
		.ignoresSafeArea(.keyboard, edges: .bottom)
	}

	private var content: some View {
		OverlayInternalView(cornerRadius: 40) {
			VStack {
				getLogoImage()
				getHeaderText()
				getListView()
				getButtons()
			}
			.blur(radius: isBlurred ? 10 : 0)
			.padding()
		}
	}

	private func getLogoImage() -> some View {
		Image("LogoSplash")
			.resizable()
			.scaledToFit()
			.frame(height: 50)
			.accessibilityIdentifier("AppLogo")
	}

	private func getHeaderText() -> some View {
		Text(LocalizedStringKey("registration_label_chooseEnvironmentToConnect"))
			.applyTextStyle(style: .headerTitle)
			.accessibilityIdentifier("registration_label_chooseEnvironmentToConnect")
	}

	private func getListView() -> some View {
		List {
			Section(header: Text(LocalizedStringKey("registration_label_selectEnvironment"))) {
				ForEach(viewModel.environmentOptions, id: \.self) { option in
					Button(action: {
						selectOption(option)
					}) {
						HStack {
							Text(option.rawValue)
								.foregroundColor(.primary)
							Spacer()
							if let selectedOption = viewModel.selectedOption, selectedOption == option {
								Image(systemName: "checkmark.circle.fill")
									.foregroundColor(.accentColor)
							}
							else {
								Image(systemName: "circle")
							}
						}
					}
					.buttonStyle(PlainButtonStyle())
				}
			}
			.listRowBackground(Color.gray.opacity(0.2))
		}
		.scrollContentBackground(.hidden)
		.scrollDisabled(true)
		.frame(height: CGFloat(viewModel.environmentOptions.count * 60))
	}

	private func getButtons() -> some View {
		VStack(spacing: 10) {
			Button<Text>.styled(config: .secondaryButtonStyle, action: {
				viewModel.saveEnvironment()
			}) {
				Text(LocalizedStringKey("registration_btn_save"))
					.textCase(.uppercase)
			}.accessibilityIdentifier("registration_btn_save")
		}
	}

	private func deselectAllOptions() {
		viewModel.selectedOption = nil
	}

	private func selectOption(_ option: AppEnvironmentType) {
		viewModel.selectedOption = option
	}
}

struct EnvironmentOption: Identifiable {
	let id = UUID()
	let name: String
	var isSelected: Bool
}
