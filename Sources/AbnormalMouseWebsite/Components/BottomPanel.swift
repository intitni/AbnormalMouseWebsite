import Foundation
import Plot

struct BottomPanel: Component {
    var body: Component {
        Div {
            OtherAppPicker()
            ProductHuntBadge()
        }.class("flex fixed w-full right-0 bottom-0 px-6 pt-2 pb-6 flex-row justify-center md:justify-end space-x-2")
    }
}
