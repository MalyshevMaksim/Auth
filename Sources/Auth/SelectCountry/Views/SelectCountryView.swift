import UIKit

protocol SelectCountryViewProtocol: AnyObject {
    func render(_ props: SelectCountry)
}

final class SelectCountryView: UIView {

    private var props: SelectCountry?

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellWithClass: SelectCountryCell.self)
        tableView.keyboardDismissMode = .onDrag
        return tableView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    private func setupSubviews() {
        addSubview(tableView)
        tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SelectCountryViewProtocol
extension SelectCountryView: SelectCountryViewProtocol {

    func render(_ props: SelectCountry) {
        self.props = props
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension SelectCountryView: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        props?.sections.count ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        props?.sections[section].countries.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let country = props?.sections[indexPath.section].countries[indexPath.row] else { fatalError() }
        let cell = tableView.dequeueCell(withClass: SelectCountryCell.self, for: indexPath)
        cell.setup(with: country)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SelectCountryView: UITableViewDelegate {

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        props?.sections[section].title
    }

    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        UIView.animate(withDuration: 0.15) {
            cell.contentView.backgroundColor = .systemGray4
        }
    }

    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        UIView.animate(withDuration: 0.15) {
            cell.contentView.backgroundColor = .clear
        }
    }

    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        props?.sections.map { $0.title }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let country = props?.sections[indexPath.section].countries[indexPath.row] else { return }
        props?.onSelectCountry(country)
    }
}
