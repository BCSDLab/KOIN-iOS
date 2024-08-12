//
//  ReviewImageUploadCollectionView.swift
//  koin
//
//  Created by 김나훈 on 8/13/24.
//

import UIKit

final class ReviewImageUploadCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var imageUrls: [String] = []
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        isScrollEnabled = true
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        contentInset = .zero
        register(ReviewImageUploadCollectionViewCell.self, forCellWithReuseIdentifier: ReviewImageUploadCollectionViewCell.identifier)
        dataSource = self
        delegate = self
    }
    
    func addImageUrl(_ imageUrl: String) {
        self.imageUrls.append(imageUrl)
        self.reloadData()
    }
    
    func updateImageUrls(_ imageUrls: [String]) {
        self.imageUrls = imageUrls
        self.reloadData()
    }
}

extension ReviewImageUploadCollectionView {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewImageUploadCollectionViewCell.identifier, for: indexPath) as? ReviewImageUploadCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(imageUrl: imageUrls[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageUrls.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = Int((collectionView.bounds.width - 38) / 3)
        return CGSize(width: width, height: Int(collectionView.bounds.height) - 16)
    }
}




