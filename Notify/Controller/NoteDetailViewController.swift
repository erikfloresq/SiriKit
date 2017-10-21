//
//  NoteDetailViewController.swift
//  Siri
//
//  Created by Erik on 9/3/17.
//  Copyright © 2017 Erik Flores. All rights reserved.
//

import UIKit

class NoteDetailViewController: UIViewController {
    
    @IBOutlet weak var noteTextView: UITextView!
    var note:Note?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = note?.title
        noteTextView.text = note?.content
    }

}
