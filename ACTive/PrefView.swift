//
//  AccountView.swift
//  ACTive
//
//  Created by Gabriel Wang on 12/21/23.
//

import SwiftUI

struct PrefView: View {
    @State var accountGo=false
    var body: some View {
        NavigationStack{
            List{
                NavigationLink(destination: AccountView()){
                    Label("Account",systemImage: "person.circle")
                }
            }
            .navigationTitle("Me")
        }
    }
}

#Preview {
    PrefView()
}
