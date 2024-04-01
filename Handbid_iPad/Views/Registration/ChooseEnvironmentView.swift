// Copyright (c) 2024 by Handbid. All rights reserved.

import NetworkService
import SwiftUI

struct ChooseEnvironmentView<T: PageProtocol>: View {
	@EnvironmentObject private var coordinator: Coordinator<T, Any?>
	@ObservedObject private var viewModel = ChooseEnvironmentViewModel()

	var body: some View {
		ZStack {
			OverlayInternalView(cornerRadius: 40) {
				VStack {
					getLogoImage()
					getHeaderText()
					getListView()
					getButtons()
				}.padding()
			}
		}.background {
			backgroundImageView(for: .registrationWelcome)
		}
		.backButtonNavigation(style: .registration)
		.ignoresSafeArea()
	}

	private func getLogoImage() -> some View {
		Image("LogoSplash")
			.resizable()
			.scaledToFit()
			.frame(height: 50)
			.onLongPressGesture(minimumDuration: 0.5) {
				coordinator.push(RegistrationPage.chooseEnvironment as! T)
			}
			.accessibilityIdentifier("AppLogo")
	}

	private func getHeaderText() -> some View {
		Text(LocalizedStringKey("Choose Environment to connect"))
			.applyTextStyle(style: .headerTitle)
			.accessibilityIdentifier("ChooseEnvironmentToConnect")
	}

	private func getListView() -> some View {
		List {
			Section(header: Text("Select Environment")) {
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
				// viewModel.openHandbidWebsite()
			}) {
				Text(LocalizedStringKey("Save"))
					.textCase(.uppercase)
			}.accessibilityIdentifier("Save")
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
