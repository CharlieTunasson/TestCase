//
//  ActivityCellModel.swift
//  QapitalTestCase
//
//  Created by Charlie Tuna on 2021-03-18.
//

import UIKit

final class ActivityCellModel {

    // MARK: - Properties

    let activity: ActivityRepository.Activity
    let user: UserRepository.User

    private let userRepository = UserRepository()

    // MARK: - Init

    init(activity: ActivityRepository.Activity, user: UserRepository.User) {
        self.activity = activity
        self.user = user
    }

    var messageText: String {
        activity.message
    }

    var timestampText: String {
        activity.timestamp.contentFormatted()
    }

    var amountText: String? {
        guard let amount = activity.amount else { return nil }
        return "$" + String(format: "%.2f", amount)
    }

    var avatarUrl: URL? {
        URL(string: user.avatarUrl)
    }
}
