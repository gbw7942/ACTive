//
//  CoachRecordsView.swift
//  ACTive
//
//  Created by Gabriel Wang on 12/21/23.
//

import SwiftUI

struct CoachRecordsView: View {
    var body: some View {
        ScrollViewReader { proxy in
                    VStack {

                        List{
                            Section(header:Text("2021")){
                                Text("Meeting at December 3rd,2022")
                            }
                            Section(header:Text("2022")){
                                Text("Meeting at January 25th,2022")
                                Text("Meeting at February 16th,2022")
                                Text("Meeting at March 4th,2022")
                                Text("Meeting at April 9th,2022")
                                Text("Meeting at May 13th,2022")
                                Text("Meeting at June 15th,2022")
                                Text("Meeting at July 20th,2022")
                                Text("Meeting at September 10th,2022")
                                Text("Meeting at October 26th,2022")
                                Text("Meeting at December 6th,2022")
                            }
                            Section(header:Text("2023")){
                                Text("Meeting at May 14th,2023")
                                Text("Meeting at June 17th,2023")
                                Text("Meeting at July 20th,2023")
                                Text("Meeting at September 10th,2023")
                                Text("Meeting at October 26th,2023")
                                Text("Meeting at December 1st,2023")
                            }
                        }
                    }
                }

    }
}

#Preview {
    CoachRecordsView()
}
