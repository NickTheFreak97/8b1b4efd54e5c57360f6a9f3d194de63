import UIKit

internal protocol PlaceableColoredView: PlaceableView, UIView {
    func colorChanged(_ color: UIColor)
}
