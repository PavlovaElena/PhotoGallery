//
//  PhotoCollectionViewCell.swift
//  PhotoGallery
//
//  Created by Elena Pavlova on 06.11.2022.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    static let reuseId = "PhotoCell"
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .systemGray
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let checkmark: UIImageView = {
        let image = UIImage(systemName: "checkmark.circle")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.alpha = 0
        return imageView
    }()
    
    var photo: Photo! {
        didSet {
            let photoURL = photo.urls["regular"]
            NetworkService.shared.fetchImage(from: photoURL) { result in
                switch result {
                case .success(let imageData):
                    self.photoImageView.image = UIImage(data: imageData)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    override var isSelected: Bool {
        didSet {
            updateSelectedState()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupPhotoImageView()
        setupCheckmark()
        updateSelectedState()
    }
    
    private func setupPhotoImageView() {
        addSubview(photoImageView)
        photoImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        photoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        photoImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        photoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
    
    private func setupCheckmark() {
        addSubview(checkmark)
        checkmark.trailingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: -8).isActive = true
        checkmark.bottomAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: -8).isActive = true
    }
    
    private func updateSelectedState() {
        photoImageView.alpha = isSelected ? 0.7 : 1
        checkmark.alpha = isSelected ? 1 : 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
