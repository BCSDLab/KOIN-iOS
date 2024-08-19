//
//  PageCollectionViewCell.swift
//  koin
//
//  Created by JOOMINKYUNG on 8/13/24.
//

import Combine
import SnapKit
import UIKit
import Then

final class PageCollectionViewCell: UICollectionViewCell {
    // MARK: - UI Components
    private let noticeTableView = NoticeListTableView(frame: .zero, style: .grouped).then {
        $0.backgroundColor = .white
        $0.separatorStyle = .singleLine
    }
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(noticeArticleList: [NoticeArticleDTO], noticeListPages: NoticeListPages) {
        noticeTableView.updateNoticeList(noticeArticleList: noticeArticleList, pageInfos: noticeListPages)
        noticeTableView.reloadData()
    }
    
    func getPageInfos(pageInfos: NoticeListPages) {
        
    }
}

extension PageCollectionViewCell {
    private func setUpLayouts() {
        contentView.addSubview(noticeTableView)
    }

    private func setUpConstraints() {
        noticeTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    private func configureView() {
        setUpLayouts()
        setUpConstraints()
    }
}
