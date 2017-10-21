//
//  NotesTableViewController.swift
//  Notify
//
//  Created by Erik on 10/20/17.
//  Copyright © 2017 Erik Flores. All rights reserved.
//

import UIKit

class NotesTableViewController: UITableViewController {

    let noteCell = "noteCell"
    let noteDetailSegue = "noteDetailSegue"
    var notes: [Note] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    let refreshAction = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(addStoredDataToMemory), name: NSNotification.Name("AddNote"), object: nil)
        configRefreshController()
        addStoredDataToMemory()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == noteDetailSegue {
            guard let noteDetailViewController = segue.destination as? NoteDetailViewController else {
                fatalError("Error parsing NoteDetailViewController")
            }
            let indexPath = self.tableView.indexPathForSelectedRow
            noteDetailViewController.note = notes[(indexPath?.row)!]
        }
    }
    
    @IBAction func addNote(_ sender: UIBarButtonItem) {
        showAlertForAddNote()
    }
    
    func configRefreshController() {
        refreshAction.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        refreshAction.addTarget(self, action: #selector(refreshStoreData), for: .valueChanged)
        self.tableView.refreshControl = refreshAction
    }
    
    @objc
    func refreshStoreData(_ sender:UIRefreshControl) {
        sender.endRefreshing()
        self.addStoredDataToMemory()
    }
    
    @objc
    func addStoredDataToMemory() {
        notes = []
        let storeNotes: [String: String] = NotesManager.sharedInstance.notes()
        for (_, item) in storeNotes.enumerated() {
            if let note = NotesManager.sharedInstance.findNote(withName: "Prueba one") {
                print("note -- \(note)")
            }
            self.notes.append(Note(title: item.key, content: item.value, groupName: item.key))
        }
    }
    
    func showAlertForAddNote() {
        let alert = UIAlertController(title: "Notes", message: "Add new Note", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default) { (alertAction) in
            let titleNote = alert.textFields![0].text
            let contentNote = alert.textFields![1].text
            NotesManager.sharedInstance.add(note: contentNote!, toGroup: titleNote!)
            self.addStoredDataToMemory()
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .destructive)
        alert.addTextField { (textField) in
            textField.placeholder = "Title for your note"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "content for your note"
        }
        alert.addAction(okButton)
        alert.addAction(cancelButton)
        self.present(alert, animated: true, completion: nil)
    }

}

//MARK: - UITableViewDataSource
extension NotesTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: noteCell, for: indexPath)
        guard let noteCell = cell as? NoteTableViewCell else {
            fatalError("Errro parsing NoteTableViewCell")
        }
        noteCell.title.text = notes[indexPath.row].title
        noteCell.content.text = notes[indexPath.row].content
        return noteCell
    }
}

//MARK: - UITableViewDelegate
extension NotesTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: noteDetailSegue, sender: nil)
    }
    
}
