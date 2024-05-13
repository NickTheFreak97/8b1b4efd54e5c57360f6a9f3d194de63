import UIKit

class ViewController: UICollectionViewController {
    private var currentPage: IndexPath? = nil
    
    private let images = ["police", "shutters", "depot", "cakes", "sign"]
    
    init() {
        let compositionalLayout = UICollectionViewCompositionalLayout { sectionIndex, environment in
            
            let absoluteW = environment.container.effectiveContentSize.width
            let absoluteH = environment.container.effectiveContentSize.height
            
            // Handle landscape
            if absoluteW > absoluteH {
                print("landscape")
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
                
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                return section
            } else {
                // Handle portrait
                
                print("portrait")
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(absoluteW * 9.0/16.0)
                )
                
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(absoluteW * 9.0/16.0)
                )
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                return section
            }
        }

        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 0
        config.scrollDirection = .horizontal
        
        compositionalLayout.configuration = config
        
        super.init(collectionViewLayout: compositionalLayout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        
        // Register cell for reuse
        collectionView.register(CarouselCell.self, forCellWithReuseIdentifier: CarouselCell.reuseIdentifier)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let reusableCell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselCell.reuseIdentifier, for: indexPath) as? CarouselCell else {
            fatalError()
        }
        
        let index : Int = (indexPath.section * self.images.count) + indexPath.row
        
        reusableCell.configure(with: self.images[index])
        
        return reusableCell
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let theLastIndex = Int(self.collectionView.contentOffset.x / self.collectionView.bounds.width)
        coordinator.animate(
            alongsideTransition: { [unowned self] _ in
                self.collectionView.scrollToItem(at: IndexPath(item: theLastIndex, section: 0), at: .centeredHorizontally, animated: true)
            },
            completion: { [unowned self] _ in
                // if we want to do something after the size transition
            }
        )
    }

    
}

