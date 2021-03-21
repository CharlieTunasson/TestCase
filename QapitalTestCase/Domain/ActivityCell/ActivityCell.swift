//
//  ActivityCell.swift
//  QapitalTestCase
//
//  Created by Charlie Tuna on 2021-03-18.
//

import UIKit
import SDWebImage

final class ActivityCell: UITableViewCell {

    // MARK: - Properties

    static let reuseIdentifier = "activityCellReuseIdentifier"

    private weak var viewModel: ActivityCellModel?

    private let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .clear
        imageView.layer.cornerRadius = 16
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        return imageView
    }()

    private let messageTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.isScrollEnabled = false
        textView.isUserInteractionEnabled = false
        textView.font = .appFont(placement: .titleB)
        textView.textColor = .passiveText
        textView.textContainerInset = UIEdgeInsets(top: -3, left: -6, bottom: 0, right: 0)
        return textView
    }()

    private let amountLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(placement: .titleB)
        label.textColor = .amount
        return label
    }()

    private let timestampLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(placement: .captionB)
        label.textColor = .passiveText
        return label
    }()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func prepareForReuse() {
        messageTextView.text = ""
        timestampLabel.text = ""
        amountLabel.isHidden = false
        amountLabel.text = ""
        userImageView.image = nil
    }

    // MARK: - UI

    private func setupViews() {
        viewModel = nil
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }

    private func setupConstraints() {
        let vStack = UIStackView(arrangedSubviews: [messageTextView, timestampLabel])
        vStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.axis = .vertical
        vStack.spacing = 10
        vStack.alignment = .leading
        vStack.distribution = .fill

        let hStack = UIStackView(arrangedSubviews: [userImageView, vStack, amountLabel])
        hStack.translatesAutoresizingMaskIntoConstraints = false
        hStack.axis = .horizontal
        hStack.spacing = 10
        hStack.distribution = .fill
        hStack.alignment = .top

        contentView.addSubview(hStack)

        NSLayoutConstraint.activate([
            userImageView.heightAnchor.constraint(equalToConstant: 32),
            userImageView.widthAnchor.constraint(equalToConstant: 32),

            hStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            hStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            hStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            hStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }

    func configure(with viewModel: ActivityCellModel) {
        let messageAttributedString = viewModel.messageText.attributedStringWithTags(attributes: [.font: UIFont.appFont(placement: .titleB),
                                                                                                  .foregroundColor: UIColor.passiveText],
                                                                                     tagAttributes: ["strong": [.foregroundColor: UIColor.boldText]])
        messageTextView.attributedText = messageAttributedString
        timestampLabel.text = viewModel.timestampText
        amountLabel.text = viewModel.amountText
        userImageView.sd_setImage(with: viewModel.avatarUrl)
    }
}
