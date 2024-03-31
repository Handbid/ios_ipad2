// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import NetworkService

class GetStartedViewModel: ObservableObject {
	private var cancellables = Set<AnyCancellable>()
	private var repository: RegisterRepository = RegisterRepositoryImpl(NetworkingClient())
}
