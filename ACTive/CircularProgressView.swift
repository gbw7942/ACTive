//
//  CircularProgressView.swift
//  ACTive
//
//  Created by Gabriel Wang on 12/22/23.
//

import SwiftUI

struct CircularProgressView: View {
    @State var progress=0.0
    var progressPercent: Int{Int(round(progress*100))}
    var body: some View {
        VStack {
            Text("Today's task: ").font(.title).bold().padding()
            Spacer()
            ZStack {
                Circle()
                    .stroke(Color.pink.opacity(0.3),lineWidth: 30)
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(Color.pink,style: StrokeStyle(lineWidth: 30,lineCap: .round))
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeOut, value: progress)
                Text("\(progressPercent)%").font(.title)
            }
            Slider(value: $progress, in: 0...1, step: 0.01).padding()
        }.frame(width: 300,height: 350)
    }
}

#Preview {
    CircularProgressView()
}



