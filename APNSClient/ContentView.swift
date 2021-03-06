//
//  ContentView.swift
//  APNSMessenger
//
//  Created by Thinh Nguyen on 2/20/21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: ViewModel
    @State var showAlert = false
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(alignment: .center) {
            HStack{
                Text("Receiver Token:")
                TextField("Device token", text: $viewModel.token)
            }
            .padding()
            
            HStack{
                Text("Title:")
                TextField("Message title", text: $viewModel.message.title)
            }
            .padding()
            
            HStack(alignment: .top) {
                Text("Body:")
                TextField("Message body", text: $viewModel.message.body)
            }
            .padding()
            
            HStack(alignment: .top) {
                Text("Data:")
                if #available(OSX 11.0, *) {
                    TextEditor(text: $viewModel.message.data)
                } else {
                    TextField("Message data", text: $viewModel.message.data)
                }
            }
            .padding()
            
            HStack {
                Toggle(isOn: $viewModel.contentAvailable) {
                    Text("Content Available")
                }.toggleStyle(CheckboxToggleStyle())
                Toggle(isOn: $viewModel.mutableContent) {
                    Text("Mutable content")
                }.toggleStyle(CheckboxToggleStyle())
            }
            
            Button("Send") {
                viewModel.sendNotification()
                showAlert = true
            }
            Spacer()
        }
        .alert(isPresented: $showAlert, content: {
            Alert(title: Text(""), message: Text(viewModel.result ?? ""), dismissButton: .default(Text("OK")))
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: ViewModel())
    }
}
