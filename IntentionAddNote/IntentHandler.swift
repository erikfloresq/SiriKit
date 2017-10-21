//
//  IntentHandler.swift
//  IntentionAddNote
//
//  Created by Erik on 10/20/17.
//  Copyright © 2017 Erik Flores. All rights reserved.
//

import Intents

// As an example, this class is set up to handle Message intents.
// You will want to replace this or add other intents as appropriate.
// The intents you wish to handle must be declared in the extension's Info.plist.

// You can test your example integration by saying things to Siri like:
// "Send a message using <myApp>"
// "<myApp> John saying hello"
// "Search for messages in <myApp>"

class IntentHandler: INExtension {
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return self
    }
    
}

//MARK: - INCreateNoteIntentHandling

extension IntentHandler: INCreateNoteIntentHandling {
    
    func resolveGroupName(for intent: INCreateNoteIntent, with completion: @escaping (INSpeakableStringResolutionResult) -> Void) {
        print("Resolve Group \(intent)")
        if let text = intent.title {
            completion(INSpeakableStringResolutionResult.success(with: text))
        } else {
            completion(INSpeakableStringResolutionResult.needsValue())
        }
    }
    
    func resolveTitle(for intent: INCreateNoteIntent, with completion: @escaping (INSpeakableStringResolutionResult) -> Void) {
        print("Resolve Title \(intent)")
        if let text = intent.title {
            completion(INSpeakableStringResolutionResult.success(with: text))
        } else {
            completion(INSpeakableStringResolutionResult.needsValue())
        }
    }
    
    func resolveContent(for intent: INCreateNoteIntent, with completion: @escaping (INNoteContentResolutionResult) -> Void) {
        print("Resolve Content \(intent)")
        if let text = intent.content {
            completion(INNoteContentResolutionResult.success(with: text))
        } else {
            completion(INNoteContentResolutionResult.needsValue())
        }
    }
    
    func confirm(intent: INCreateNoteIntent, completion: @escaping (INCreateNoteIntentResponse) -> Void) {
        print("Confirm create \(intent)")
        let userActivity = NSUserActivity(activityType: NSStringFromClass(INCreateNoteIntent.self))
        let response = INCreateNoteIntentResponse(code: .ready, userActivity: userActivity)
        completion(response)
    }
    
    func handle(intent: INCreateNoteIntent, completion: @escaping (INCreateNoteIntentResponse) -> Void) {
        print("handle \(intent)")
        print("save title \((intent.content?.value(forKey: "text"))!)")
        print("group \((intent.title?.spokenPhrase)!)")
        NotesManager.sharedInstance.add(note: (intent.content?.value(forKey: "text"))! as! String, toGroup: (intent.title?.spokenPhrase)!)
        let userActivity = NSUserActivity(activityType: NSStringFromClass(INCreateNoteIntent.self))
        let response = INCreateNoteIntentResponse(code: .success, userActivity: userActivity)
        response.createdNote = INNote(title: intent.title!, contents: [intent.content!], groupName: intent.groupName, createdDateComponents: nil, modifiedDateComponents: nil, identifier: nil)
        completion(response)
        NotificationCenter.default.post(name: NSNotification.Name("AddNote"), object:["addNote":true], userInfo: nil)
    }
    
}

//MARK: - INAppendToNoteIntentHandling

extension IntentHandler: INAppendToNoteIntentHandling {
    
    func resolveContent(for intent: INAppendToNoteIntent, with completion: @escaping (INNoteContentResolutionResult) -> Void) {
        print("Resolve Content \(intent)")
        if let text = intent.content {
            completion(INNoteContentResolutionResult.success(with: text))
        } else {
            completion(INNoteContentResolutionResult.needsValue())
        }
    }
    
    func confirm(intent: INAppendToNoteIntent, completion: @escaping (INAppendToNoteIntentResponse) -> Void) {
        print("Confirm Append \(intent)")
        let userActivity = NSUserActivity(activityType: NSStringFromClass(INAppendToNoteIntent.self))
        let response = INAppendToNoteIntentResponse(code: .ready, userActivity: userActivity)
        completion(response)
    }
    
    func handle(intent: INAppendToNoteIntent, completion: @escaping (INAppendToNoteIntentResponse) -> Void) {
        print("handle INAppendToNoteIntent - \(intent)")
        let userActivity = NSUserActivity(activityType: NSStringFromClass(INAppendToNoteIntent.self))
        let response = INAppendToNoteIntentResponse(code: .success, userActivity: userActivity)
        completion(response)
    }
    
}

