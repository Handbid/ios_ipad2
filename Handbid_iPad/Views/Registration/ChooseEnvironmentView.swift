// Copyright (c) 2024 by Handbid. All rights reserved.

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

	@State private var environmentOptions = [
		EnvironmentOption(name: "Option 1", isSelected: false),
		EnvironmentOption(name: "Option 2", isSelected: false),
		EnvironmentOption(name: "Option 3", isSelected: false),
		EnvironmentOption(name: "Option 4", isSelected: false),
	]

	private func getListView() -> some View {
		VStack {
			List {
				Section(header: Text("Select Environment")) {
					ForEach(environmentOptions) { option in
						Button(action: {
							deselectAllOptions()
							selectOption(option)
						}) {
							HStack {
								Text(option.name)
								Spacer()
								Image(systemName: option.isSelected ? "checkmark.circle.fill" : "circle")
									.foregroundColor(.accentColor)
							}
						}
						.buttonStyle(PlainButtonStyle())
					}
				}
				.listRowBackground(Color.gray.opacity(0.2))
				.listRowInsets(EdgeInsets())
			}
			.background(Color.clear)
			.scrollDisabled(true)
			.listStyle(InsetGroupedListStyle())
			.frame(height: CGFloat(environmentOptions.count * 60))
		}
	}

	private func getButtons() -> some View {
		VStack(spacing: 10) {
			Button<Text>.styled(config: .secondaryButtonStyle, action: {
				// viewModel.openHandbidWebsite()
			}) {
				Text(LocalizedStringKey("Connect"))
					.textCase(.uppercase)
			}.accessibilityIdentifier("Connect")
		}
	}

	private func deselectAllOptions() {
		for index in environmentOptions.indices {
			environmentOptions[index].isSelected = false
		}
	}

	private func selectOption(_ option: EnvironmentOption) {
		if let index = environmentOptions.firstIndex(where: { $0.id == option.id }) {
			environmentOptions[index].isSelected = true
		}
	}
}

struct EnvironmentOption: Identifiable {
	let id = UUID()
	let name: String
	var isSelected: Bool
}
