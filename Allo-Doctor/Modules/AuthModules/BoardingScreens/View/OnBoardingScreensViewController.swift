//
//  BoardingScreensViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 04/09/2024.
//

import UIKit


// MARK: - OnBoardingScreensViewController
class OnBoardingScreensViewController: BaseViewController<OnBoardingScreensViewModel> {
    // MARK: - Outlets
    @IBOutlet weak var pageControlView: UIView!
    @IBOutlet private weak var boardingImagesCollectionView: UICollectionView!
    @IBOutlet private weak var getStartedButton: CustomButton!
    @IBOutlet private weak var serviceLabel: UILabel!
    @IBOutlet private weak var serviceDescription: UILabel!
    
    // MARK: - Properties
    private var isScrollingProgrammatically = false
   
    
    let pageControl = CustomPageControl.init(frame: .zero)
    
    private var currentCellIndex: Int = 1 {
        didSet {
            pageControl.currentPage = currentCellIndex
        }
    }
    
    
    
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
       
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Update collection view layout
        if let layout = boardingImagesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = boardingImagesCollectionView.bounds.size
            layout.invalidateLayout()
        }
    }
    private func setupPageControl() {
        pageControl.currentPageIndicatorTintColor = .appColor
        pageControl.pageIndicatorTintColor = .greyA8A8A8
        pageControl.numberOfPages = viewModel.images.count
        
        // Configure page control
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControlView.addSubview(pageControl)
        
        // Add constraints
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: pageControlView.centerXAnchor),
            pageControl.centerYAnchor.constraint(equalTo: pageControlView.centerYAnchor),
            pageControl.widthAnchor.constraint(equalTo: pageControlView.widthAnchor),
            pageControl.heightAnchor.constraint(equalTo: pageControlView.heightAnchor)
        ])
    }
    
    @IBAction func continueAsGuest(_ sender: Any) {
        UserDefaultsManager.sharedInstance.sawOnboarding()
        viewModel.navToTabBarAsGuest()
    }
    // MARK: - Private Methods
    internal override func setupUI() {
        setupCollectionView()
        setupInitialState()
        bindViewModel()
        setupPageControl()
    }
    
    private func setupCollectionView() {
        // Configure collection view
        boardingImagesCollectionView.registerCell(cellClass: SliderBoardingImageCollectionViewCell.self)
        boardingImagesCollectionView.dataSource = self
        boardingImagesCollectionView.delegate = self
        boardingImagesCollectionView.isPagingEnabled = true
        boardingImagesCollectionView.showsHorizontalScrollIndicator = false
        boardingImagesCollectionView.bounces = false
        boardingImagesCollectionView.backgroundColor = .clear
        
        // Configure layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = .zero
        boardingImagesCollectionView.collectionViewLayout = layout
        
        // Prevent scrolling both directions
        boardingImagesCollectionView.alwaysBounceVertical = false
        boardingImagesCollectionView.alwaysBounceHorizontal = false
    }
    
    private func setupInitialState() {
        updateUI(for: viewModel.currentImageIndex)
        pageControl.numberOfPages = viewModel.images.count
        boardingImagesCollectionView.reloadData()
        
        // Initial scroll without animation
        DispatchQueue.main.async { [weak self] in
            self?.scrollToIndex(self?.viewModel.currentImageIndex ?? 0, animated: false)
            self?.pageControl.currentPage = self?.viewModel.currentImageIndex ?? 0
        }
    }
    
    internal override func bindViewModel() {
        viewModel.$currentImageIndex
            .receive(on: DispatchQueue.main)
            .sink { [weak self] index in
                self?.updateUI(for: index)
            }
            .store(in: &cancellables)
        
        viewModel.$images
            .receive(on: DispatchQueue.main)
            .sink { [weak self] images in
                self?.pageControl.numberOfPages = images.count
                self?.boardingImagesCollectionView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    private func updateUI(for index: Int) {
        updateLabels(for: index)
        updateGetStartedButton()
        updatePageControl(for: index)
    }
    
    private func updateLabels(for index: Int) {
        if let content = viewModel.getContent(for: index) {
            UIView.transition(with: serviceLabel, duration: 0.3, options: .transitionCrossDissolve) {
                self.serviceLabel.text = content.title
            }
            
            UIView.transition(with: serviceDescription, duration: 0.3, options: .transitionCrossDissolve) {
                self.serviceDescription.text = content.description
            }
        }
    }
    
    private func updateGetStartedButton() {
        let buttonTitle = viewModel.isLastScreen ? "Get Started" : "Next"
        UIView.transition(with: getStartedButton, duration: 0.3, options: .transitionCrossDissolve) {
            self.getStartedButton.setupButton(
                color: .appColor,
                title: buttonTitle,
                borderColor: .appColor,
                textColor: .white
            )
        }
    }
    
    private func updatePageControl(for index: Int) {
        pageControl.currentPage = index
    }
    
    private func scrollToIndex(_ index: Int, animated: Bool) {
        guard index >= 0, index < viewModel.images.count else { return }
        
        isScrollingProgrammatically = true
        let indexPath = IndexPath(item: index, section: 0)
        
        boardingImagesCollectionView.scrollToItem(
            at: indexPath,
            at: .centeredHorizontally,
            animated: animated
        )
        
        // Reset the flag after animation completes
        if animated {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.isScrollingProgrammatically = false
            }
        } else {
            isScrollingProgrammatically = false
        }
    }
    
    // MARK: - Actions
    @IBAction private func getStartedAction(_ sender: Any) {
        if viewModel.isLastScreen {
            navigateToNextScreen()
        } else {
            viewModel.scrollToNextImage()
            scrollToIndex(viewModel.currentImageIndex, animated: true)
            boardingImagesCollectionView.reloadData()
        
        }
    }

    private func navigateToNextScreen() {
        UserDefaultsManager.sharedInstance.sawOnboarding()
        viewModel.navToNumberScreen()
    }
}

// MARK: - UICollectionView Extensions
extension OnBoardingScreensViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(indexpath: indexPath) as SliderBoardingImageCollectionViewCell
        cell.configure(with: viewModel.images[viewModel.currentImageIndex])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
    // MARK: - Scroll View Delegate Methods
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !isScrollingProgrammatically else { return }
        
        let pageWidth = scrollView.bounds.width
        let currentPage = round(scrollView.contentOffset.x / pageWidth)
        let index = Int(currentPage)
        
        if index != viewModel.currentImageIndex {
            viewModel.updateCurrentIndex(index)
        }
    }
}
