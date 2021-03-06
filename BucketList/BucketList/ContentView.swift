//
//  ContentView.swift
//  BucketList
//
//  Created by Ma Xueyuan on 2019/12/14.
//  Copyright © 2019 Ma Xueyuan. All rights reserved.
//

import SwiftUI
import LocalAuthentication
import MapKit

struct AddButton: View {
    var centerCoordinate: CLLocationCoordinate2D
    @Binding var locations: [CodableMKPointAnnotation]
    @Binding var selectedPlace: MKPointAnnotation?
    @Binding var showingEditScreen: Bool
    
    var body: some View {
        Button(action: {
            // create a new location
            let newLocation = CodableMKPointAnnotation()
            newLocation.coordinate = self.centerCoordinate
            newLocation.title = "Example location"
            self.locations.append(newLocation)
            self.selectedPlace = newLocation
            self.showingEditScreen = true
        }) {
            Image(systemName: "plus")
            .padding()
            .background(Color.black.opacity(0.75))
            .foregroundColor(.white)
            .font(.title)
            .clipShape(Circle())
            .padding(.trailing)
        }
    }
}

struct BlueCircle: View {
    var body: some View {
        Circle()
        .fill(Color.blue)
        .opacity(0.3)
        .frame(width: 32, height: 32)
    }
}

struct ContentView: View {
    @State private var isUnlocked = false
    @State private var centerCoordinate = CLLocationCoordinate2D()
    @State private var locations = [CodableMKPointAnnotation]()
    @State private var selectedPlace: MKPointAnnotation?
    @State private var showingPlaceDetails = false
    @State private var showingEditScreen = false
    @State private var showingAuthenticateFail = false
    
    var body: some View {
        ZStack {
            if isUnlocked {
                MapView(centerCoordinate: $centerCoordinate, selectedPlace: $selectedPlace, showingPlaceDetails: $showingPlaceDetails, annotations: locations)
                    .edgesIgnoringSafeArea(.all)
                
                BlueCircle()
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        AddButton(centerCoordinate: centerCoordinate, locations: $locations, selectedPlace: $selectedPlace, showingEditScreen: $showingEditScreen)
                    }
                }
                .alert(isPresented: $showingPlaceDetails) {
                    Alert(title: Text(selectedPlace?.title ?? "Unknown"), message: Text(selectedPlace?.subtitle ?? "Missing place information."), primaryButton: .default(Text("OK")), secondaryButton: .default(Text("Edit")) {
                        // edit this place
                        self.showingEditScreen = true
                    })
                }
                .sheet(isPresented: $showingEditScreen, onDismiss: saveData) {
                    if self.selectedPlace != nil {
                        EditView(placemark: self.selectedPlace!)
                    }
                }
                .onAppear(perform: loadData)
            } else {
                Button("Unlock Places") {
                    self.authenticate()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(Capsule())
                .alert(isPresented: $showingAuthenticateFail) { () -> Alert in
                    Alert(title: Text("Authentication Failed"), message: Text(""), dismissButton: .default(Text("OK")))
                }
            }
        }
        
    }
    
    func loadData() {
        if let locations:[CodableMKPointAnnotation]  = FileManager.default.load(from: "SavedPlaces") {
            self.locations = locations
        }
    }
    
    func saveData() {
        FileManager.default.save(locations, to: "SavedPlaces")
    }
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?

        // check whether biometric authentication is possible
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            // it's possible, so go ahead and use it
            let reason = "Please authenticate yourself to unlock your places."

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                // authentication has now completed
                DispatchQueue.main.async {
                    if success {
                        // authenticated successfully
                        self.isUnlocked = true
                    } else {
                        // there was a problem
                        self.showingAuthenticateFail = true
                    }
                }
            }
        } else {
            // no biometrics
            self.showingAuthenticateFail = true
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
