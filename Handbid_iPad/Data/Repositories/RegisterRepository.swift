// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import Foundation
import NetworkService
import RecaptchaEnterprise
import Arrow

protocol RegisterRepository {
    func getAppVersion() -> AnyPublisher<AppVersionModel, Error>
    func getReCaptchaToken() -> AnyPublisher<String, Error>
}

protocol LogInAnonymously {
    func logInAnonymously() -> AnyPublisher<AppVersionModel, Error>
}

class RegisterRepositoryImpl: RegisterRepository, LogInAnonymously, NetworkingService {

    var network: NetworkService.NetworkingClient
    private var recaptchaClient: RecaptchaClient?
    private var recaptchaToken = ""
    
    init(_ network: NetworkService.NetworkingClient) {
        self.network = network
    }
    
    private func getClientReCaptcha() async throws -> RecaptchaClient {
        return try await Recaptcha.getClient(withSiteKey: AppInfoProvider.captchaKey)
    }
    
    private func getTokenReCapcha(client: RecaptchaClient) async throws -> String {
        return try await client.execute(withAction: RecaptchaAction.login)
    }
    
    func getReCaptchaToken() -> AnyPublisher<String, Error>
    {
        return Future { promise in
            Task {
                do {
                    self.recaptchaClient = try await self.getClientReCaptcha()
                    self.recaptchaToken = try await self.getTokenReCapcha(client: self.recaptchaClient!)
                    promise(.success(self.recaptchaToken))
                } catch {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func logInAnonymously() -> AnyPublisher<AppVersionModel, Error> {
        get(ApiEndpoints.getAppVersion, params: ["appName": AppInfoProvider.appName,
                                                 "os": AppInfoProvider.os,
                                                 "whitelabelId": AppInfoProvider.whitelabelId])
        .tryMap { try AppVersionModel.decode($0) }
        .eraseToAnyPublisher()
    }
    
    func getAppVersion() -> AnyPublisher<AppVersionModel, Error> {
        get(ApiEndpoints.getAppVersion, params: ["appName": AppInfoProvider.appName,
                                                 "os": AppInfoProvider.os,
                                                 "whitelabelId": AppInfoProvider.whitelabelId])
        .tryMap { try AppVersionModel.decode($0) }
        .eraseToAnyPublisher()
    }
}
