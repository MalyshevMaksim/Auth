public protocol CountriesRepository {
    func allCountries() -> [Country]
    func userCountry() -> Country
}

public extension Country {
    static let empty = Self(name: "", emoji: "", regionCode: "", phoneCode: "", phoneMask: "")
}
