//
//  ContentView.swift
//  Circle Record
//
//  Created by watabe on 2020/04/19.
//  Copyright © 2020 watabe. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var selection = 0
 
    var body: some View {
        TabView {
            EventLogView()
                .tabItem {
                    VStack {
                        Image(systemName: "a")
                        Text("イベント記録")
                    }
            }.tag(0)
            CashBookLog()
                .tabItem {
                    VStack {
                        Image(systemName: "bold")
                        Text("出納帳")
                    }
            }.tag(1)
        }
//        TabView(selection: $selection){
//            Text("First View")
//                .font(.title)
//                .tabItem {
//                    VStack {
//                        Image("first")
//                        Text("Event log")
//                    }
//                }
//                .tag(0)
//            Text("Second View")
//                .font(.title)
//                .tabItem {
//                    VStack {
//                        Image("second")
//                        Text("Cashbook")
//                    }
//                }
//                .tag(1)
//
//        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
