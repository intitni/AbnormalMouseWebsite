import Foundation
import Ink
import Plot
import Publish
import Sweep

public extension Theme {
    static var this: Self {
        Theme(
            htmlFactory: AHTMLFactory(),
            resourcePaths: []
        )
    }
}

private struct AHTMLFactory<Site: Website>: HTMLFactory {
    func makeIndexHTML(
        for index: Index,
        context: PublishingContext<Site>
    ) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .theHead(for: index, on: context.site),
            .body(
                .gtag,
                .appBanner(for: context.site.language, isSection: false),
                .div(
                    .class("wrapper content-wrapper"),
                    index.content.body.node
                ),
                .footer(for: context.site.language)
            )
        )
    }

    func makeSectionHTML(
        for section: Section<Site>,
        context: PublishingContext<Site>
    ) throws -> HTML {
        HTML(
            .lang(section.language),
            .theHead(for: section, on: context.site),
            .body(
                .gtag,
                .appBanner(for: section.language, isSection: true),
                .div(
                    .class("wrapper content-wrapper"),
                    section.content.body.node
                ),
                .footer(for: section.language)
            )
        )
    }

    func makeItemHTML(
        for item: Item<Site>,
        context: PublishingContext<Site>
    ) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .theHead(for: item, on: context.site),
            .body(
                .gtag,
                .class("item-page"),
                .header(for: context, selectedSection: item.sectionID),
                .wrapper(
                    .article(
                        .div(
                            .class("content"),
                            .contentBody(item.body)
                        ),
                        .span("Tagged with: "),
                        .tagList(for: item, on: context.site)
                    )
                ),
                .footer(for: context.site.language)
            )
        )
    }

    func makePageHTML(
        for page: Page,
        context: PublishingContext<Site>
    ) throws -> HTML {
        if page.path.absoluteString.contains("release-note") {
            return HTML(
                .lang(context.site.language),
                .theHead(for: page, on: context.site),
                .body(
                    .wrapper(.contentBody(page.body))
                )
            )
        }
        return HTML(
            .lang(context.site.language),
            .theHead(for: page, on: context.site),
            .body(
                .gtag,
                .header(for: context, selectedSection: nil),
                .wrapper(.contentBody(page.body)),
                .footer(for: context.site.language)
            )
        )
    }

    func makeTagListHTML(
        for page: TagListPage,
        context: PublishingContext<Site>
    ) throws -> HTML? {
        HTML(
            .lang(context.site.language),
            .theHead(for: page, on: context.site),
            .body(
                .gtag,
                .header(for: context, selectedSection: nil),
                .wrapper(
                    .h1("Browse all tags"),
                    .ul(
                        .class("all-tags"),
                        .forEach(page.tags.sorted()) { tag in
                            .li(
                                .class("tag"),
                                .a(
                                    .href(context.site.path(for: tag)),
                                    .text(tag.string)
                                )
                            )
                        }
                    )
                ),
                .footer(for: context.site.language)
            )
        )
    }

    func makeTagDetailsHTML(
        for page: TagDetailsPage,
        context: PublishingContext<Site>
    ) throws -> HTML? {
        HTML(
            .lang(context.site.language),
            .theHead(for: page, on: context.site),
            .body(
                .gtag,
                .header(for: context, selectedSection: nil),
                .wrapper(
                    .h1(
                        "Tagged with ",
                        .span(.class("tag"), .text(page.tag.string))
                    ),
                    .a(
                        .class("browse-all"),
                        .text("Browse all tags"),
                        .href(context.site.tagListPath)
                    ),
                    .itemList(
                        for: context.items(
                            taggedWith: page.tag,
                            sortedBy: \.date,
                            order: .descending
                        ),
                        on: context.site
                    )
                ),
                .footer(for: context.site.language)
            )
        )
    }
}

