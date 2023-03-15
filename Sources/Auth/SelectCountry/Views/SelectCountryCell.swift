import UIKit

final class SelectCountryCell: UITableViewCell {

    private let nameLabel = UILabel()

    private let phoneCodeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup(with country: Country) {
        nameLabel.text = country.emoji + " " + country.name
        phoneCodeLabel.text = country.phoneCode
    }

    private func setupSubviews() {
        selectionStyle = .none
        contentView.addSubviews(subviews: nameLabel, phoneCodeLabel)
    }

    private func setupConstraints() {
        phoneCodeLabel.snp.makeConstraints {
            $0.trailing.equalTo(safeAreaLayoutGuide).inset(24)
            $0.centerY.equalToSuperview()
        }
        nameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
    }
}
