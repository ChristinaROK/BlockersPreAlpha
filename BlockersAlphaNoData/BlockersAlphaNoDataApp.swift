//
//  BlockersAlphaNoDataApp.swift
//  BlockersAlphaNoData
//
//  Created by ssj on 2021/06/04.
//

import SwiftUI

@main
struct BlockersAlphaNoDataApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                UIMain()
            }
            //.navigationViewStyle(StackNavigationViewStyle())
            .environmentObject(BlockerViewModel())
            .environmentObject(ImageViewModel())
            .environmentObject(NewBlockerViewModel())
        }
    }
}
