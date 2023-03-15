public struct SelectCountry {

    let sections: [Section]
    let onSelectCountry: (Country) -> Void

    public struct Section {
        let countries: [Country]
        let title: String
    }
}

public struct Country: Decodable {
    let name: String
    let emoji: String
    let regionCode: String
    let phoneCode: String
    let phoneMask: String?
}
