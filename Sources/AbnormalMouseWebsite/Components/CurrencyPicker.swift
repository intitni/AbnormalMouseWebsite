import Foundation
import Plot

extension EnvironmentKey where Value == Language {
    static var language: Self {
        Self(defaultValue: .english)
    }
}

struct CurrencyPicker: Component {
    @EnvironmentValue(.language) var language
    var body: Component {
        Div {
            Paragraph(language == .chinese ? "选择货币类型" : "Choose Your Currency")
            Div {
                CurrencyButton(currency: .cny)
                CurrencyButton(currency: .auto)
            }
            .class("currency-button-wrapper")
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
