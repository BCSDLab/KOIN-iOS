//
//  DefaultShopRepository.swift
//  koin
//
//  Created by 김나훈 on 5/22/24.
//

import Combine

final class DefaultShopRepository: ShopRepository {

    private let service: ShopService
    
    init(service: ShopService) {
        self.service = service
    }
    
    func fetchShopList() -> AnyPublisher<ShopsDTO, Error> {
        return service.fetchShopList()
    }
    
    func fetchEventList() -> AnyPublisher<EventsDTO, Error> {
        return service.fetchEventList()
    }
    
    func fetchShopCategoryList() -> AnyPublisher<ShopCategoryDTO, Error> {
        return service.fetchShopCategoryList()
    }
    
    func fetchShopData(requestModel: FetchShopInfoRequest) -> AnyPublisher<ShopDataDTO, Error> {
        return service.fetchShopData(requestModel: requestModel)
    }
    
    func fetchShopMenuList(requestModel: FetchShopInfoRequest) -> AnyPublisher<MenuDTO, Error> {
        return service.fetchShopMenuList(requestModel: requestModel)
    }
    
    func fetchShopEventList(requestModel: FetchShopInfoRequest) -> AnyPublisher<EventsDTO, Error> {
        return service.fetchShopEventList(requestModel: requestModel)
    }
    
    func fetchReviewList(requestModel: FetchShopReviewRequest) -> AnyPublisher<ReviewsDTO, ErrorResponse> {
        return service.fetchReviewList(requestModel: requestModel, retry: false)
    }
    
    func fetchReview(reviewId: Int, shopId: Int) -> AnyPublisher<OneReviewDTO, ErrorResponse> {
        return service.fetchReview(reviewId: reviewId, shopId: shopId)
    }
    
    func fetchMyReviewList(requestModel: FetchMyReviewRequest, shopId: Int) -> AnyPublisher<MyReviewDTO, ErrorResponse> {
        return service.fetchMyReviewList(requestModel: requestModel, shopId: shopId)
    }
    
    func postReview(requestModel: WriteReviewRequest, shopId: Int) -> AnyPublisher<Void, ErrorResponse> {
        return service.postReview(requestModel: requestModel, shopId: shopId)
    }
    
    func modifyReview(requestModel: WriteReviewRequest, reviewId: Int, shopId: Int) -> AnyPublisher<Void, ErrorResponse> {
        return service.modifyReview(requestModel: requestModel, reviewId: reviewId, shopId: shopId)
    }
    
    func deleteReview(reviewId: Int, shopId: Int) -> AnyPublisher<Void, ErrorResponse> {
        return service.deleteReview(reviewId: reviewId, shopId: shopId)
    }
    
    func reportReview(requestModel: ReportReviewRequest, reviewId: Int, shopId: Int) -> AnyPublisher<Void, ErrorResponse> {
        return service.reportReview(requestModel: requestModel, reviewId: reviewId, shopId: shopId)
    }
    
}
