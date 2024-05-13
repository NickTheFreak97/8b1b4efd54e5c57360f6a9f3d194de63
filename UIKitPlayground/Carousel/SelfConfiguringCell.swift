import UIKit

protocol SelfConfiguringCell: UICollectionViewCell {
    static var reuseIdentifier: String { get }
    
    func configure(with image: String)
}
