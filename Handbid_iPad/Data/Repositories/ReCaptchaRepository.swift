// Copyright (c) 2024 by Handbid. All rights reserved.


class ReCaptchaRepository {
	private var recaptchaClient: RecaptchaClient?
	private var recaptchaToken = ""

	private func getClientReCaptcha() async throws -> RecaptchaClient {
		try await Recaptcha.getClient(withSiteKey: AppInfoProvider.captchaKey)
	}

	private func getTokenReCapcha(client: RecaptchaClient) async throws -> String {
		try await client.execute(withAction: RecaptchaAction.login)
	}

    func getReCaptchaToken() async throws -> String {
        do {
            if recaptchaClient == nil {
                recaptchaClient = try await getClientReCaptcha()
            }
            recaptchaToken = try await getTokenReCapcha(client: recaptchaClient!)
        }
        catch {
            throw error
        }
        
        return recaptchaToken
    }

	
}
