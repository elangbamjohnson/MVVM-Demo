import SwiftUI

struct FavoriteView: View {
    @ObservedObject var viewModel: UserViewModel
    
    var body: some View {
        NavigationView {
            List {
                let favoriteUsers = viewModel.users.filter { viewModel.isFavorite($0) }
                
                if favoriteUsers.isEmpty {
                    Text("No favorites yet.")
                        .foregroundColor(.gray)
                } else {
                    ForEach(favoriteUsers) { user in
                        Text(user.name)
                            .padding(.vertical, 10)
                    }
                }
            }
            .navigationTitle("Favorites")
        }
    }
}
