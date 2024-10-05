//
//  BoardingScreensViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 04/09/2024.
//


import UIKit
import Foundation
import Combine

class OnBoardingScreensViewController: BaseViewController<OnBoardingScreensViewModel> {
    
    // MARK: - Outlets
    @IBOutlet weak var pageControlView: CustomPageControl!
    @IBOutlet weak var boardingImagesCollectionView: UICollectionView!
    @IBOutlet private weak var getStartedButton: CustomButton!
    @IBOutlet private weak var serviceLabel: UILabel!
    @IBOutlet private weak var serviceDescription: UILabel!
    
  
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
       
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupInitialState()
        bindingViewModel()
    }
    
    private func setupInitialState() {
        updateGetStartedButton()
        updateLabels(for: viewModel.currentImageIndex)
        pageControlView.numberOfPages = viewModel.images.count
        pageControlView.currentPage = viewModel.currentImageIndex
        boardingImagesCollectionView.reloadData()
        
        // Delay scrolling to ensure collection view is ready
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.scrollToIndex(self?.viewModel.currentImageIndex ?? 0)
        }
    }
    
    @IBAction func getStartedAction(_ sender: Any) {
        print("Get Started button tapped")
        if viewModel.isLastImage() {
            print("Last image reached, navigating to next screen")
            navigateToNextScreen()
        } else {
            print("Scrolling to next image")
            viewModel.scrollToNextImage()
            let nextIndex = viewModel.currentImageIndex
            print("New index: \(nextIndex)")
            
            // Manually update UI
            updateGetStartedButton()
            updateLabels(for: nextIndex)
            
            // Scroll to the next image
            scrollToIndex(nextIndex)
            
            // Update page control
            pageControlView.currentPage = nextIndex
        }
    }
    
    private func setupCollectionView() {
        boardingImagesCollectionView.register(SliderBoardingImageCollectionViewCell.self, forCellWithReuseIdentifier: "SliderBoardingImageCollectionViewCell")
        boardingImagesCollectionView.dataSource = self
        boardingImagesCollectionView.delegate = self
        boardingImagesCollectionView.isPagingEnabled = true
    }
    
    private func navigateToNextScreen() {
        // Add navigation logic here
        print("Navigating to the next screen...")
        // For example:
        // let nextVC = YourNextViewController()
        // navigationController?.pushViewController(nextVC, animated: true)
    }
    
    private func updateGetStartedButton() {
        let buttonTitle = viewModel.isLastImage() ? "Get Started" : "Next"
        getStartedButton.setupButton(color: .appColor, title: buttonTitle, borderColor: .appColor, textColor: .white)
    }
    
    private func updateLabels(for index: Int) {
        serviceLabel.text = viewModel.getServiceTitle(for: index)
        serviceDescription.text = viewModel.getServiceDescription(for: index)
    }
    
    private func scrollToIndex(_ index: Int) {
        guard index < viewModel.images.count, boardingImagesCollectionView.numberOfItems(inSection: 0) > index else {
            print("Cannot scroll: index out of bounds or collection view not ready")
            return
        }
        let indexPath = IndexPath(item: index, section: 0)
        boardingImagesCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}

extension OnBoardingScreensViewController {
    func bindingViewModel() {
        viewModel.$currentImageIndex
            .sink { [weak self] index in
                guard let self = self else { return }
                
                print("Current image index changed to: \(index)")
                
                self.updateGetStartedButton()
                self.updateLabels(for: index)
                self.pageControlView.currentPage = index
                
                // Delay scrolling to ensure collection view is ready
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.scrollToIndex(index)
                }
            }
            .store(in: &cancellables)

        viewModel.$images
            .sink { [weak self] images in
                guard let self = self else { return }
                
                print("Images updated, count: \(images.count)")
                
                self.boardingImagesCollectionView.reloadData()
                self.pageControlView.numberOfPages = images.count
                
                // Delay scrolling to ensure collection view is ready
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.scrollToIndex(self.viewModel.currentImageIndex)
                }
            }
            .store(in: &cancellables)
    }
}

extension OnBoardingScreensViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SliderBoardingImageCollectionViewCell", for: indexPath) as! SliderBoardingImageCollectionViewCell
        cell.configure(with: viewModel.images[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageIndex = Int(scrollView.contentOffset.x / scrollView.frame.width)
        viewModel.currentImageIndex = pageIndex
    }
}
