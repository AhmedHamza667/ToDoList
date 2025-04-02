//
//  ContentView.swift
//  ToDoListCoreData
//
//  Created by Ahmed Hamza on 3/10/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var vm = CoreDataViewModel()
    @State private var isShowingModal = false
    @State private var item = ""
    @State private var isAddNewItem: Bool = true
    @State private var selectedEntity: ToDoListItem? = nil
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    if vm.savedEntities.isEmpty {
                        VStack(spacing: 15){
                            Image("mainImg")
                                .resizable()
                                .frame(width: 290, height: 202)
                                .scaledToFit()
                            Text("Empty List!")
                                .font(.title2)
                                .bold()
                            Text("Click the button to add something exciting!")
                        }
                        .padding()
                    } else {
                        List {
                            ForEach(vm.savedEntities, id: \.self) { item in
                                HStack {
                                    Button(action: {
                                        vm.toggleCompletion(item: item)
                                    }) {
                                        Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                                            .foregroundColor(item.isCompleted ? .green : .gray)
                                    }
                                    
                                    Text(item.item ?? "No Title")
                                        .strikethrough(item.isCompleted)
                                        .foregroundColor(item.isCompleted ? .gray : .primary)
                                        .onTapGesture {
                                            selectedEntity = item
                                            isAddNewItem = false
                                            isShowingModal.toggle()
                                        }
                                }
                            }
                            .onDelete(perform: vm.deleteItem)
                        }
                    }
                }
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        
                        Button {
                            isAddNewItem = true
                            isShowingModal.toggle()
                        } label: {
                            Image(systemName: "plus")
                                .frame(width: 50, height: 50)
                                .foregroundStyle(.white)
                                .background {
                                    Circle()
                                        .fill(Color(#colorLiteral(red: 0.3007706702, green: 0.3666899204, blue: 0.9475060105, alpha: 1)))
                                }
                                .shadow(radius: 5)
                                .padding()
                        }
                    }
                }
            }
            .listStyle(PlainListStyle())
            .sheet(isPresented: $isShowingModal) {
                ModalView(isPresented: $isShowingModal, title: $item, vm: vm, isAddNewItem: isAddNewItem, selectedEntity: selectedEntity)
            }
            .navigationTitle("To Do List")
        }
    }
}

struct ModalView: View {
    @Binding var isPresented: Bool
    @Binding var title: String
    @ObservedObject var vm: CoreDataViewModel
    var isAddNewItem: Bool
    var selectedEntity: ToDoListItem?
    
    var body: some View {
        VStack(spacing: 20) {
            Text(isAddNewItem ? "Add a todo item" : "Edit a todo item")
                .font(.headline)
            
            TextField("Title", text: $title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .onAppear {
                    if !isAddNewItem, let entity = selectedEntity {
                        title = entity.item ?? ""
                    } else {
                        title = ""
                    }
                }
            HStack {
                Button("Cancel") {
                    isPresented = false
                }
                .buttonStyle(.bordered)
                .padding()
                
                Button(isAddNewItem ? "Add" : "Edit") {
                    if title.isEmpty { return }
                    if isAddNewItem {
                        vm.addItem(item: title)
                    } else if let entity = selectedEntity {
                        vm.updateItem(item: entity, newText: title)
                    }
                    isPresented = false
                }
                .buttonStyle(.borderedProminent)
                .padding()
                
            }
            Button("Delete all") {
                vm.deleteAll()
                isPresented = false
            }
            .buttonStyle(.bordered)
            .background(Color.red)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
