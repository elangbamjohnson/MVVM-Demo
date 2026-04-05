import SwiftUI

struct UserView: View {
    @ObservedObject var viewModel: UserViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                List(viewModel.users, id: \.name) { user in
                    Text(user.name)
                }
                .navigationTitle("Users")
                .opacity(viewModel.state == .idle ? 1.0 : 0.5)
                
                // Show Loading and Refreshing states
                if viewModel.state != .idle {
                    VStack {
                        Spacer()
                        Text(viewModel.state == .loading ? "Loading..." : "Refreshing...")
                            .font(.headline)
                            .foregroundColor(.blue)
                            .padding()
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(10)
                        Spacer()
                    }
                }
            }
        }
        .onAppear {
            viewModel.fetchUsers()
        }
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        // Mock data for preview could be added here
        let mockService = UserService()
        let mockStorage = FileUserStorage()
        let repository = UserRepository(service: mockService, storage: mockStorage)
        UserView(viewModel: UserViewModel(repository: repository))
    }
}
