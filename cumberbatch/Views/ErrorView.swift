//
//  ErrorView.swift
//  cumberbatch
//
//  Created by Steven Rockarts on 2024-08-07.
//

import SwiftUI

struct ErrorView: View {
    let error: MovieDBError
    let retryAction: () -> Void
    
    var body: some View {
        VStack {
            Text("Error: \(error.localizedDescription)")
                .multilineTextAlignment(.center)
                .padding()
            
            Button("Retry") {
                retryAction()
            }
        }
    }
}
