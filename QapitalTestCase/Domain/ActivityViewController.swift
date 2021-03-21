//
//  MainViewController.swift
//  QapitalTestCase
//
//  Created by Charlie Tuna on 2021-03-18.
//

import UIKit

final class ActivityViewController: UIViewController {

    // MARK: - Properties

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableFooterView = UIView()
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return tableView
    }()

    private var cellHeights: [IndexPath: CGFloat] = [:]
    private var cellHeightsMedian: CGFloat {
        if cellHeights.count == 0 { return 75.0 }
        var totalHeight: CGFloat = 0.0
        cellHeights.forEach({ totalHeight += $0.value })
        return totalHeight / CGFloat(cellHeights.count)
    }

    private let viewModel: ActivityViewModel

    // MARK: - Init

    init(viewModel: ActivityViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupConstraints()

        viewModel.didReceiveAction = { [weak self] action in
            self?.handle(action: action)
        }

        viewModel.viewDidLoad()
    }

    private func handle(action: ActivityViewModel.Action) {
        switch action {
        case .reload:

            tableView.reloadData()
            if shouldLoadMore() {
                viewModel.loadMore()
            }
        }
    }

    // MARK: - UI

    private func setupViews() {
        title = viewModel.titleText
        view.backgroundColor = .background

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ActivityCell.self, forCellReuseIdentifier: ActivityCell.reuseIdentifier)
    }

    private func setupConstraints() {
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func shouldLoadMore() -> Bool {
        let numberOfDesiredCells = 2 * (tableView.bounds.height / cellHeightsMedian)
        let currentAvailableHeight = (CGFloat(tableView.numberOfRows(inSection: 0)) * cellHeightsMedian) - tableView.contentOffset.y
        return currentAvailableHeight < (cellHeightsMedian * numberOfDesiredCells)
    }
}

// MARK: - UITableViewDataSource

extension ActivityViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cellModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ActivityCell.reuseIdentifier, for: indexPath) as! ActivityCell
        cell.configure(with: viewModel.cellModels[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate

private var currentLoadOffset: CGFloat = 0

extension ActivityViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if scrollView.contentOffset.y - currentLoadOffset >= scrollView.bounds.height {
            currentLoadOffset += scrollView.bounds.height
            viewModel.loadMore()
        } else if shouldLoadMore() {
            viewModel.loadMore()
        }
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath] ?? cellHeightsMedian
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeights[indexPath] = cell.frame.size.height
    }
}
