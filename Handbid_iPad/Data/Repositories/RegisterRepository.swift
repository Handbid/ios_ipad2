// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import Foundation
import NetworkService
import RecaptchaEnterprise
import Arrow

protocol RegisterRepository {
    func getAppVersion() -> AnyPublisher<AppVersionModel, Error>
    func logIn(email: String, password: String?, pin: String?) -> AnyPublisher<AuthModel, Error>
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
    
    func getClientReCaptcha(){
        Task {
            do {
                let client = try await Recaptcha.getClient(withSiteKey: AppInfoProvider.captchaKey)
                self.recaptchaClient = client
            } catch let error as RecaptchaError {
                print("RecaptchaClient creation error: \(String(describing: error.errorMessage)).")
                return
            }
        }
    }
    
    func getTokenReCapcha(){
        guard let recaptchaClient = self.recaptchaClient else {
            print("Client not initialized correctly.")
            return
        }
        
        Task {
            do {
                let token = try await recaptchaClient.execute(withAction: RecaptchaAction.login)
                print(token)
            } catch let error as RecaptchaError {
                return
            }
        }
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
    
    func logIn(email: String, password: String?, pin: String?) -> AnyPublisher<AuthModel, Error> {
        
        var params: Params = ["username": email,
                              "captchaToken": recaptchaToken,
                              "client_id": AppInfoProvider.os,
                              "client_secret": AppInfoProvider.authClientSecret,
                              "grant_type": GrantType.password.rawValue,
                              "captchaKey": AppInfoProvider.captchaKey,
                              "whitelabelId": AppInfoProvider.whitelabelId]
        
        if let password = password {
            params["password"] = password
        }
        
        if let pin = pin {
            params["pin"] = pin
        }
        
        return post(ApiEndpoints.logInUser, params: params)
            .tryMap { try AuthModel.decode($0) }
            .map { $0 }
            .eraseToAnyPublisher()
    }
}
