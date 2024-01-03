//
//  ContentView.swift
//  Roost Remote Watch Watch App
//
//  Created by Elliot Schrock on 10/7/23.
//  Copyright © 2023 Elliot Schrock. All rights reserved.
//

import SwiftUI
import WatchConnectivity
import UIKit

class FlowViewModel: ObservableObject {
    var session: WCSession
    var delegate: WatchConnectivityDelegate
    @Published var data: [Flow]
    
    init(session: WCSession = .default, delegate: WatchConnectivityDelegate = WatchConnectivityDelegate({}, didReceiveMessage: { _ in }), data: [Flow] = flows()) {
        self.session = session
        self.delegate = delegate
        self.data = data
        
        self.delegate.didReceiveMessage = { [weak self] message in
            if let data = message["flows"] as? Data, let flows = try? JSONDecoder().decode([Flow].self, from: data) {
                save(flows: flows)
                print(flows.count)
                self?.data = flows
            }
        }
    }
}

struct ContentView: View {
    @StateObject var viewModel = FlowViewModel()
    
    var body: some View {
        List(viewModel.data) { flow in
            Button(action: { flow.executeTasks() }) {
                Text(flow.name)
            }
        }.background(
            ZStack {
                Image("Roozzie")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                Rectangle().fill(Color(uiColor: UIColor(red: 72.0/255.0, green: 0.0/255.0, blue: 112.0/255.0, alpha: 0.75)))
            }
        )
        .onAppear {
            viewModel.session.delegate = viewModel.delegate
            viewModel.session.activate()
        }
    }
}

#Preview {
    ContentView()
}
