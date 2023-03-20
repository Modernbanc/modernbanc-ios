import Foundation

final public class ModernbancApiClient {
    private let baseURL = "https://api.modernbanc.com/v1/"
    private let session: URLSession
    private let defaultHeaders: [String: String]
    
    public init(api_key: String) {
        let configuration = URLSessionConfiguration.default
        // Customize your configuration if needed, e.g., set timeoutInterval
        session = URLSession(configuration: configuration)
        
        // Define default headers if needed, e.g., API key or content type
        defaultHeaders = [
            "Content-Type": "application/json",
            "authorization": "ApiKey " + api_key
        ]
    }
    
    
    func request<T: Decodable>(
        path: String,
        method: HttpMethod,
        queryParams: [String: Any]? = nil,
        body: Any? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (Result<T, MdbApiError>) -> Void
    ) {
        guard var components = URLComponents(string: baseURL + path) else {
            let message = "Invalid URL: \(baseURL)\(path)"
            let apiError = MdbApiError(code: "InvalidURL", message: message)
            completionHandler(.failure(apiError))
            return
        }
        
        // Add query parameters for any request method
        if let queryParams = queryParams {
            components.queryItems = queryParams.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        }
        
        guard let url = components.url else {
            let message = "Invalid URL with query parameters: \(baseURL)\(path)"
            let apiError = MdbApiError(code: "InvalidURLWithQueryParams", message: message)
            completionHandler(.failure(apiError))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        // Merge default and custom headers
        let mergedHeaders = defaultHeaders.merging(headers ?? [:], uniquingKeysWith: { (_, new) in new })
        for (key, value) in mergedHeaders {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        // Add JSON body if needed
        if let body = body, method != .get {
            guard JSONSerialization.isValidJSONObject(body) else {
                let message = "Invalid JSON object: \(body)"
                let apiError = MdbApiError(code: "InvalidJSON", message: message)
                completionHandler(.failure(apiError))
                return
            }
            guard let jsonData = try? JSONSerialization.data(withJSONObject: body, options: []) else {
                let message = "Failed to serialize JSON object: \(body)"
                let apiError = MdbApiError(code: "JSONSerializationError", message: message)
                completionHandler(.failure(apiError))
                return
            }
            request.httpBody = jsonData
        }
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completionHandler(.failure(MdbApiError(code: "ServerError", message: error.localizedDescription)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completionHandler(.failure(MdbApiError(code: "InvalidResponse", message: "Invalid HTTP response")))
                return
            }
            
            switch httpResponse.statusCode {
            case 200..<300:
                if let data = data {
                    do {
                        let decodedData = try JSONDecoder().decode(T.self, from: data)
                        completionHandler(.success(decodedData))
                    } catch {
                        let message = "Failed to decode response data: \(error.localizedDescription)"
                        print(message)
                        completionHandler(.failure(MdbApiError(code: "DecodeError", message: message)))
                    }
                } else {
                    completionHandler(.failure(MdbApiError(code: "NoResponseData", message: "No response data")))
                }
            case 400..<500:
                if let data = data {
                    do {
                        let decodedData = try JSONDecoder().decode(MdbApiError.self, from: data)
                        completionHandler(.failure(decodedData))
                    } catch {
                        let jsonString = String(data: data, encoding: .utf8) ?? "Unknown string"
                        let message = "Failed to decode error response: \(jsonString)"
                        print(message)
                        completionHandler(.failure(MdbApiError(code: "DecodeError", message: message)))
                    }
                } else {
                    completionHandler(.failure(MdbApiError(code: "NoResponseData", message: "No error response data")))
                }
            default:
                completionHandler(.failure(MdbApiError(code: "ServerError", message: "Server error")))
            }
        }
        
        task.resume()
    }
}
