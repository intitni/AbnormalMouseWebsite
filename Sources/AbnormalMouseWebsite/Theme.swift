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
        HTML(
            .lang(context.site.language),
            .theHead(for: page, on: context.site),
            .body(
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

private extension Node where Context == HTML.BodyContext {
    static func wrapper(_ nodes: Node...) -> Node {
        .div(.class("wrapper"), .group(nodes))
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
                    .p(
                        .class("language-switcher"),
                        .a(
                            .href(anotherLanguage.url),
                            .text(anotherLanguage.title)
                        )
                    )
                ),
                .div(
                    .class("download-link-container"),
                    .downloadLink(url: language.downloadLink, title: language.downloadLinkTitle),
                    .downloadLink(
                        url: language.purchaseLink,
                        title: language.purchaseLinkTitle,
                        description: language.purchaseLinkDescription
                    )
                )
            )
        )
    }

    static func downloadLink(url: URL, title: String, description: String = "") -> Node {
        return .p(
            .class("download-link"),
            .span(
                .class("download-link-arrow")
            ),
            .a(
                .href(url),
                .text(title),
                .span(
                    .class("download-link-description"),
                    .text(description)
                )
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
                    .href("mailto:abnormalmouse@intii.com")
                ))
            )
        )
    }
}

extension Node where Context == HTML.DocumentContext {
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
            .twitterCardType(.summary),
            .forEach(["/styles.css"], { .stylesheet($0) }),
            .viewport(.accordingToDevice),
            .unwrap(site.favicon, { .favicon($0) }),
            .unwrap(location.imagePath ?? site.imagePath, { path in
                let url = site.url(for: path)
                return .socialImageLink(url)
            }),
            .script(.attribute(
                .src(URL(string: "https://www.googletagmanager.com/gtag/js?id=UA-17603222-4")!)
            )),
            .script(
                .raw("""
                window.dataLayer = window.dataLayer || [];
                function gtag(){dataLayer.push(arguments);}
                gtag('js', new Date());
                gtag('config', 'UA-17603222-4');
                """)
            )
        )
    }
}
