//
//  HomeView.swift
//  MVVM Demo
//
//  Created by Johnson on 06/04/26.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            Text("Home View Content")
                .navigationTitle("Home")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
