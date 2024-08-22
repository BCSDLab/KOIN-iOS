//
//  NoticeKeyWordCollectionView.swift
//  koin
//
//  Created by JOOMINKYUNG on 8/13/24.
//

import Combine
import UIKit

final class NoticeKeyWordCollectionView: UICollectionView, UICollectionViewDataSource {
    //MARK: - Properties
    private var noticeKeyWordList: [NoticeKeyWordDTO] = []
    let keyWordTapPublisher = PassthroughSubject<String, Never>()
    
    //MARK: - Initialization
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        register(NoticeKeyWordCollectionViewCell.self, forCellWithReuseIdentifier: NoticeKeyWordCollectionViewCell.identifier)
        dataSource = self
        delegate = self
        contentInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
    }
    
    func updateUserKeyWordList(keyWordList: [NoticeKeyWordDTO]) {
        self.noticeKeyWordList = keyWordList
        reloadData()
    }
}

extension NoticeKeyWordCollectionView {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return noticeKeyWordList.count + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoticeKeyWordCollectionViewCell.identifier, for: indexPath) as? NoticeKeyWordCollectionViewCell else {
            return UICollectionViewCell()
        }
        if indexPath.item == 0 {
            cell.configureFilterImage()
        }
        else {
            cell.configure(keyWordModel: noticeKeyWordList[indexPath.item-1])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoticeKeyWordCollectionViewCell.identifier, for: indexPath) as? NoticeKeyWordCollectionViewCell {
            cell.selectKeyWord(isSelected: true)
        }
    }
}

extension NoticeKeyWordCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0 {
            return CGSize(width: 32, height: 32)
        } else {
            let label = UILabel()
            label.text = noticeKeyWordList[indexPath.item - 1].keyWord
            label.font = .appFont(.pretendardBold, size: 14)
            let size = label.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: 34))
            return CGSize(width: size.width + 32, height: 34)
        }
    }
}

