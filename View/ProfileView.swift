//
//  ProfileView.swift
//  MVVM Demo
//
//  Created by Johnson on 06/04/26.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationView {
            Text("Profile View Content")
                .navigationTitle("Profile")
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
