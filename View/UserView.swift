import SwiftUI

struct UserView: View {
    @ObservedObject var viewModel: UserViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    if let error = viewModel.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .padding()
                            .multilineTextAlignment(.center)
                        
                        Button("Try Again") {
                            viewModel.fetchUsers()
                        }
                        .padding()
                    }

                    List(viewModel.users) { user in
                        HStack {
                           
                            Text(user.name)
                            Spacer()
                            Button(action: {
                                viewModel.toggleFavorite(for: user)
                            }) {
                                Image(systemName: viewModel.isFavorite(user) ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(viewModel.isFavorite(user) ? .blue : .gray)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .padding(.vertical, 10)
                    }
                }
                .navigationTitle("Users")
                .opacity(viewModel.state == .idle ? 1.0 : 0.5)
                
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
