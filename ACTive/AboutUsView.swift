//
//  AboutUsView.swift
//  ACTive
//
//  Created by Gabriel Wang on 12/21/23.
//

import SwiftUI
import BetterSafariView

struct AboutUsView: View {
    @State private var presentingSafariView=false
    var body: some View {
        NavigationStack{
            VStack{
                Text("Team introduction").padding()
                Button(action: {
                    self.presentingSafariView.toggle()
                }){
                    Label("Open our team blog",systemImage: "safari")
                }.safariView(isPresented: $presentingSafariView){
                    SafariView(
                        url: URL(string: "https://activeadhd.wordpress.com")!,
                    configuration: SafariView.Configuration(
                    entersReaderIfAvailable: true,
                    barCollapsingEnabled: true))
                }
            }
                .navigationTitle("About Us")
        }
    }
}
