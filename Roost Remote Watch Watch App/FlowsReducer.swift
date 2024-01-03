//
//  FlowsReducer.swift
//  Roost Remote Watch Watch App
//
//  Created by Elliot Schrock on 10/7/23.
//  Copyright © 2023 Elliot Schrock. All rights reserved.
//

import Foundation
import ComposableArchitecture
import WatchConnectivity

//public struct FlowsReducer: Reducer {
//    @Dependency(\.watchConnectivityClient) var watchClient
//    
//    public struct State: Equatable {
//        var data = [Flow]()
//    }
//    
//    public enum Action: Equatable {
//        case onAppear
//        case dataNeedsReload
//    }
//    
//    public var body: some Reducer<State, Action> {
//        Reduce { state, action in
//            switch action {
//            case .onAppear:
//                watchClient.session.sendMessage(["phrases": try? JSONEncoder().encode(state.data)], replyHandler: { _ in
//                    print("reply")
//                })
//                return .run { send in
//                    await self.onTask(send: send)
//                }
//                
//            case .dataNeedsReload:
//                let data = loadData()
//                if data != state.data {
//                    watchClient.session.sendMessage(["phrases": try? JSONEncoder().encode(state.data)], replyHandler: { _ in
//                        print("reply")
//                    })
//                }
//                state.data = data
//                
//            case .addPhrase(let phrase):
//                var data = state.data
//                data.insert(phrase, at: 0)
//                state.data = data
//                save(data)
//                watchClient.session.sendMessage(["phrases": try? JSONEncoder().encode(data)], replyHandler: { _ in
//                    print("reply")
//                })
//                
//            case .removePhrase(id: let id): break
////                state.list.remove(at: state.list.)
//            case .shuffle: break
//                
//            case .sortByRecent:
//                state.sort(by: .recent)
//            case .sortByAlphabet:
//                state.sort(by: .alphabet)
//            }
//            return .none
//        }
//    }
//    
//    private func onTask(send: Send<Action>) async {
//        await withTaskGroup(of: Void.self) { group in
//            group.addTask {
//                do {
//                    for try await message in self.watchClient.start() {
//                        if let data = message["flows"] as? Data, let flows = try? JSONDecoder().decode([Flow].self, from: data) {
//                            save(flows: flows)
//                            await send(.dataNeedsReload)
//                        }
//                    }
//                } catch {
//                    // TODO: Handle error
//                }
//            }
//        }
//    }
//}
