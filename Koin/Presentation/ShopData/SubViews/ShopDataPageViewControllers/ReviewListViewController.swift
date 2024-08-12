//
//  ReviewListViewController.swift
//  koin
//
//  Created by 김나훈 on 7/8/24.
//

import Combine
import Then
import UIKit

final class ReviewListViewController: UIViewController {
    
    // MARK: - Properties
    let viewControllerHeightPublisher = PassthroughSubject<CGFloat, Never>()
    let fetchStandardPublisher = PassthroughSubject<(ReviewSortType?, Bool?), Never>()
    let deleteReviewPublisher = PassthroughSubject<(Int, Int), Never>()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Components
    
    private let writeReviewButton = UIButton().then {
        $0.setTitleColor(UIColor.appColor(.primary600), for: .normal)
        $0.layer.borderColor = UIColor.appColor(.primary600).cgColor
        $0.layer.cornerRadius = 4
        $0.layer.borderWidth = 1.0
        $0.setTitle("리뷰 작성하기", for: .normal)
        $0.titleLabel?.font = UIFont.appFont(.pretendardMedium, size: 14)
    }
    
    private let totalScoreLabel = UILabel().then {
        $0.font = UIFont.appFont(.pretendardMedium, size: 32)
        $0.textColor = UIColor.appColor(.neutral800)
    }
    
    private let totalScoreView = ScoreView().then {
        $0.settings.starSize = 16
        $0.settings.starMargin = 2
        $0.settings.fillMode = .precise
        $0.settings.updateOnTouch = false
    }
    
    private let scoreChartCollectionView: ScoreChartCollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        let collectionView = ScoreChartCollectionView(frame: .zero, collectionViewLayout: flowLayout)
        return collectionView
    }()
    
    private let reviewListCollectionView: ReviewListCollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 10
        let collectionView = ReviewListCollectionView(frame: .zero, collectionViewLayout: flowLayout)
        return collectionView
    }()
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        bind()
        writeReviewButton.addTarget(self, action: #selector(writeReviewButtonTapped), for: .touchUpInside)
        // FIXME: 테스트코드
        print(KeyChainWorker.shared.read(key: .access))
    }
    
    func setReviewList(_ review: [Review]) {
        reviewListCollectionView.setReviewList(review)
       
        
        reviewListCollectionView.snp.updateConstraints { make in
            make.height.equalTo(3000)
        }
        viewControllerHeightPublisher.send(4000)
    }
    
    func setReviewStatistics(statistics: StatisticsDTO) {
        totalScoreLabel.text = "\(statistics.averageRating)"
        totalScoreView.rating = statistics.averageRating
        scoreChartCollectionView.setStatistics(statistics)
    }
    
    private func bind() {
        reviewListCollectionView.myReviewButtonPublisher.sink { [weak self] isMine in
            self?.fetchStandardPublisher.send((nil, isMine))
        }.store(in: &cancellables)
        
        reviewListCollectionView.sortTypeButtonPublisher.sink { [weak self] type in
            self?.fetchStandardPublisher.send((type, nil))
        }.store(in: &cancellables)
        
        reviewListCollectionView.deleteButtonPublisher.sink { [weak self] parameter in
            self?.deleteReviewPublisher.send(parameter)
        }.store(in: &cancellables)
        
        reviewListCollectionView.modifyButtonPublisher.sink { [weak self] parameter in
            let shopRepository = DefaultShopRepository(service: DefaultShopService())
            let postReviewUseCase = DefaultPostReviewUseCase(shopRepository: shopRepository)
            let modifyReviewUseCase = DefaultModifyReviewUseCase(shopRepository: shopRepository)
            let fetchShopReviewUseCase = DefaultFetchShopReviewUseCase(shopRepository: shopRepository)
            let uploadFileUseCase = DefaultUploadFileUseCase(shopRepository: shopRepository)
            
            let shopReviewViewController = ShopReviewViewController(viewModel: ShopReviewViewModel(postReviewUseCase: postReviewUseCase, modifyReviewUseCase: modifyReviewUseCase, fetchShopReviewUseCase: fetchShopReviewUseCase, uploadFileUseCase: uploadFileUseCase, reviewId: parameter.0, shopId: parameter.1))
            shopReviewViewController.navigationController?.title = "리뷰 수정하기"
            self?.navigationController?.pushViewController(shopReviewViewController, animated: true)
        }.store(in: &cancellables)
        
        reviewListCollectionView.reportButtonPublisher.sink { [weak self] parameter in
            let viewController = ShopReviewReportViewController(viewModel: ShopReviewReportViewModel(reportReviewReviewUseCase: DefaultReportReviewUseCase(shopRepository: DefaultShopRepository(service: DefaultShopService())), reviewId: parameter.0, shopId: parameter.1))
            self?.navigationController?.pushViewController(viewController, animated: true)
        }.store(in: &cancellables)
    }
    
}

