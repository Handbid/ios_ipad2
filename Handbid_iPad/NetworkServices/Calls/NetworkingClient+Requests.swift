// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import Foundation

public extension NetworkingClient {
    
	func getRequest(_ route: String, params: Params = Params()) -> NetworkingRequest {
		request(.get, route, params: params)
	}

	func postRequest(_ route: String, params: Params = Params()) -> NetworkingRequest {
		request(.post, route, params: params)
	}

	func putRequest(_ route: String, params: Params = Params()) -> NetworkingRequest {
		request(.put, route, params: params)
	}

	func patchRequest(_ route: String, params: Params = Params()) -> NetworkingRequest {
		request(.patch, route, params: params)
	}

	func deleteRequest(_ route: String, params: Params = Params()) -> NetworkingRequest {
		request(.delete, route, params: params)
	}

	internal func request(_ httpMethod: HTTPMethod,
	                      _ route: String,
	                      params: Params = Params()) -> NetworkingRequest
	{
		let req = NetworkingRequest()
		req.httpMethod = httpMethod
		req.route = route
		req.params = params

		let updateRequest = { [weak req, weak self] in
			guard let self else { return }
			req?.baseURL = baseURL
			req?.logLevel = logLevel
			req?.headers = headers
			req?.parameterEncoding = parameterEncoding
			req?.sessionConfiguration = sessionConfiguration
			req?.timeout = timeout
		}
		updateRequest()
		req.requestRetrier = { [weak self] in
			self?.requestRetrier?($0, $1)?
				.handleEvents(receiveOutput: { _ in
					updateRequest()
				})
				.eraseToAnyPublisher()
		}
		return req
	}

	internal func request(_ httpMethod: HTTPMethod,
	                      _ route: String,
	                      params _: Params = Params(),
	                      encodableBody: Encodable? = nil) -> NetworkingRequest
	{
		let req = NetworkingRequest()
		req.httpMethod = httpMethod
		req.route = route
		req.params = Params()
		req.encodableBody = encodableBody

		let updateRequest = { [weak req, weak self] in
			guard let self else { return }
			req?.baseURL = baseURL
			req?.logLevel = logLevel
			req?.headers = headers
			req?.parameterEncoding = parameterEncoding
			req?.sessionConfiguration = sessionConfiguration
			req?.timeout = timeout
		}
		updateRequest()
		req.requestRetrier = { [weak self] in
			self?.requestRetrier?($0, $1)?
				.handleEvents(receiveOutput: { _ in
					updateRequest()
				})
				.eraseToAnyPublisher()
		}
		return req
	}
}
