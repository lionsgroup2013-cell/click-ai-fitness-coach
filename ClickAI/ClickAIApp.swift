import SwiftUI

@main
struct ClickAIApp: App {
    @State private var store = AppStore()

    init() {
        CFFontRegistrar.registerBundledFonts()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(store)
                .environment(\.font, CFFont.body(15))
                .preferredColorScheme(.dark)
                .tint(CFColor.accent)
        }
    }
}