private extension Node where Context == HTML.DocumentContext {
    static func theHead<T: Website, L: Location>(
        for location: L,
        on site: T
    ) -> Node<HTML.DocumentContext> {
        var title = location.pageTitle
        if title.isEmpty {
            title = site.name
        }
        var description = location.pageDescription
        if description.isEmpty {
            description = site.description
        }

        return .head(
            .encoding(.utf8),
            .siteName(title),
            .url(site.url(for: location)),
            .title(title),
            .description(description),
            .twitterCardType(.summaryLargeImage),
            .forEach(["/styles.\(cssHash).css"]) { .stylesheet($0) },
            .viewport(.accordingToDevice),
            .unwrap(site.favicon) { .favicon($0) },
            .unwrap(location.imagePath ?? site.imagePath) { path in
                let url = site.url(for: path)
                var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
                components.queryItems = [
                    .init(name: "random", value: String(Int.random(in: 1 ... 9999))),
                ]
                return .socialImageLink(components.url!)
            },
            .meta(
                .attribute(named: "name", value: "twitter:site"),
                .attribute(named: "content", value: "@intitni")
            ),
            .meta(
                .attribute(named: "name", value: "twitter:creator"),
                .attribute(named: "content", value: "@intitni")
            ),
            .script( // Enable Gtag
                .raw("""
                window.dataLayer = window.dataLayer || [];
                function gtag(){dataLayer.push(arguments);}
                gtag('js', new Date());
                gtag('config', 'UA-17603222-4');
                """)
            ),
            .script( // Google Tag Manager
                .raw("""
                (function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
                new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
                j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
                'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
                })(window,document,'script','dataLayer','GTM-5K84TFL');
                """)
            )
        )
    }
}

private extension Node where Context == HTML.BodyContext {
    static func wrapper(_ nodes: Node...) -> Node {
        .div(.class("wrapper h-14"), .group(nodes))
    }

    static var gtag: Node {
        .noscript(.raw("""
        <iframe src="https://www.googletagmanager.com/ns.html?id=GTM-5K84TFL"
        height="0" width="0" style="display:none;visibility:hidden"></iframe>
        """))
    }

    static func header<T: Website>(
        for context: PublishingContext<T>,
        selectedSection: T.SectionID?
    ) -> Node {
        let sectionIDs = T.SectionID.allCases

        return .header(
            .wrapper(
                .a(.class("site-name"), .href("/"), .text(context.site.name)),
                .if(
                    sectionIDs.count > 1,
                    .nav(
                        .ul(.forEach(sectionIDs) { section in
                            .li(.a(
                                .class(section == selectedSection ? "selected" : ""),
                                .href(context.sections[section].path),
                                .text(context.sections[section].title)
                            ))
                        })
                    )
                )
            )
        )
    }

    static func appBanner(for language: Language, isSection: Bool) -> Node {
        let anotherLanguage = language.anotherLanguage

        return .header(
            .div(
                .wrapper(
                    .class("app-info"),
                    .class("wrapper"),
                    .img(
                        .class("app-icon"),
                        .src(isSection ? "../image/icon.png" : "image/icon.png")
                    ),
                    .p(
                        .class("site-name"),
                        .text(language.appTitle)
                    ),
                    .p(
                        .class("site-description-set"),
                        .span(
                            .class("site-description-main"),
                            .text(language.appDescription.0)
                        ),
                        .span(
                            .class("site-description-sub"),
                            .text(language.appDescription.1)
                        ),
                        .span(
                            .class("site-description-fade"),
                            .text(language.appDescription.2)
                        )
                    ),
                    .div(
                        .class("page-link-wrapper"),
                        .p(
                            .class("page-link"),
                            .a(
                                .href(language.faqLink),
                                .text(language.faqTitle)
                            )
                        ),
                        .p(
                            .class("page-link"),
                            .a(
                                .href(language.changelogLink),
                                .text(language.changelogTitle)
                            )
                        ),
                        .p(
                            .class("page-link"),
                            .a(
                                .href(language.githubLink),
                                .text("Github")
                            )
                        ),
                        .p(
                            .class("page-link"),
                            .a(
                                .href(anotherLanguage.url),
                                .text(anotherLanguage.title)
                            )
                        )
                    )
                ),
                .div(
                    .class("download-link-container"),
                    .downloadLink(
                        id: "download-trial",
                        url: language.downloadLink,
                        title: language.downloadLinkTitle
                    ),
                    .purchaseLink(
                        id: "purchase",
                        url: language.purchaseLink,
                        title: language.purchaseLinkTitle,
                        language: language,
                        description: language.purchaseLinkDescription
                    ),
                    .div(
                        .id("currency-picker-wrapper"),
                        .class("currency-picker-wrapper hidden"),
                        .component(
                            CurrencyPicker()
                                .environmentValue(language, key: .language)
                        )
                    )
                )
            )
        )
    }

