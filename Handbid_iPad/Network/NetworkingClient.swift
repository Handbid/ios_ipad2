//Copyright (c) 2024 by Handbid. All rights reserved.

import Foundation
import Combine

public class NetworkingClient {

    public var defaultCollectionParsingKeyPath: String?
    let baseURL: String
    public var headers = [String: String]()
    public var parameterEncoding = ParameterEncoding.json
    public var timeout: TimeInterval?
    public var sessionConfiguration = URLSessionConfiguration.default
    public var requestRetrier: NetworkRequestRetrier?
    public var jsonDecoderFactory: (() -> JSONDecoder)?

    public var logLevel: NetworkingLogLevel {
        get { return logger.logLevel }
        set { logger.logLevel = newValue }
    }

    private let logger = NetworkingLogger()

    public init(timeout: TimeInterval? = nil) {
        self.baseURL = AppEnvironment.baseURL
        self.timeout = timeout
    }
    
    public func toModel<T: NetworkingJSONDecodable>(_ json: Any, keypath: String? = nil) throws -> T {
        do {
            let data = resourceData(from: json, keypath: keypath)
            return try T.decode(data)
        } catch (let error) {
            throw error
        }
    }
    
    public func toModel<T: Decodable>(_ json: Any, keypath: String? = nil) throws -> T {
        do {
            let jsonObject = resourceData(from: json, keypath: keypath)
            let decoder = jsonDecoderFactory?() ?? JSONDecoder()
            let data = try JSONSerialization.data(withJSONObject: jsonObject, options: [])
            let model = try decoder.decode(T.self, from: data)
            return model
        } catch (let error) {
            throw error
        }
    }

    public func toModels<T: NetworkingJSONDecodable>(_ json: Any, keypath: String? = nil) throws -> [T] {
        do {
            guard let array = resourceData(from: json, keypath: keypath) as? [Any] else {
                return [T]()
            }
            return try array.map {
                try T.decode($0)
            }.compactMap { $0 }
        } catch (let error) {
            throw error
        }
    }
    
    public func toModels<T: Decodable>(_ json: Any, keypath: String? = nil) throws -> [T] {
        do {
            guard let array = resourceData(from: json, keypath: keypath) as? [Any] else {
                return [T]()
            }
            return try array.map { jsonObject in
                let decoder = jsonDecoderFactory?() ?? JSONDecoder()
                let data = try JSONSerialization.data(withJSONObject: jsonObject, options: [])
                let model = try decoder.decode(T.self, from: data)
                return model
            }.compactMap { $0 }
        } catch (let error) {
            throw error
        }
    }

    private func resourceData(from json: Any, keypath: String?) -> Any {
        if let keypath = keypath, !keypath.isEmpty, let dic = json as? [String: Any], let val = dic[keypath] {
            return val is NSNull ? json : val
        }
        return json
    }
}

