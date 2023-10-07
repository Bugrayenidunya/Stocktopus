//
//  HomeController.swift
//  Stocktopus
//
//  Created by Enes Buğra Yenidünya on 6.10.2023.
//

import UIKit
import Combine

final class HomeController: UIViewController {
    
    // MARK: Typealias
    typealias DataSource = UICollectionViewDiffableDataSource<HomeSection, HomeCollectionViewCellDTO>
    typealias Snapshot = NSDiffableDataSourceSnapshot<HomeSection, HomeCollectionViewCellDTO>
    
    // MARK: Properties
    private var viewModel: HomeViewModelInput
    private var snapshot = NSDiffableDataSourceSnapshot<HomeSection, HomeCollectionViewCellDTO>()
    private var cancallables = Set<AnyCancellable>()
    private lazy var dataSource = generateDatasource()
    
    private enum Constant {
        static let headerKind = "header"
        static let sectionInset = 2.0
        static let half = 0.5
        static let full = 1.0
        static let headerHeight = 44.0
        static let cellHeight = 56.0
    }
    
    // MARK: Views
    private lazy var collectionView: UICollectionView = {
        let compositionalLayout = generateCompositionalLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: compositionalLayout)
        collectionView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: HomeCollectionViewCell.identifier)
        collectionView.register(
            SectionHeaderReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionHeaderReusableView.identifier
        )
        collectionView.delegate = self
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        commonInit()
        viewModel.viewDidLoad()
    }
    
    // MARK: Init
    init(viewModel: HomeViewModelInput) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        isReachedEnd(scrollView) ? viewModel.loadMoreStocks() : nil
    }
}

// MARK: - HomeViewModelOutput
extension HomeController: HomeViewModelOutput {
    
}

// MARK: - UICollectionViewDelegate
extension HomeController: UICollectionViewDelegate {
    
}

// MARK: - Helpers
private extension HomeController {
    func isReachedEnd(_ scrollView: UIScrollView) -> Bool {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let screenHeight = scrollView.frame.size.height
        let threshold: CGFloat = 100
        
        return offsetY + screenHeight > contentHeight - threshold
    }
    
    func commonInit() {
        setupView()
        setupSubscriptions()
        setupSupplementryView()
    }
    
    func setupView() {
        view.addSubview(collectionView)
        
        collectionView.setConstraint(
            top: view.safeAreaLayoutGuide.topAnchor,
            leading: view.leadingAnchor,
            bottom: view.bottomAnchor,
            trailing: view.trailingAnchor,
            topConstraint: 16,
            leadingConstraint: .zero,
            bottomConstraint: .zero,
            trailingConstraint: .zero
        )
    }
    
    func setupSubscriptions() {
        viewModel.sectionsSubject
            .sink(receiveValue: { section in
                self.applySnapshot()
            })
            .store(in: &cancallables)
    }
    
    /// Applies new data to dataSource
    func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections(viewModel.sectionsSubject.value)
        viewModel.sectionsSubject.value.forEach { section in
            snapshot.appendItems(section.items, toSection: section)
        }
        
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    /// Generates `UICollectionViewDiffableDataSource`
    func generateDatasource() -> DataSource {
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, cellViewModel) -> UICollectionViewCell? in
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier, for: indexPath) as? HomeCollectionViewCell else {
                    return .init(frame: .zero)
                }
                
                cell.configure(with: cellViewModel)
                
                return cell
            })
        
        return dataSource
    }
    /// Setups `Section`
    func setupSupplementryView() {
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else { return .init(frame: .zero) }

            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderReusableView.identifier, for: indexPath) as? SectionHeaderReusableView
            view?.titleLabel.text = "Stocs"
            
            return view
        }
    }
    /// Generates `UICollectionViewCompositionalLayout` with given items, group, header and section
    func generateCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let item = generateLayoutItems()
        
        // Group
        let groupDimension = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(Constant.full),
            heightDimension: .estimated(Constant.cellHeight)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupDimension, subitems: [item])
        
        return .init(section: generateSection(for: group))
    }
    /// Generates `NSCollectionLayoutItem` with given dimensions
    func generateLayoutItems() -> NSCollectionLayoutItem {
        // Item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(Constant.full),
            heightDimension: .estimated(Constant.cellHeight)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: Constant.sectionInset, leading: Constant.sectionInset, bottom: Constant.sectionInset, trailing: Constant.sectionInset)
        
        return item
    }
    /// Generates `NSCollectionLayoutBoundarySupplementaryItem` with given dimensions
    func generateHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerItemDimension = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(Constant.full),
            heightDimension: .estimated(Constant.headerHeight)
        )
        return .init(layoutSize: headerItemDimension, elementKind: UICollectionView.elementKindSectionHeader,  alignment: .top)
    }
    /// Generates `NSCollectionLayoutSection` with given group
    func generateSection(for group: NSCollectionLayoutGroup) -> NSCollectionLayoutSection {
        let section = NSCollectionLayoutSection(group: group)
        
        section.contentInsets = NSDirectionalEdgeInsets(
            top: Constant.sectionInset,
            leading: Constant.sectionInset,
            bottom: Constant.sectionInset,
            trailing: Constant.sectionInset
        )
        
        section.boundarySupplementaryItems = [generateHeader()]
        
        return section
    }
}
