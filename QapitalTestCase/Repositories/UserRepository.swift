//
//  UserRepository.swift
//  QapitalTestCase
//
//  Created by Charlie Tuna on 2021-03-19.
//

import Foundation

final class UserRepository {
    struct User: Decodable {
        let userId: Int
        let displayName: String
        let avatarUrl: String
    }

    static var users: [User] = []

    private let networkService = NetworkService()

    private func userUrl(id: Int) -> String {
        return "https://qapital-ios-testtask.herokuapp.com/users/\(id)"
    }

    func getUser(id: Int, completion: @escaping (Result<User, Error>) -> Void) {
        if let user = UserRepository.users.first(where: { $0.userId == id }) {
            completion(.success(user))
            return
        }
        networkService.dispatchRequest(urlString: userUrl(id: id)) { result in
            switch result {
            case .success(let data):
                do {
                    let user = try JSONDecoder().decode(User.self, from: data)
                    DispatchQueue.main.async {
                        UserRepository.users.append(user)
                        completion(.success(user))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}
