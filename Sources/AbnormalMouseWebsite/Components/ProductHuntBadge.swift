import Foundation
import Plot

struct ProductHuntBadge: Component {
    var body: Component {
        Div {
            Link(url: "https://www.producthunt.com/posts/abnormal-mouse?utm_source=badge-featured&utm_medium=badge&utm_souce=badge-abnormal&#0045;mouse") {
                Image(
                    url: "https://api.producthunt.com/widgets/embed-image/v1/featured.svg?post_id=333498&theme=neutral",
                    description: "Abnormal&#0032;Mouse - Swipe&#0044;&#0032;zoom&#0044;&#0032;and&#0032;rotate&#0032;with&#0032;a&#0032;&#0039;normal&#0039;&#0032;mouse&#0032;in&#0032;macOS | Product Hunt"
                )
                .class("h-12")
            }
            .linkTarget(.blank)
        }
    }
}
