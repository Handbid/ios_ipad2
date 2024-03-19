// Copyright (c) 2024 by Handbid. All rights reserved.

protocol PageProtocol: RawRepresentable, Identifiable, Hashable where RawValue == String {}

enum RegistrationPage: String, PageProtocol, Identifiable, Hashable {
	case getStarted, logIn
	var id: String {
		rawValue
	}
}
