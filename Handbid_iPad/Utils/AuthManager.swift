// Copyright (c) 2024 by Handbid. All rights reserved.

import Foundation
import KeychainAccess
import SwiftUI

// MARK: - Represents a user's authentication token.

struct TokenUser: Codable {
	let validUntil: Date
	let id: UUID
	let value: String

	// MARK: Checks if the token is still valid based on the current date.

	var isValid: Bool { validUntil > Date() }
}

// MARK: - Custom errors for authentication failures.

enum AuthError: Error {
	case missingToken, invalidToken
}

// MARK: - A class responsible for managing authentication tasks.

class AuthManager: ObservableObject {
	@Published var currentToken: TokenUser?
	@Published private(set) var isLoggedIn: Bool = false
	private var refreshTask: Task<TokenUser, Error>?

	// MARK: Initializes the authentication process asynchronously.

	func initializeAsync() async {}

	// MARK: Checks the user's status by validating the current token.

	func checkUserStatus() async -> Bool {
		do {
			let keychain = Keychain(service: AppInfoProvider.bundleIdentifier)
			guard let tokenData = try keychain.getData("AuthDataUser"),
			      let token = try? JSONDecoder().decode(TokenUser.self, from: tokenData),
			      token.isValid
			else {
				clearKeychainAndLogOut(logOut: false)
				return false
			}

			currentToken = token
			return true
		}
		catch {
			print("Error decoding or refreshing token: \(error)")
            clearKeychainAndLogOut(logOut: false)
			return false
		}
	}

	// MARK: Asynchronously checks if the user is logged in.

	func isLoggedInAsync() async throws -> Bool {
		try await withCheckedThrowingContinuation { continuation in
			Task {
				do {
					let keychain = Keychain(service: AppInfoProvider.bundleIdentifier)
					guard let tokenData = try keychain.getData("AuthDataUser") else {
						throw AuthError.missingToken
					}

					let token = try JSONDecoder().decode(TokenUser.self, from: tokenData)
					continuation.resume(returning: token.isValid)
				}
				catch {
					continuation.resume(throwing: error)
				}
			}
		}
	}

	// MARK: Logs in the user with the provided authentication model.

	func loginWithAuthModel(auth: AuthModel) async -> Bool {
		guard let accessToken = auth.accessToken, isTokenValid(token: accessToken) else {
			return false
		}

		let expirationInterval = TimeInterval(auth.expiresIn ?? 0)
		currentToken = TokenUser(validUntil: Date().addingTimeInterval(expirationInterval), id: UUID(), value: accessToken)
		saveTokenToKeychain(currentToken!)
		return true
	}

    // MARK: Saves the user's token to the keychain securely.

    private func saveTokenToKeychain(_ token: TokenUser) {
        do {
            let keychain = Keychain(service: AppInfoProvider.bundleIdentifier)
            try keychain.remove("AuthDataUser")
            try keychain.synchronizable(true).set(JSONEncoder().encode(token), key: "AuthDataUser")
        }
        catch {
            print("Error saving token to Keychain: \(error)")
        }
    }

    // MARK: Logs out the user and clears any stored authentication data.

    private func clearKeychainAndLogOut(logOut: Bool) {
        do {
            try Keychain(service: AppInfoProvider.bundleIdentifier).remove("AuthDataUser")

            if (logOut){
                currentToken = nil
                isLoggedIn = false
            }
        }
        catch {
            print("Error clearing Keychain: \(error)")
        }
    }

    // MARK: Validates if the provided token is not empty.

    private func isTokenValid(token: String) -> Bool {
        !token.isEmpty
    }

	// MARK: Refreshes the user's token using the provided authentication model.

	private func refreshTokenWithAuth(auth _: AuthModel) async throws -> TokenUser {
		let tokenExpiresAt = Date().addingTimeInterval(3600) // 1 hour
		let newToken = TokenUser(validUntil: tokenExpiresAt, id: UUID(), value: "AuthDataUser")

		guard newToken.isValid else {
			throw AuthError.invalidToken
		}

		return newToken
	}
}

// MARK: - A subclass of `AuthManager` that uses the `MainActor` to perform UI-related tasks.

@MainActor
class AuthManagerMainActor: AuthManager {}
