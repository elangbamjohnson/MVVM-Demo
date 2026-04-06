//
//  CheckoutView.swift
//  MVVM Demo
//
//  Created by Johnson on 06/04/26.
//

import SwiftUI

struct CheckoutView: View {
    var body: some View {
        NavigationView {
            Text("Checkout View Content")
                .navigationTitle("Checkout")
        }
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView()
    }
}
