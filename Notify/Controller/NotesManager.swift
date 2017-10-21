//
//  NotesManager.swift
//  WerikNote
//
//  Created by Erik on 9/3/17.
//  Copyright © 2017 Erik Flores. All rights reserved.
//

import Foundation

class NotesManager {
    private var savedNotes: [String : String] = [String : String]()
    static let NotesKey = "notes"
    static let GroupId = "group.com.erikfloresq.Siri"
    static let sharedInstance = NotesManager()
    let sharedDefaults = UserDefaults(suiteName: NotesManager.GroupId)
    
    init() {
        if let saved = sharedDefaults?.value(forKey: NotesManager.NotesKey) {
            savedNotes = saved as! [String : String]
        }
    }
    
    func notes() -> [String : String] {
        return savedNotes
    }
    
    func note(withName name: String) -> String {
        if let tasks = savedNotes[name] {
            return tasks
        }
        return ""
    }
    
    func createNote(name: String) {
        let note = ""
        updateSavedNotes(changedNote: note, groupName: name)
    }
    
    func deleteNote(name: String) {
        updateSavedNotes(changedNote: nil, groupName: name)
    }
    
    func add(note: String, toGroup groupName: String) {
        var simpleNote = savedNotes[groupName] == nil ? "" : savedNotes[groupName]!
        simpleNote.append(contentsOf: note)
        updateSavedNotes(changedNote: note, groupName: groupName)
    }
    
    /*func finish(note: String) {
        if let groupName = self.findTaskInList(withName: note) {
            var note = savedNotes[groupName]!
            if let index = note.index(of: note) {
                note.remove(at: index)
                updateSavedNotes(changedNote: note, groupName: groupName)
            }
        }
    }*/
    
    // MARK: private
    
    private func updateSavedNotes(changedNote: String?, groupName: String) {
        savedNotes[groupName] = changedNote
        sharedDefaults?.set(savedNotes, forKey: NotesManager.NotesKey)
        sharedDefaults?.synchronize()
    }
    
    func findNote(withName noteName: String) -> String? {
        for (noteName, note) in savedNotes {
            if note.contains(noteName) {
                return noteName
            }
        }
        return nil
    }
}
