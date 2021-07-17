//
//  NotesViewModel.swift
//  Notes
//
//  Created by John Royal on 7/10/21.
//

import Foundation
import Combine

class NotesViewModel: ObservableObject {
  @Published var notes: [Note] = []
  @Published var editingNote: Note.ID?
  
  func createNote() {
    let note = Note(id: UUID(), title: "New Note", content: "")
    notes.append(note)
    editingNote = note.id
  }
  
  func handleDelete(_ indexSet: IndexSet) {
    notes.remove(atOffsets: indexSet)
  }
  
  // MARK: - Persistence
  // Add your code here
  
  private var notesFile: URL {
    let directory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    return directory
      .appendingPathComponent("notes")
      .appendingPathExtension(for: .json)
  }
  
  func load() throws {
    guard FileManager.default.isReadableFile(atPath: notesFile.path) else { return }
    let data = try Data(contentsOf: notesFile)
    notes = try JSONDecoder().decode([Note].self, from: data)
  }
  
  func save() throws {
    let data = try JSONEncoder().encode(notes)
    try data.write(to: notesFile)
  }
}
