import Foundation

public extension ClosedRange<CGFloat> {
    func larp(_ t: CGFloat) -> CGFloat {
        return t*(self.upperBound - self.lowerBound)
    }
}
