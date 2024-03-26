// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import Foundation

extension NetworkingClient {
	func post(_ route: String,
	          params: Params = Params(),
	          multipartData: MultipartData) -> AnyPublisher<(Data?, Progress), Error>
	{
		post(route, params: params, multipartData: [multipartData])
	}

	func put(_ route: String,
	         params: Params = Params(),
	         multipartData: MultipartData) -> AnyPublisher<(Data?, Progress), Error>
	{
		put(route, params: params, multipartData: [multipartData])
	}

	func patch(_ route: String,
	           params: Params = Params(),
	           multipartData: MultipartData) -> AnyPublisher<(Data?, Progress), Error>
	{
		patch(route, params: params, multipartData: [multipartData])
	}

	// Allow multiple multipart data
	func post(_ route: String,
	          params: Params = Params(),
	          multipartData: [MultipartData]) -> AnyPublisher<(Data?, Progress), Error>
	{
		let req = request(.post, route, params: params)
		req.multipartData = multipartData
		return req.uploadPublisher()
	}

	func put(_ route: String,
	         params: Params = Params(),
	         multipartData: [MultipartData]) -> AnyPublisher<(Data?, Progress), Error>
	{
		let req = request(.put, route, params: params)
		req.multipartData = multipartData
		return req.uploadPublisher()
	}

	func patch(_ route: String,
	           params: Params = Params(),
	           multipartData: [MultipartData]) -> AnyPublisher<(Data?, Progress), Error>
	{
		let req = request(.patch, route, params: params)
		req.multipartData = multipartData
		return req.uploadPublisher()
	}
}
