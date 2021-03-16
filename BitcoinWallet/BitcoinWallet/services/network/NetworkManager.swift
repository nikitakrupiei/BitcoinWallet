//
//  NetworkManager.swift
//  BitcoinWallet
//
//  Created by admin on 16.03.2021.
//

import CoreData

public typealias Parameters = [String:Any]
typealias responseHandler = (Data?, URLResponse?, Error?) -> Void
typealias responseErrorHandler = (_ response:Error)->()
typealias responseSuccessHandler = (_ data:Data)->()

protocol APIConfiguration {
    var method: HTTPMethod { get }
    var path: String { get }
    var timeInterval: TimeInterval { get }
}

enum HTTPMethod: String {
    case POST
    case GET
    case DELETE
    case PUT
}

struct ServerMesage: Decodable {
    var message: String

    enum CodingKeys: String, CodingKey{
        case message = "Message"
    }
}

struct ServerError: Decodable {
    var error: String
    var error_description: String
}

enum ResponseStatus: Int {
    case OK = 200
    case NoContent = 204
    case BAD_REQUEST = 400
    case NOT_FOUND = 404
}

enum APIError: Error {
    case NoInternetConnection
    case ServerUnavailable
    case ServerTimeout
    case Unexpected(message: String?)
    case DecodeDataError(message: String)
    case BadRequest(message: String?)
    case NotFound(message: String?)
    
    var local: String {
        switch self {
        case .DecodeDataError(let message):
            return message
        case .NoInternetConnection:
            return "No Internet connection. Please check your network settings or try again later.";
        case .ServerUnavailable:
            return "Server error happened, service unavailable. Please try again later.";
        case .ServerTimeout:
            return "Connection timeout expired. Please check your network settings or try again later.";
        case .Unexpected(let message):
            return message ?? "An unexpected error happened, please, try later";
        case .BadRequest(let message):
            return message ?? "Incorrect request data";
        case .NotFound(let message):
            return message ?? "Not found";
        }
    }
}

extension APIConfiguration {
    
    var timeInterval: TimeInterval {
        return 60
    }
    
    func addOne<Entity: NSManagedObject & Codable>(toStore context: NSManagedObjectContext, success:@escaping((Entity)->()), fail:@escaping(responseErrorHandler)){
        self.callRequest(success: { data in
            PersistentService.addOne(data: data, ofType: Entity.self, success: success, fail: fail)
        }, fail: fail)
    }
    
    private func callRequest(success:@escaping(responseSuccessHandler), fail:@escaping(responseErrorHandler)) {
        guard let request = Request(path: path, httpMethod: method, timeInterval: timeInterval) else {
            return
        }
        ApiService.execute(request: request, success: success, fail: fail)
    }
}

class ApiService {
    static func execute(request: Request, success:@escaping(responseSuccessHandler), fail:@escaping(responseErrorHandler)) {
        send(request: request, completionHandler: { (data, response, error) in
            do {
                print("Request: \(request.request.url?.absoluteString ?? "")")
                let (_data, _response, _status, message) = try validateResponse(data: data, response: response, error: error)
                try handlerResponseStatus(status: _status, response: _response, message: message)
                DispatchQueue.main.async {
                    success(_data)
                }
            } catch {
                DispatchQueue.main.async {
                    fail(error)
                }
            }
        })
    }
    
    private static func validateResponse(data: Data?, response: URLResponse?, error: Error?) throws -> (data: Data, response: HTTPURLResponse, status: ResponseStatus, message: String?){
        if let _error = error {
            if (_error as NSError).code == NSURLErrorNotConnectedToInternet{
                throw APIError.NoInternetConnection
            } else if (_error as NSError).code == NSURLErrorTimedOut {
                throw APIError.ServerTimeout
            }
            throw APIError.ServerUnavailable
        }
        
        guard let _data = data, let _response = response as? HTTPURLResponse else {
            throw APIError.Unexpected(message: nil)
        }
        let message = ((try? JSONDecoder().decode(ServerError.self, from: _data).error_description) ?? (try? JSONDecoder().decode(ServerMesage.self, from: _data).message)) ?? String(data: _data, encoding: String.Encoding.utf8)
        print("ResponseStatus: \(_response.statusCode))")
        guard let status = ResponseStatus(rawValue: _response.statusCode) else {
            throw APIError.Unexpected(message: nil)
        }
        return (_data, _response, status, message)
    }
    
    private static func handlerResponseStatus(status: ResponseStatus, response: HTTPURLResponse, message: String?) throws{
        switch status {
        case .OK, .NoContent:
            return
        case .BAD_REQUEST:
            throw APIError.BadRequest(message: message)
        case .NOT_FOUND:
            throw APIError.NotFound(message: message)
        }
    }
    
    private static func send(request: Request, completionHandler:@escaping(responseHandler)){
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request.request, completionHandler: completionHandler)
        task.resume()
    }
}

struct Request {
    
    var request: URLRequest
    
    init?(path: String, httpMethod: HTTPMethod, timeInterval: TimeInterval){
        guard var requestPath = EnvironmentConfiguration.baseApiUrl else {
            return nil
        }
        if let apiVersion = EnvironmentConfiguration.apiVersion {
            requestPath.appendPathComponent(apiVersion)
        }
        requestPath = URL(string: requestPath.absoluteString)?.appendingPathComponent(path) ?? requestPath
        var baseRequest = URLRequest(url: requestPath, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: timeInterval)
        baseRequest.httpMethod = httpMethod.rawValue
        
        self.request = baseRequest
    }
}
