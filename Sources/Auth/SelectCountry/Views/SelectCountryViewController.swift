import UIKit

final class SelectCountryViewController: UIViewController {

    private let presenter: SelectCountryPresenterProtocol
    private let selectCountryView: SelectCountryViewProtocol

    init(presenter: SelectCountryPresenterProtocol, view: SelectCountryViewProtocol) {
        self.presenter = presenter
        self.selectCountryView = view
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = selectCountryView as? UIView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItems()
        presenter.loadAllCountries()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.hidesSearchBarWhenScrolling = true
    }

    private func setupNavigationItems() {
        title = "Strings.SelectCountry.NavigationBar.title"
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(close))
        navigationItem.rightBarButtonItem = rightBarButton
        navigationItem.searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController?.searchResultsUpdater = self
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    @objc private func close() {
        dismiss(animated: true)
    }
}

// MARK: - UISearchResultsUpdating
extension SelectCountryViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        guard let countryName = searchController.searchBar.text, !countryName.isEmpty else {
            presenter.loadAllCountries()
            return
        }
        presenter.searchCountry(by: countryName)
    }
}
