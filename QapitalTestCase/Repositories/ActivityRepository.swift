//
//  QapitalAPI.swift
//  QapitalTestCase
//
//  Created by Charlie Tuna on 2021-03-18.
//

import Foundation

final class ActivityRepository {

    struct Activities: Decodable {
        let oldest: Date
        let activities: [Activity]
    }

    struct Activity: Decodable {
        let message: String
        let amount: Double?
        let userId: Int
        let timestamp: Date
    }

    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssxxx"
        dateFormatter.calendar = Calendar(identifier: .iso8601)
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return dateFormatter
    }()

    private let networkService = NetworkService()

    private func activitiesUrl(from: Date, to: Date) -> String {
        let from = dateFormatter.string(from: from)
        let to = dateFormatter.string(from: to)
        return "https://qapital-ios-testtask.herokuapp.com/activities?from=\(from)&to=\(to)"
    }

    func getActivities(from: Date, to: Date, completion: @escaping (Result<Activities, Error>) -> Void) {
        networkService.dispatchRequest(urlString: activitiesUrl(from: from, to: to)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .formatted(self.dateFormatter)
                    let activities = try decoder.decode(Activities.self, from: data)                    
                    DispatchQueue.main.async {
                        completion(.success(activities))
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
