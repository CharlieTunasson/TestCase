//
//  ActivityViewModel.swift
//  QapitalTestCase
//
//  Created by Charlie Tuna on 2021-03-18.
//

import Foundation

final class ActivityViewModel {

    enum Action {
        case reload
    }

    // MARK: - Properties

    let titleText = String.localized(key: "activity.title")

    var didReceiveAction: ((Action) -> Void)?

    private(set) var currentWeeks = 2
    private(set) var cellModels: [ActivityCellModel] = []
    private(set) var hasReachedOldest = false

    private var isLoading = false

    private let activityRepository = ActivityRepository()
    private let userRepository = UserRepository()

    // MARK: - Operations

    func viewDidLoad() {
        loadMore()
    }

    func loadMore() {
        if isLoading || hasReachedOldest { return }
        isLoading = true
        fetchActivities(weeksBefore: currentWeeks)
        currentWeeks += 2
    }

    private func fetchActivities(weeksBefore: Int) {
        let fromDate = Date() - (weeksBefore * 7)
        let toDate = Date() - ((weeksBefore - 2) * 7)
        activityRepository.getActivities(from: fromDate, to: toDate) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let activities):
                let group = DispatchGroup()
                var models: [ActivityCellModel] = []
                activities.activities.forEach { activity in
                    if activity.timestamp == activities.oldest { self.hasReachedOldest = true }
                    group.enter()
                    self.userRepository.getUser(id: activity.userId) { result in
                        switch result {
                        case .success(let user):
                            models.append(ActivityCellModel(activity: activity, user: user))
                        case .failure(let error):
                            print(error)
                        }
                        group.leave()
                    }
                }
                group.notify(queue: .main) {
                    self.isLoading = false
                    self.cellModels.append(contentsOf: models)
                    self.cellModels.sort(by: { $0.activity.timestamp > $1.activity.timestamp })
                    self.didReceiveAction?(.reload)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
