import SwiftUI

class AppViewModel: ObservableObject {
    @Published var showBreakWindow = false
    @Published var backToWorkWindow = false
    @Published var showSettingsWindow = false
}
