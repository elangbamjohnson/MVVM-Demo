//
//  FavoriteView.swift
//  MVVM Demo
//
//  Created by Johnson on 06/04/26.
//

import SwiftUI

struct FavoriteView: View {
    var body: some View {
        NavigationView {
            Text("Favorite View Content")
                .navigationTitle("Favorite")
        }
    }
}

struct FavoriteView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteView()
    }
}
