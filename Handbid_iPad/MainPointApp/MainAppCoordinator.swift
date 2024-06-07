// Copyright (c) 2024 by Handbid. All rights reserved.

import Foundation
import NetworkService
import SwiftUI

@main
struct MainAppCoordinator: App {
	@UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

	@StateObject private var registrationCoordinator: Coordinator<RegistrationPage, Any?>
	@StateObject private var mainContainerCoordinator: Coordinator<MainContainerPage, Any?>
	private let dataManager: DataManager

	init() {
		let deps = DependencyMainAppProvider.shared
		self.dataManager = DataManager.shared

		let registrationCoordinator = MainAppCoordinator.createRegistrationCoordinator(deps: deps)
		let mainContainerCoordinator = MainAppCoordinator.createMainContainerCoordinator(deps: deps, dataManager: dataManager)

		_registrationCoordinator = StateObject(wrappedValue: registrationCoordinator)
		_mainContainerCoordinator = StateObject(wrappedValue: mainContainerCoordinator)
	}

	static func createRegistrationCoordinator(deps: DependencyMainAppProvider) -> Coordinator<RegistrationPage, Any?> {
		Coordinator<RegistrationPage, Any?> { page in
			switch page {
			case .getStarted:
				let repository = RegisterRepositoryImpl(deps.networkClient)
				let viewModel = GetStartedViewModel(repository: repository)
				return AnyView(GetStartedView<RegistrationPage>(viewModel: viewModel))
			case .logIn:
				let repository = RegisterRepositoryImpl(deps.networkClient)
				let viewModel = LogInViewModel(repository: repository, authManager: deps.authManager)
				return AnyView(LogInView<RegistrationPage>(viewModel: viewModel))
			case .chooseEnvironment:
				return AnyView(ChooseEnvironmentView<RegistrationPage>(viewModel: ChooseEnvironmentViewModel(deps.networkClient)))
			case .forgotPassword:
				let repository = ResetPasswordRepositoryImpl(deps.networkClient)
				let viewModel = ForgotPasswordViewModel(repository: repository)
				return AnyView(ForgotPasswordView<RegistrationPage>(viewModel: viewModel))
			case .resetPasswordConfirmation:
				return AnyView(PasswordResetConfirmationView<RegistrationPage>())
			}
		}
	}

	static func createMainContainerCoordinator(deps: DependencyMainAppProvider, dataManager: DataManager) -> Coordinator<MainContainerPage, Any?> {
		Coordinator<MainContainerPage, Any?> { page in
			switch page {
			case .chooseOrganization:
				let repository = ChooseOrganizationRepositoryImpl(deps.networkClient)
				let viewModel = ChooseOrganizationViewModel(repository: repository, dataManager: dataManager)
				return AnyView(ChooseOrganizationView<MainContainerPage>(viewModel: viewModel))
			case .chooseAuction:
				let repository = ChooseAuctionRepositoryImpl(deps.networkClient)
				let viewModel = ChooseAuctionViewModel(repository: repository, dataManager: dataManager)
				return AnyView(ChooseAuctionView<MainContainerPage>(viewModel: viewModel, selectedView: .selectAuction))
			case .mainContainer:
				return AnyView(MainContainer<MainContainerPage>(selectedView: .auction))
			case .searchItems:
				return AnyView(MainContainer<MainContainerPage>(selectedView: .searchItems))
			}
		}
	}

	var body: some Scene {
		WindowGroup {
			AppLaunchControlView()
				.environmentObject(AuthManagerMainActor() as AuthManager)
				.environmentObject(registrationCoordinator)
				.environmentObject(mainContainerCoordinator)
				.environment(\.dataManager, dataManager)
		}
	}
}
