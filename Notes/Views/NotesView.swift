//
//  NotesView.swift
//  Notes
//
//  Created by John Royal on 7/10/21.
//

import SwiftUI

struct NotesView: View {
  @StateObject var viewModel = NotesViewModel()
  
  var body: some View {
    NavigationView {
      List {
        ForEach(viewModel.notes) { note in
          NavigationLink(
            note.title,
            destination: EditNoteView(note: binding(for: note)),
            tag: note.id,
            selection: $viewModel.editingNote
          )
        }
        .onDelete(perform: viewModel.handleDelete(_:))
      }
      .navigationBarItems(trailing: Button(action: viewModel.createNote) {
        Label("New Note", systemImage: "plus.circle.fill")
      })
      .navigationTitle("My Notes")
    }
    // MARK: - Persistence
    // Add your code here
    .onAppear {
      try! viewModel.load()
    }
    .onChange(of: viewModel.notes) { _ in
      try! viewModel.save()
    }
  }
  
  private func binding(for note: Note) -> Binding<Note> {
    guard let index = viewModel.notes.firstIndex(of: note) else {
      fatalError("Cannot find note: \(note)")
    }
    return $viewModel.notes[index]
  }
}

struct NotesView_Previews: PreviewProvider {
  static var previews: some View {
    NotesView()
  }
}
