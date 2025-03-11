//
//  NoteCell.swift
//  hw5
//
//  Created by Ani Lakirbaia on 05.02.25.
//

import Foundation
import UIKit
class NoteCell: UICollectionViewCell {
    static let identifier = "NoteCell"

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        label.textColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
        return label
    }()

    private let contentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
        return label
    }()

    private var note: Note?
    
    let colors: [UIColor] = [
         UIColor(red: 1.0, green: 0.8, blue: 0.8, alpha: 1.0), // Light Red
         UIColor(red: 0.8, green: 1.0, blue: 0.8, alpha: 1.0), // Light Green
         UIColor(red: 1.0, green: 1.0, blue: 0.7, alpha: 1.0), // Light Yellow
         UIColor(red: 0.7, green: 0.85, blue: 1.0, alpha: 1.0)  // Light Blue
     ]
    
    private var colorIndex : Int?

    func configure(with note: Note) {
        self.note = note
        titleLabel.text = note.title
        contentLabel.text = note.text
        colorIndex = Int(note.color ?? "0")
        contentView.backgroundColor = colors[colorIndex ?? 0]
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
       

        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true

        contentView.addSubview(titleLabel)
        contentView.addSubview(contentLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15), 
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),

            contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10), // Added space between title and content
            contentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            contentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            contentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  
}
