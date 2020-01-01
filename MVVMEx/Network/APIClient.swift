//
//  APIClient.swift
//  We
//
//  Created by ahmed mahdy on 11/2/19.
//  Copyright © 2019 Mahdy. All rights reserved.
//

import Foundation
import Alamofire


protocol APIClient {
    func makeRequest(withRequest: URLRequest, completion: @escaping JSONTaskCompletionHandler)
    func uploadRequest<T: Decodable>(to: URL, with data: Data, with image: UIImage?, decodingType:T.Type, completion: @escaping JSONTaskCompletionHandler)
}

extension APIClient {
    typealias JSONTaskCompletionHandler = (RequestResult<Decodable, RequestError>) -> Void

    func uploadRequest<T: Decodable>(to: URL,with data: Data, with image: UIImage?, decodingType:T.Type, completion: @escaping JSONTaskCompletionHandler) {
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(data, withName: "registrationmodel")
            if let image = image {
                if let data = image.jpegData(compressionQuality: 0.5) {
                    multipartFormData.append(data, withName: "image", fileName: "image.jpeg", mimeType: "image/*")
                }
            }
        },
                         to:to,
                         method: .post,
                         headers:nil,
                         encodingCompletion: { encodingResult in
                            switch encodingResult {
                            case .success(request:let upload,  streamingFromDisk:_,  streamFileURL:_):
                                upload.responseJSON(completionHandler: { (response:DataResponse<Any>) in
                                    switch response.result {
                                    case .failure:
                                        completion(.failure(.invalidResponse))
                                    case .success:
                                        self.decodeJsonResponse(decodingType: decodingType, jsonObject: response.data!, completion: completion)
                                    }
                                })
                            case .failure:
                                completion(.failure(.unknownError))
                            }
        })
    }

    func makeRequest(withRequest: URLRequest, completion: @escaping JSONTaskCompletionHandler){
        Alamofire.request(withRequest).responseJSON(completionHandler: {
            (response) in
            if let error = response.error {
                print(error)
                completion(.failure(.connectionError))
            } else {
                print(response)
                if let code = response.response?.statusCode {
                    let result = response.result
                    switch code {
                    case 200:
                        //completion(.success(responseJson))
                        if result.isSuccess {
                            completion(.success(nil))
                        } else {
                            completion(.failure(.unknownError))
                        }
                    case 400 ... 499:
                        completion(.failure(.authorizationError))
                    case 500 ... 599:
                        completion(.failure(.serverError))
                    default:
                        completion(.failure(.unknownError))
                        break
                    }
                }
            }
        })
    }
    func makeRequest<T: Decodable>(withRequest: URLRequest, decodingType:T.Type,completion: @escaping JSONTaskCompletionHandler) {

        Alamofire.request(withRequest).responseJSON(completionHandler: {
            (response) in
            if let error = response.error {
                print(error)
                completion(.failure(.connectionError))
            } else if let data = response.data {
                print(response)
                if let code = response.response?.statusCode {
                    switch code {
                    case 200:
                        //                            completion(.success(responseJson))
                        self.decodeJsonResponse(decodingType: decodingType, jsonObject: data, completion: completion)
                    case 400 ... 499:
                        completion(.failure(.authorizationError))
                    case 500 ... 599:
                        completion(.failure(.serverError))
                    default:
                        completion(.failure(.unknownError))
                        break
                    }
                }
            }
        })
    }
    func decodeJsonResponse<T: Decodable>(decodingType:T.Type,jsonObject: Data, completion: @escaping JSONTaskCompletionHandler){
        DispatchQueue.main.async {

            do {
                let genericModel = try JSONDecoder().decode(decodingType, from: jsonObject)
                completion(.success(genericModel))
            } catch {
                completion(.failure(.jsonConversionFailure))
            }
        }
    }
}
