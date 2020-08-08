import Foundation
import Plot
import Publish

private let websiteURLPrefix: String = "https://abnormalmouse.intii.com"

extension Language {
    var anotherLanguage: (title: String, url: URL) {
        switch self {
        case .chinese: return ("English", URL(string: websiteURLPrefix)!)
        default: return ("中文", URL(string: websiteURLPrefix + "/zh-cn")!)
        }
    }

    var appTitle: String {
        switch self {
        case .chinese: return "不一般鼠标"
        default: return "Abnormal Mouse"
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
        URL(string: "https://github.com/intitni/AbnormalMouseWebsite/releases/download/2020.2/Abnormal_Mouse_2020_2.zip")!
    }

    var downloadLinkTitle: String {
        switch self {
        case .chinese: return "下载试用。"
        default: return "Download free trial."
        }
    }

    var purchaseLink: URL {
        switch self {
        case .chinese: return URL(string: "https://intii.onfastspring.com/zh-cn/abnormal-mouse")!
        default: return URL(string: "https://intii.onfastspring.com/abnormal-mouse")!
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
        case .chinese: return "联系我"
        default: return "Contact"
        }
    }
    
    var title: String {
        switch self {
        case .chinese: return "不一般鼠标 for macOS"
        default: return "Abnormal Mouse for macOS"
        }
    }
    
    var description: String {
        switch self {
        case .chinese: return "让你在 macOS 中更轻松地使用一般鼠标。"
        default: return "Fix normal mice for macOS."
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
    var imagePath: Path? { "image/twitter-card.png" }
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

try AbnormalMouseWebsite().publish(
    withTheme: .this,
    deployedUsing: .gitHub("intitni/AbnormalMouseWebsite")
)
