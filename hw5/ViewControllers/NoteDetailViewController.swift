//
//  NoteDetailViewController.swift
//  hw5
//
//  Created by Ani Lakirbaia on 05.02.25.
//import Foundation
import UIKit

class NoteDetailViewController: UIViewController, UITextViewDelegate {
    
    var note: Note?
    var noteColor : UIColor!
    
    var placeholderText : String = "Enter note content"
    
    let colors: [UIColor] = [
        UIColor(red: 1.0, green: 0.8, blue: 0.8, alpha: 1.0), // Light Red
        UIColor(red: 0.8, green: 1.0, blue: 0.8, alpha: 1.0), // Light Green
        UIColor(red: 1.0, green: 1.0, blue: 0.7, alpha: 1.0), // Light Yellow
        UIColor(red: 0.7, green: 0.85, blue: 1.0, alpha: 1.0)  // Light Blue
    ]
    
    private let DBContext = DBManager.shared.persistentContainer.viewContext
    
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter note title"
        textField.font = UIFont.boldSystemFont(ofSize: 20)
        textField.textColor =  UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
    
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let contentTextView: UITextView = {
        let textView = UITextView()
        textView.text = "Enter note content"
        textView.textColor = .lightGray
        textView.font = UIFont.systemFont(ofSize: 20)
        textView.backgroundColor = .clear
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private var colorIndex : Int?
    
    
    init(note: Note? = nil) {
        self.note = note
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentTextView.delegate = self
        title = note == nil ? "New Note" : "Edit Note"
        

        if let noteColorIndex = note?.color {
            noteColor = colors[Int(noteColorIndex)!]
        } else {
            colorIndex = Int.random(in: 0..<colors.count)
            noteColor = colors[Int(colorIndex!)]
        }
    
        setupUI()
        
        
        if let note = note {
            titleTextField.text = note.title
            contentTextView.text = note.text
            contentTextView.textColor =  UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
            
    
            if note.text?.isEmpty == true {
                contentTextView.text = placeholderText
                contentTextView.textColor = .lightGray
            }
        }
    }
    
    private func setupUI() {
        view.backgroundColor = noteColor
        navigationItem.hidesBackButton = false
        
        view.addSubview(titleTextField)
        view.addSubview(contentTextView)
        
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            contentTextView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 20),
            contentTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            contentTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            contentTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
        if isMovingFromParent {
            let title = titleTextField.text
            var content = contentTextView.text
            
            if content == placeholderText && contentTextView.textColor == .lightGray {
                content = ""
            }
            
            
            if title?.isEmpty == true && content?.isEmpty == true {
                        return
            }
            
            if let note = note {
                note.title = title
                note.text = content
            } else {
                let newNote = Note(context: DBContext)
                newNote.title = title
                newNote.text = content
                newNote.color = String(colorIndex!)
            }

           
            do {
                try DBContext.save()
            } catch {
                print("Failed to save note:", error)
            }
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholderText {
            textView.text = ""
            textView.textColor =  UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = placeholderText
            textView.textColor = .lightGray 
        }
    }
}
