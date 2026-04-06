//
//  AppTabView.swift
//  MVVM Demo
//
//  Created by Johnson on 06/04/26.
//

import SwiftUI
    
struct AppTabView: View {
    
    @StateObject private var userViewModel = UserViewModel(repository:
                                                            UserRepository(
                                                                service: UserService(),
                                                                storage: FileUserStorage()
                                                            )
    )
    
    
    var body: some View {
        TabView {
            UserView(viewModel: userViewModel)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            FavoriteView()
                .tabItem {
                    Label("Favorite", systemImage: "heart")
                }
            
            CheckoutView()
                .tabItem {
                    Label("Checkout", systemImage: "cart")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
    }
}

struct AppTabView_Previews: PreviewProvider {
    static var previews: some View {
        AppTabView()
    }
}
