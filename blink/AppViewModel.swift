import SwiftUI

class AppViewModel: ObservableObject {
    @Published var showBreakWindow = false
    @Published var showSettingsWindow = false
}
