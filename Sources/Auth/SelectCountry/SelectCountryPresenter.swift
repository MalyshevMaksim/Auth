import Foundation

protocol SelectCountryPresenterProtocol {
    func loadAllCountries()
    func searchCountry(by name: String)
}

final class SelectCountryPresenter: SelectCountryPresenterProtocol {

    private let view: SelectCountryViewProtocol
    private let router: AuthRouterProtocol
    private let countriesRepository: CountriesRepository

    init(view: SelectCountryViewProtocol,
         router: AuthRouterProtocol,
         countriesRepository: CountriesRepository) {
        self.view = view
        self.router = router
        self.countriesRepository = countriesRepository
    }

    func loadAllCountries() {
        let countries = countriesRepository.allCountries()
        let props = props(with: countries)
        view.render(props)
    }

    func searchCountry(by name: String) {
        let countries = countriesRepository.allCountries()
        let filteredCountries = countries.filter { $0.name.lowercased().contains(name.lowercased()) }
        let props = props(with: filteredCountries)
        view.render(props)
    }

    private func props(with countries: [Country]) -> SelectCountry {
        let titleLetters = countries
            .compactMap { $0.name.first }
            // .uniqued()
            .sorted(by: { $0 < $1 })

        let countriesSections = titleLetters.map { character in
            let countriesWithPrefix = countries
                .filter { $0.name.first == character }
                .sorted(by: { $0.name < $1.name })
            return SelectCountry.Section(
                countries: countriesWithPrefix,
                title: String(character)
            )
        }

        return SelectCountry(
            sections: countriesSections,
            onSelectCountry: onSelectCountry
        )
    }

    private func localizedCountryName(regionCode: String) -> String {
        Locale.current.localizedString(forRegionCode: regionCode) ?? ""
    }

    private func onSelectCountry(_ country: Country) {
        router.route(to: .cancelSelectCountry)
    }
}
