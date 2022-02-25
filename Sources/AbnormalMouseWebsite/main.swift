import Foundation
import Plot
import Publish

private let websiteURLPrefix: String = "https://abnormalmouse.intii.com"

enum Currency {
    case cny
    case auto
}

extension Language {
    var anotherLanguage: (title: String, url: URL) {
        switch self {
        case .chinese: return ("English", URL(string: websiteURLPrefix)!)
        default: return ("中文", URL(string: websiteURLPrefix + "/zh-cn")!)
        }
    }

    var appTitle: String {
        switch self {
        case .chinese: return "Abnormal Mouse"
        default: return "Abnormal Mouse"
        }
    }

    var changelogLink: URL {
        switch self {
        case .chinese: return URL(string: "https://www.craft.do/s/l5oiOYOxYeoqOh")!
        default: return URL(string: "https://www.craft.do/s/ISD8TW1hP4G6MT")!
        }
    }

    var changelogTitle: String {
        switch self {
        case .chinese: return "更新日志"
        default: return "Changelog"
        }
    }

    var appDescription: (String, String, String) {
        switch self {
        case .chinese:
            return (
                "让你在 macOS 中更轻松地使用一般鼠标。",
                "如果你的鼠标有很多按键那就更好了。",
                "为什么 magic mouse 那么贵。"
            )
        default:
            return (
                "Fix normal mice for macOS. ",
                "Perfect for mice with a lot of buttons. ",
                "Why is magic mouse so expensive."
            )
        }
    }

    var downloadLink: URL {
        URL(string: "https://github.com/intitni/AbnormalMouseApp/releases/download/version%2F2022.2/Abnormal_Mouse.zip")!
    }

    var githubLink: URL {
        URL(string: "https://github.com/intitni/AbnormalMouseApp")!
    }

    var downloadLinkTitle: String {
        switch self {
        case .chinese: return "下载试用。"
        default: return "Download free trial."
        }
    }

    var purchaseLink: URL {
        switch self {
        case .chinese: return purchaseLink(for: .cny)
        default: return purchaseLink(for: .auto)
        }
    }

    var purchaseLinkTitle: String {
        switch self {
        case .chinese: return "现在购买只需¥22。"
        default: return "Buy now for US$4. "
        }
    }

    var purchaseLinkDescription: String {
        switch self {
        case .chinese: return "可以激活 3 台设备"
        default: return "3 activations"
        }
    }

    var contact: String {
        switch self {
        case .chinese: return "联系开发者"
        default: return "Contact Developer"
        }
    }

    var title: String {
        switch self {
        case .chinese: return "Abnormal Mouse for macOS"
        default: return "Abnormal Mouse for macOS"
        }
    }

    var description: String {
        switch self {
        case .chinese: return "让你在 macOS 中更轻松地使用一般鼠标。"
        default: return "Fix normal mice for macOS."
        }
    }

    var twitterCard: Path {
        switch self {
        case .chinese:
            return "image/twitter-card.png"
        default:
            return "image/twitter-card-en.png"
        }
    }
    
    func purchaseLink(for currency: Currency) -> URL {
        switch currency {
        case .cny: return URL(string: "https://intii.onfastspring.com/zh-cn/abnormal-mouse")!
        default: return URL(string: "https://intii.onfastspring.com/abnormal-mouse")!
        }
    }

    func currencyIcon(for currency: Currency) -> String {
        switch currency {
        case .cny:
            return "/image/currency-icon-cny.svg"
        case .auto:
            switch self {
            case .chinese:
                return "/image/currency-icon-auto-cn.svg"
            default:
                return "/image/currency-icon-auto-en.svg"
            }
        }
    }
}

extension Location {
    var language: Language {
        switch self {
        case let loc as Section<AbnormalMouseWebsite>: return loc.id.language
        default: return .english
        }
    }

    var pageTitle: String { language.title }
    var pageDescription: String { language.description }
    var imagePath: Path? { language.twitterCard }
}

struct AbnormalMouseWebsite: Website {
    enum SectionID: String, WebsiteSectionID {
        case zh_cn = "zh-cn"

        var language: Language {
            switch self {
            case .zh_cn: return .chinese
            }
        }
    }

    struct ItemMetadata: WebsiteItemMetadata {}

    var url = URL(string: websiteURLPrefix)!
    var name: String { language.title }
    var description: String { language.description }
    var language: Language { .english }
    var imagePath: Path? { "image/twitter-card.png" }
}

var stylesheets = [String]()

extension PublishingStep where Site == AbnormalMouseWebsite {
    static var hashStylesheet: Self {
        step(named: "Hash style sheet") { context in
            let hash = String(UUID().uuidString.prefix(6))
            let file = try context.createOutputFile(at: "styles.\(hash).css")
            let source = try context.file(at: "Styles/styles.css")
            try file.write(try source.read())
            stylesheets.append("/styles.\(hash).css")
        }
    }
}

try AbnormalMouseWebsite().publish(
    withTheme: .this,
    deployedUsing: .gitHub("intitni/AbnormalMouseWebsite"),
    additionalSteps: [.hashStylesheet]
)