    static func downloadLink(
        id: String,
        url: URL,
        title: String,
        description: String = ""
    ) -> Node {
        return .p(
            .class("download-link"),
            .span(
                .class("download-link-arrow")
            ),
            .a(
                .id(id),
                .href(url),
                .text(title),
                .span(
                    .class("download-link-description"),
                    .text(description)
                )
            )
        )
    }

    static func purchaseLink(
        id: String,
        url _: URL,
        title: String,
        language _: Language,
        description: String = ""
    ) -> Node {
        return .p(
            .class("download-link"),
            .span(
                .class("download-link-arrow")
            ),
            .a(
                .id(id),
                .span(
                    .id("purchase-title"),
                    .text(title)
                ),
                .span(
                    .class("download-link-description"),
                    .text(description)
                ),
                .onclick("""
                let isDisplayed = window.isCurrencyPickerDisplayed;
                let picker = document.getElementById('currency-picker-wrapper');
                if (isDisplayed != undefined && isDisplayed) {
                    picker.className = 'currency-picker-wrapper hidden';
                    window.isCurrencyPickerDisplayed = false;
                } else {
                    picker.className = 'currency-picker-wrapper displayed';
                    window.isCurrencyPickerDisplayed = true;
                }
                """)
            )
        )
    }

    static func itemList<T: Website>(for items: [Item<T>], on site: T) -> Node {
        return .ul(
            .class("item-list"),
            .forEach(items) { item in
                .li(.article(
                    .h1(.a(
                        .href(item.path),
                        .text(item.title)
                    )),
                    .tagList(for: item, on: site),
                    .p(.text(item.description))
                ))
            }
        )
    }

    static func tagList<T: Website>(for item: Item<T>, on site: T) -> Node {
        return .ul(.class("tag-list"), .forEach(item.tags) { tag in
            .li(.a(
                .href(site.path(for: tag)),
                .text(tag.string)
            ))
        })
    }

    static func footer(for language: Language) -> Node {
        return .footer(
            .wrapper(
                .p(.text("Copyright © 2020")),
                .p(.a(
                    .text(language.contact),
                    .href("mailto:abnormalmouseapp@intii.com")
                ))
            ),
            .div(
                .class("h-20 w-full")
            ),
            .div(
                .class("flex fixed w-full right-0 bottom-0 px-6 pt-2 pb-6 flex-row justify-center md:justify-end"),
                .component(ProductHuntBadge())
            ),
            .dynamicPrice(for: language),
            .script(.attribute( // Gtag
                .src(URL(string: "https://www.googletagmanager.com/gtag/js?id=UA-17603222-4")!)
            ))
        )
    }

    static func dynamicPrice(for language: Language) -> Node {
        let isEnglish = language == .english ? "true" : "false"
        return .script(
            .raw("""
            fetch("https://abnormalmouse-api.intii.com/product/price", {
                  "method": "GET",
                  "headers": {
                        "Accept": "application/json"
                  }
            })
            .then((res) => res.json())
            .then((object) => {
                const element = window.document.getElementById('purchase-title');
                if (\(isEnglish)) {
                    element.innerHTML = `Buy now for ${object["display"]}. `;
                } else {
                    element.innerHTML = `立即购买只需 ${object["display"]}。`
                }
            })
            .catch(console.error.bind(console));
            """))
    }
}