extension ReviewListViewController {
    
    @objc private func writeReviewButtonTapped() {
        
        // TODO: 이거 임시 값 준거임. 수정 필요
        let shopRepository = DefaultShopRepository(service: DefaultShopService())
        let postReviewUseCase = DefaultPostReviewUseCase(shopRepository: shopRepository)
        let modifyReviewUseCase = DefaultModifyReviewUseCase(shopRepository: shopRepository)
        let fetchShopReviewUseCase = DefaultFetchShopReviewUseCase(shopRepository: shopRepository)
        let uploadFileUseCase = DefaultUploadFileUseCase(shopRepository: shopRepository)
        
        
        // FIXME: shopid는 임시값임
        let shopReviewViewController = ShopReviewViewController(viewModel: ShopReviewViewModel(postReviewUseCase: postReviewUseCase, modifyReviewUseCase: modifyReviewUseCase, fetchShopReviewUseCase: fetchShopReviewUseCase, uploadFileUseCase: uploadFileUseCase, shopId: 0))
        shopReviewViewController.navigationController?.title = "리뷰 작성하기"
        navigationController?.pushViewController(shopReviewViewController, animated: true)
    }
}

extension ReviewListViewController {
    private func setUpLayOuts() {
        [writeReviewButton, totalScoreLabel, totalScoreView, scoreChartCollectionView, reviewListCollectionView].forEach {
            view.addSubview($0)
        }
    }
    
    private func setUpConstraints() {
        writeReviewButton.snp.makeConstraints {
            $0.top.equalTo(view.snp.top).offset(12)
            $0.leading.equalTo(view.snp.leading).offset(16)
            $0.trailing.equalTo(view.snp.trailing).offset(-16)
            $0.height.equalTo(40)
        }
        
        totalScoreLabel.snp.makeConstraints {
            $0.top.equalTo(writeReviewButton.snp.bottom).offset(26)
            $0.leading.equalTo(view.snp.leading).offset(45)
        }
        
        totalScoreView.snp.makeConstraints {
            $0.top.equalTo(totalScoreLabel.snp.bottom).offset(4)
            $0.leading.equalTo(view.snp.leading).offset(24)
            $0.width.equalTo(88)
            $0.height.equalTo(16)
        }
        
        scoreChartCollectionView.snp.makeConstraints {
            $0.top.equalTo(writeReviewButton.snp.bottom).offset(14)
            $0.leading.equalTo(totalScoreView.snp.trailing).offset(14)
            $0.trailing.equalTo(view.snp.trailing)
            $0.height.equalTo(95)
        }
        
        reviewListCollectionView.snp.makeConstraints {
            $0.top.equalTo(scoreChartCollectionView.snp.bottom).offset(14)
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(view.snp.trailing)
            $0.height.equalTo(1)
        }
        
    }
    
    private func configureView() {
        setUpLayOuts()
        setUpConstraints()
        self.view.backgroundColor = .systemBackground
    }
    
}
