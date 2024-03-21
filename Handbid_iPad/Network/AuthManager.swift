//Copyright (c) 2024 by Handbid. All rights reserved.

import Foundation
import KeychainAccess
import SwiftUI

struct TokenUser: Codable {
    let validUntil: Date
    let id: UUID
    let value: String
    
    var isValid: Bool { validUntil > Date() }
}

enum AuthError: Error {
    case missingToken, invalidToken
}

@MainActor
class AuthManagerMainActor: AuthManager {}

class AuthManager: ObservableObject {
    
    @Published var currentToken: TokenUser?
    @Published private(set) var isLoggedIn: Bool = false
    private var refreshTask: Task<TokenUser, Error>?
    
    func initializeAsync() async {}
    
    func checkUserStatus() async -> Bool {
        do {
            guard let tokenData = try? Keychain(service: AppGlobal.bundleIdentifier).getData("AuthDataUser"),
                  let token = try? JSONDecoder().decode(TokenUser.self, from: tokenData),
                  token.isValid else {
                clearKeychain()
                return false
            }
            
            currentToken = token
            return true
        } catch {
            print("Error decoding or refreshing token: \(error)")
            clearKeychain()
            return false
        }
    }
    
    func isLoggedInAsync() async throws -> Bool {
        return try await withCheckedThrowingContinuation { continuation in
            Task {
                do {
                    guard let tokenData = try? Keychain(service: AppGlobal.bundleIdentifier).getData("AuthDataUser") else {
                        throw AuthError.missingToken
                    }
                    
                    let token = try JSONDecoder().decode(TokenUser.self, from: tokenData)
                    continuation.resume(returning: token.isValid)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func saveTokenToKeychain(_ token: TokenUser) {
        do {
            let keychain = Keychain(service: AppGlobal.bundleIdentifier)
            try keychain.remove("AuthDataUser")
            try keychain.synchronizable(true).set(try JSONEncoder().encode(token), key: "AuthDataUser")
        } catch {
            print("Error saving token to Keychain: \(error)")
        }
    }
    
    func clearKeychain() {
        do {
            try Keychain(service: AppGlobal.bundleIdentifier).remove("AuthDataUser")
        } catch {
            print("Error clearing Keychain: \(error)")
        }
    }
    
    func isTokenValid(token: String) -> Bool {
        return !token.isEmpty
    }
    
    func loginWithAuthModel(auth: AuthModel) async -> Bool {
        do {
            guard let accessToken = auth.accessToken, isTokenValid(token: accessToken) else {
                return false
            }
            
            currentToken = TokenUser(validUntil: Date().addingTimeInterval(TimeInterval(auth.expiresIn ?? 0)), id: UUID(), value: accessToken)
            saveTokenToKeychain(currentToken!)
            return true
        } catch {
            print("Error logging in: \(error)")
            clearKeychain()
            return false
        }
    }
    
    private func refreshTokenWithAuth(auth: AuthModel) async throws -> TokenUser {
        let tokenExpiresAt = Date().addingTimeInterval(3600) // 1 hour
        let newToken = TokenUser(validUntil: tokenExpiresAt, id: UUID(), value: "AuthDataUser")
        
        guard newToken.isValid else {
            throw AuthError.invalidToken
        }
        
        return newToken
    }
    
    func logOut() {
        do {
            try Keychain(service: AppGlobal.bundleIdentifier).remove("AuthDataUser")
            currentToken = nil
            isLoggedIn = false
        } catch {
            print("Error clearing Keychain: \(error)")
        }
    }
}
