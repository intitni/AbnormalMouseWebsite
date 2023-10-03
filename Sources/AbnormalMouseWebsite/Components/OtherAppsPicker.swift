import Foundation
import Plot

struct OtherAppPicker: Component {
    var body: Component {
        Div {
            Div {
                Span("MORE")
                Span("APPS")
            }.class("text-[8px] flex flex-col items-center justify-center font-bold space-y-[0px] text-neutral-700")
            Div {
                Link(url: "https://markinside.intii.com") {
                    Image(url: "https://markinside.intii.com/AppIcon.png", description: "MarkInside")
                        .class("h-[40px]")
                }.class("h-[fill-available]")
            }
        }.class("h-[48px] bg-white rounded-lg flex items-center justify-center pl-3 pr-2 py-0.5 space-x-1.5 border-[1px] border-gray-200 border-solid")
    }
}
