import Foundation

class APIProvider: APIService {
    
    static let shared = APIProvider()
    
    private let apiKey = "7175605a65ca0de368cb452d6eddf680"
    private let auth = "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI3MTc1NjA1YTY1Y2EwZGUzNjhjYjQ1MmQ2ZWRkZjY4MCIsIm5iZiI6MTczMjU1OTAwNy40MjAwMzEzLCJzdWIiOiI2NzNhMzEwNzNjODMxYTEzMjk1M2MwNGQiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.aREY7vAfod0f1UDlixodDyMk9-WhBXBdyvoDwqO3TTQ"
    private let accountId = 21636316
    private let sessionId = "4a244d4e9934ef1bce5ecdafad104ae2"
    private let baseAPIURL = "https://api.themoviedb.org/3"
    private let urlSession = URLSession.shared
    private let jsonDecoder = Decoder.jsonDecoder
    
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
    }
    
    func fetchMovies(from endpoint: String, completion: @escaping (Result<Home.Model.Response, APIError>) -> ()) {
        guard let url = URL(string: "\(baseAPIURL)/movie/\(endpoint)") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecode(url: url, method: .get, completion: completion)
    }
    
    func fetchMyList(completion: @escaping (Result<Home.Model.Response, APIError>) -> ()) {
        guard let url = URL(string: "\(baseAPIURL)/account/\(accountId)/watchlist/movies") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecode(url: url, method: .get, completion: completion)
    }
    
    func addWatchList(id: Int, addToWatchlist: Bool, completion: @escaping (Result<WatchListResponse, APIError>) -> ()) {
        guard let url = URL(string: "\(baseAPIURL)/account/\(accountId)/watchlist?api_key=\(apiKey)&session_id=\(sessionId)") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecode(url: url, method: .post, params: [
            "media_type": "movie",
            "media_id": id,
            "watchlist": addToWatchlist
        ], completion: completion)
    }
    
    func fetchMyDetails(id: Int, completion: @escaping (Result<Details.Model.Response, APIError>) -> ()) {
        guard let url = URL(string: "\(baseAPIURL)/movie/\(id)") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecode(url: url, method: .get, params: [
            "append_to_response": "videos"
        ], completion: completion)
    }
    
    
    private func loadURLAndDecode<D: Decodable>(url: URL, method: HTTPMethod, params: [String: Any]? = nil, completion: @escaping (Result<D, APIError>) -> ()) {
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        var queryItems = [URLQueryItem(name: "api_key", value: apiKey), URLQueryItem(name: "language", value: "pt-BR")]
        if let params = params, method == .get {
            queryItems.append(contentsOf: params.map { URLQueryItem(name: $0.key, value: String(describing: $0.value)) })
        }
        
        urlComponents.queryItems = queryItems
        
        guard let finalURL = urlComponents.url else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        var request = URLRequest(url: finalURL)
        request.httpMethod = method.rawValue
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": auth
        ]
        
        if method == .post, let params = params {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
            } catch {
                print("Erro ao serializar JSON: \(error)")
            }
        }
        urlSession.dataTask(with: request) { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            if error != nil {
                self.executeCompletionHandlerInMainThread(with: .failure(.apiError), completion: completion)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                self.executeCompletionHandlerInMainThread(with: .failure(.invalidResponse), completion: completion)
                return
            }
            
            guard let data = data else {
                self.executeCompletionHandlerInMainThread(with: .failure(.noData), completion: completion)
                return
            }
            
            do {
                let decodedResponse = try self.jsonDecoder.decode(D.self, from: data)
                self.executeCompletionHandlerInMainThread(with: .success(decodedResponse), completion: completion)
            } catch {
                self.executeCompletionHandlerInMainThread(with: .failure(.serializationError), completion: completion)
            }
        }.resume()
    }

    private func executeCompletionHandlerInMainThread<D: Decodable>(with result: Result<D, APIError>, completion: @escaping (Result<D, APIError>) -> ()) {
        DispatchQueue.main.async {
            completion(result)
        }
    }
}
