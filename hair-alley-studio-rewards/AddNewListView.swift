//
//  AddNewListView.swift
//  alley-studio-rewards
//
//  Created by Bryce Nguyen on 2022-06-17.
//

import SwiftUI

struct AddNewListView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var isPresented: Bool = false

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    @Environment(\.presentationMode) var presentationMode
    // Create new variables to submit
    @State private var newListName: String = ""
    @State private var newListNum: Int64 = 0
    
    var onSave: (String, Int64) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing:20) {
            
            HStack {
                Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }.frame(maxWidth: .infinity, alignment: .leading)
                Button("Done") {
                    // onsave
                    let newItem = Item(context: viewContext)
                    newItem.timestamp = Date()
                    presentationMode.wrappedValue.dismiss()
                }.disabled(newListName.isEmpty)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            
            VStack {
                TextField("List Name", text: $newListName)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                TextField("Number of Rewards", value: $newListNum, format: .number)
                    .textFieldStyle(.roundedBorder)
                    .padding()
            }
            .frame(height: 200)
            .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
            
            Spacer()
            
        }.padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
    }
}

struct AddNewListView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewListView{
            _, _ in
        }
    }
}
