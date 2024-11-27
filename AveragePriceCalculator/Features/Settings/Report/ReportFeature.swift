//
//  ReportFeature.swift
//  AveragePriceCalculator
//
//  Created by Davidyoon on 11/21/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct ReportFeature {
    
    @ObservableState
    struct State: Equatable {
        let email: String = "qqpo12@naver.com"
    }
    
    enum Action {
        
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            }
        }
    }
    
}

import SwiftUI
import MessageUI
struct ReportView: View {

    let store: StoreOf<ReportFeature>

    var body: some View {
        VStack {
            if MFMailComposeViewController.canSendMail() {
                EmailView(to: store.email)
            } else {
                VStack {
                    Image(systemName: "nosign")
                        .resizable()
                        .frame(width: 124.0, height: 124.0)
                        .foregroundStyle(.red)
                        .padding(.vertical)

                    Text("Email functionality is not available on this device.\nPlease check your email configuration and try again.")
                        .bold()
                }
                .padding()
            }
        }
    }
    
}

#Preview {
    ReportView(store: Store(initialState: ReportFeature.State(), reducer: {
        ReportFeature()
    }))
}
