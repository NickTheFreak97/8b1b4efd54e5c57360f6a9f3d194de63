import UIKit

public protocol CountedUIViewController: UIViewController {
    var pageIndex: Int { get set }
}
