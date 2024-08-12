//
//  ShopDataPageViewController.swift
//  koin
//
//  Created by 김나훈 on 7/6/24.
//

import Combine
import UIKit

final class ShopDataPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    // MARK: - Properties
    
    let viewControllerHeightPublisher = PassthroughSubject<CGFloat, Never>()
    private var subscriptions: Set<AnyCancellable> = []
    
    // MARK: - UI Components
    
    let menuListViewController = MenuListViewController()
    private let eventListViewController = EventListViewController()
    private let reviewListViewController = ReviewListViewController()
    private lazy var pages: [UIViewController] = {
        return [menuListViewController, eventListViewController, reviewListViewController]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        for gesture in self.gestureRecognizers {
            gesture.isEnabled = false
        }
        bind()
        if let firstViewController = pages.first {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    private func bind() {
        menuListViewController.viewControllerHeightPublisher.sink { [weak self] height in
            self?.viewControllerHeightPublisher.send(height)
        }.store(in: &subscriptions)
        
        eventListViewController.viewControllerHeightPublisher.sink { [weak self] height in
            self?.viewControllerHeightPublisher.send(height)
        }.store(in: &subscriptions)
        
        reviewListViewController.viewControllerHeightPublisher.sink { [weak self] height in
            self?.viewControllerHeightPublisher.send(height)
        }.store(in: &subscriptions)
        
    }
    
    func switchToPage(index: Int) {
        if index < 0 || index >= pages.count {
            return
        }
        
        let direction: UIPageViewController.NavigationDirection = index == 0 ? .reverse : .forward
        
        setViewControllers([pages[index]], direction: direction, animated: false, completion: nil)
    }
    
    func setMenuCategories(_ categories: [MenuCategory]) {
        menuListViewController.setMenuCategories(shopMenuList: categories)
    }
    
    func setEventList(_ events: [ShopEvent]) {
        eventListViewController.setEventList(events)
    }
    
    func setReviewList(_ review: [Review]) {
        reviewListViewController.setReviewList(review)
    }
    
    func setReviewStatistic(_ statistic: StatisticsDTO) {
        reviewListViewController.setReviewStatistics(statistics: statistic)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else { return nil }
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
        let nextIndex = viewControllerIndex + 1
        guard nextIndex < pages.count else { return nil }
        return pages[nextIndex]
    }
}
