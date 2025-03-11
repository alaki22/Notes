//
//  NotesViewController.swift
//  hw5
//
//  Created by Ani Lakirbaia on 05.02.25.
//

import Foundation
import UIKit
import CoreData

class NotesViewController: UIViewController, PinterestLayoutDelegate {
    
    private var addAction: UIAlertAction?
    private let DBContext = DBManager.shared.persistentContainer.viewContext
    private var notes : [Note] = []
    
    private let collectionView: UICollectionView = {
        let layout = PinterestLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    
    



    override func viewDidLoad() {
        super.viewDidLoad()
        title = " Recent Notes"
        view.backgroundColor = UIColor(red: 0.8, green: 0.93, blue: 1.0, alpha: 1.0)
        
        setupNavigationBar()
        setupCollectionView()
    }
    
    
    private func setupNavigationBar(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
        navigationController?.navigationBar.titleTextAttributes = [
                .foregroundColor: UIColor.gray
            ]
        navigationController?.navigationBar.tintColor = .gray
        navigationController?.navigationBar.isTranslucent = true
                navigationController?.navigationBar.barTintColor = nil
                navigationController?.navigationBar.shadowImage = UIImage()
                navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationItem.backButtonTitle = ""
    }
    
    private func setupCollectionView() {
        if let pinterestLayout = collectionView.collectionViewLayout as? PinterestLayout {
               pinterestLayout.delegate = self
           }
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(NoteCell.self, forCellWithReuseIdentifier: "NoteCell")
        collectionView.backgroundColor = .clear
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
            collectionView.addGestureRecognizer(longPressGesture)
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        
        
    }
    
    
    
    private func fetchNotes(){
        let request : NSFetchRequest<Note> = Note.fetchRequest()
        
        do{
            notes = try DBContext.fetch(request)
        } catch {
            print(error)
        }
    }
    
    
    @objc
    private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        let location = gesture.location(in: collectionView)
        if let indexPath = collectionView.indexPathForItem(at: location){
            showDeleteConfirmation(at: indexPath)
        }
    }
    
    private func showDeleteConfirmation(at indexPath: IndexPath) {
        let alert = UIAlertController(
            title: "Delete Note?",
            message: "Note will be deleted permanently",
            preferredStyle: .actionSheet
        )
        addAction = UIAlertAction(
            title: "Delete",
            style: .destructive,
            handler: { [unowned self] _ in
                deleteNote(at: indexPath)
            }
        )
        alert.addAction(addAction!)
        alert.addAction(UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: nil
        ))
        present(alert, animated: true)
    }
    
    private func deleteNote(at indexPath: IndexPath) {
        let noteToDelete = notes[indexPath.item]
        DBContext.delete(noteToDelete)
        
        do {
            try DBContext.save()
        } catch {
            print("Failed to delete note:", error)
        }
        
        notes.remove(at: indexPath.item)
        collectionView.deleteItems(at: [indexPath])
    }
    
    @objc private func addNote() {
        let noteDetailVC = NoteDetailViewController()
            navigationController?.pushViewController(noteDetailVC, animated: true)
    }
    
    
}



extension NotesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return notes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let noteCell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoteCell", for: indexPath) as? NoteCell else {
            return UICollectionViewCell()
        }
        
        noteCell.configure(with: notes[indexPath.row])
        return noteCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let noteDetailVC = NoteDetailViewController(note: notes[indexPath.item])
        navigationController?.pushViewController(noteDetailVC, animated: true)
       }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchNotes()
        collectionView.reloadData()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, heightForItemAt indexPath: IndexPath, with width: CGFloat) -> CGFloat {
        let note = notes[indexPath.item]
        let titleHeight = heightForText(note.title ?? "", font: UIFont.boldSystemFont(ofSize: 20), width: width)
        let contentHeight = heightForText(note.text ?? "", font: UIFont.systemFont(ofSize: 16), width: width)
        return titleHeight + contentHeight + 60
    }

    private func heightForText(_ text: String, font: UIFont, width: CGFloat) -> CGFloat {
        let constraintSize = CGSize(width: width - 30, height: .greatestFiniteMagnitude)
        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        let boundingBox = text.boundingRect(with: constraintSize, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        return ceil(boundingBox.height)
    }
    
    
}


