import Foundation
import Plot

extension EnvironmentKey where Value == Language {
    static var language: Self {
        Self(defaultValue: .english)
    }
}

struct CurrencyPicker: Component {
    var body: Component {
        Div {
            CurrencyButton(currency: .cny)
            CurrencyButton(currency: .auto)
        }
        .class("currency-picker")
    }
}

struct CurrencyButton: Component {
    @EnvironmentValue(.language) var language
    var currency: Currency

    var body: Component {
        Link(url: language.purchaseLink(for: currency)) {
            Image(URL(string: language.currencyIcon(for: currency))!)
        }
        .linkRelationship(.external)
        .linkTarget(.blank)
        .class("currency-button")
    }
}
