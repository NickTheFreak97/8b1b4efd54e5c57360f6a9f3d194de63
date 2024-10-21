import UIKit

public protocol PlaceableView: UIView {
    func getOrigin(for containerSize: CGSize) -> CGPoint
    func getSize(for containerSize: CGSize) -> CGSize
    func updateForZoom(_ scrollView: UIScrollView)
    func resize(for containerSize: CGSize)
}
