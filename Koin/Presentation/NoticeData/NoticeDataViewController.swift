//
//  NoticeDataViewController.swift
//  koin
//
//  Created by JOOMINKYUNG on 8/19/24.
//

import Combine
import Then
import UIKit

final class NoticeDataViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: NoticeDataViewModel
    private let inputSubject: PassthroughSubject<NoticeDataViewModel.Input, Never> = .init()
    private var subscriptions: Set<AnyCancellable> = []
    
    // MARK: - UI Components
    private let titleWrappedView = UIView().then {
        $0.backgroundColor = .white
    }
    
    private let titleGuideLabel = UILabel().then {
        $0.font = .appFont(.pretendardBold, size: 14)
        $0.textColor = .appColor(.primary400)
    }
    
    private let titleLabel = UILabel().then {
        $0.font = .appFont(.pretendardMedium, size: 14)
        $0.textColor = .appColor(.neutral800)
    }
    
    private let nickName = UILabel().then {
        $0.font = .appFont(.pretendardRegular, size: 12)
        $0.textAlignment = .left
        $0.textColor = .appColor(.neutral500)
    }
    
    private let createdDate = UILabel().then {
        $0.font = .appFont(.pretendardRegular, size: 12)
        $0.textAlignment = .left
        $0.textColor = .appColor(.neutral500)
    }
    
    private let separatorDot = UILabel().then {
        $0.text = "·"
        $0.font = .appFont(.pretendardRegular, size: 12)
        $0.textAlignment = .left
        $0.textColor = .appColor(.neutral500)
    }
    
    private let contentWrappedView = UIView().then {
        $0.backgroundColor = .white
    }
    
    private let inventoryButton = UIButton().then {
        $0.setTitle("목록", for: .normal)
    }
    
    private let previousButton = UIButton().then {
        $0.setTitle("이전 글", for: .normal)
    }
    
    private let nextButton = UIButton().then {
        $0.setTitle("다음 글", for: .normal)
    }
    
    private let popularNoticeWrappedView = UIView().then {
        $0.backgroundColor = .white
    }
    
    private let popularNoticeGuideLabel = UILabel().then {
        $0.font = UIFont.appFont(.pretendardBold, size: 14)
        $0.textColor = .appColor(.neutral800)
        $0.text = "인기있는 공지"
    }
    
    private let popularNoticeTableView = UITableView(frame: .zero, style: .plain)
    
    private let scrollView = UIScrollView()
    
    private let contentView = UIView().then {
        $0.backgroundColor = .appColor(.neutral300)
    }
    
    private let contentLabel = UILabel()
    
    private let contentImage = UIImageView()
    
    // MARK: - Initialization
    
    init(shopId: Int, viewModel: NoticeDataViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    // MARK: - Bind
    
    private func bind() {
        let outputSubject = viewModel.transform(with: inputSubject.eraseToAnyPublisher())
        outputSubject.receive(on: DispatchQueue.main).sink { [weak self] output in
           
        }.store(in: &subscriptions)
    }
}

extension NoticeDataViewController {
    
  
}

extension NoticeDataViewController {
    
    private func setUpLayOuts() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [titleWrappedView, contentWrappedView,popularNoticeWrappedView].forEach {
            contentView.addSubview($0)
        }
        [titleGuideLabel, titleLabel, createdDate, nickName].forEach {
            titleWrappedView.addSubview($0)
        }
        [contentLabel, contentImage, inventoryButton, previousButton, nextButton].forEach {
            contentWrappedView.addSubview($0)
        }
        [popularNoticeGuideLabel, popularNoticeTableView].forEach {
            popularNoticeWrappedView.addSubview($0)
        }
    }
    
    private func setUpConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        titleWrappedView.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview()
        }
        
        titleGuideLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(24)
            $0.top.equalToSuperview().offset(12)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(titleGuideLabel)
            $0.trailing.equalTo(24)
        }
        
        createdDate.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.equalTo(titleLabel)
        }
        
        separatorDot.snp.makeConstraints {
            $0.leading.equalTo(createdDate.snp.trailing).offset(2)
            $0.top.equalTo(createdDate)
        }
        
        nickName.snp.makeConstraints {
            $0.leading.equalTo(separatorDot.snp.trailing).offset(2)
            $0.top.equalTo(createdDate)
            $0.bottom.equalToSuperview().inset(12)
        }
        
        contentWrappedView.snp.makeConstraints {
            $0.top.equalTo(titleWrappedView).offset(6)
            $0.leading.trailing.equalToSuperview()
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.trailing.equalTo(24)
        }
        
        contentImage.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(3)
            $0.width.equalTo(500)
        }
        
        inventoryButton.snp.makeConstraints {
            $0.top.equalTo(contentImage).offset(20)
            $0.leading.equalTo(contentImage)
        }
        
        nextButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(24)
            $0.top.equalTo(inventoryButton)
        }
        
        previousButton.snp.makeConstraints {
            $0.trailing.equalTo(nextButton).inset(3)
            $0.top.equalTo(inventoryButton)
            $0.bottom.equalToSuperview().inset(20)
        }
        
        popularNoticeWrappedView.snp.makeConstraints {
            $0.top.equalTo(contentWrappedView.snp.bottom).offset(6)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        popularNoticeGuideLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalTo(previousButton)
        }
        
        popularNoticeTableView.snp.makeConstraints {
            $0.top.equalTo(popularNoticeGuideLabel).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(300)
        }
    }
    
    private func configureView() {
        setUpLayOuts()
        setUpConstraints()
        self.view.backgroundColor = .systemBackground
    }
}


