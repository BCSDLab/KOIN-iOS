//
//  NoticeListTableView.swift
//  koin
//
//  Created by JOOMINKYUNG on 8/13/24.
//

import Combine
import UIKit

final class NoticeListTableView: UITableView {
    // MARK: - Properties
    private var noticeArticleList: [NoticeArticleDTO] = []
    private var pageInfos: NoticeListPages = .init(isPreviousPage: nil, pages: [], selectedIndex: 0, isNextPage: nil)
    let pageBtnPublisher = PassthroughSubject<Int, Never>()
    let tapNoticePublisher = PassthroughSubject<Int, Never>()
    private var subscribtions = Set<AnyCancellable>()
    
    // MARK: - Initialization
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    private func commonInit() {
        register(NoticeListTableViewKeyWordCell.self, forCellReuseIdentifier: NoticeListTableViewKeyWordCell.id)
        register(NoticeListTableViewCell.self, forCellReuseIdentifier: NoticeListTableViewCell.identifier)
        register(NoticeListTableViewFooter.self, forHeaderFooterViewReuseIdentifier: NoticeListTableViewFooter.identifier)
        dataSource = self
        delegate = self
        estimatedRowHeight = 110
        sectionHeaderHeight = 0
        sectionHeaderTopPadding = 0
        separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func updateNoticeList(noticeArticleList: [NoticeArticleDTO], pageInfos: NoticeListPages) {
        self.noticeArticleList = noticeArticleList
        self.pageInfos = pageInfos
        let indexSet = IndexSet(integer: 1)
        reloadSections(indexSet, with: .automatic)
    }
    
    func updateKeyWordList(keyWordList: [NoticeKeyWordDTO]) {
        let index = IndexPath(row: 0, section: 0)
        if let cell = cellForRow(at: index) as? NoticeListTableViewKeyWordCell {
            cell.updateKeyWordsList(keyWordList: keyWordList)
            reloadData()
        }
    }
}

extension NoticeListTableView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else {
            return noticeArticleList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NoticeListTableViewKeyWordCell.id, for: indexPath) as? NoticeListTableViewKeyWordCell
            else {
                return UITableViewCell()
            }
            return cell
        }
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NoticeListTableViewCell.identifier, for: indexPath) as? NoticeListTableViewCell
            else {
                return UITableViewCell()
            }
            cell.configure(articleModel: noticeArticleList[indexPath.row])
            return cell
        }
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tapNoticePublisher.send(noticeArticleList[indexPath.row].id)
    }
}

extension NoticeListTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 1 {
            guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: NoticeListTableViewFooter.identifier) as? NoticeListTableViewFooter
            else {
                return UITableViewHeaderFooterView()
            }
            view.configure(pageInfo: pageInfos)
            view.tapBtnPublisher.sink { [weak self] page in
                self?.pageBtnPublisher.send(page)
            }.store(in: &subscribtions)
            return view
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 66
        }
        else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        else {
            return 95
        }
    }
}
