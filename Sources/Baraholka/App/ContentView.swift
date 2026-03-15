import SwiftUI
import BaraholkaCore

/// Root tab-bar view of the application.
struct ContentView: View {
    @State private var selectedTab: Tab = .home

    enum Tab: Int {
        case home, search, newListing, messages, profile
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(Tab.home)

            SearchView()
                .tabItem {
                    Label("Browse", systemImage: "magnifyingglass")
                }
                .tag(Tab.search)

            CreateListingView()
                .tabItem {
                    Label("Sell", systemImage: "plus.circle.fill")
                }
                .tag(Tab.newListing)

            MessagesView()
                .tabItem {
                    Label("Messages", systemImage: "message.fill")
                }
                .tag(Tab.messages)

            ProfileView(user: User.currentUser, isCurrentUser: true)
                .tabItem {
                    Label("Profile", systemImage: "person.circle.fill")
                }
                .tag(Tab.profile)
        }
        .tint(.orange)
    }
}

#Preview {
    ContentView()
}
