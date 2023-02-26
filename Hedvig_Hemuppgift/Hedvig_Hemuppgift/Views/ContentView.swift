//
//  ContentView.swift
//  Hedvig_Hemuppgift
//
//  Created by Henrik Larsson on 2023-02-23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    var body: some View {
        NavigationView {
           SearchView()
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
