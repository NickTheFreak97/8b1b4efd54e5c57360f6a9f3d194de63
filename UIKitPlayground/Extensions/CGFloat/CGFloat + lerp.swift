import Foundation

public extension ClosedRange<CGFloat> {
    func larp(_ t: CGFloat) -> CGFloat {
        return (t - self.lowerBound)/(self.upperBound - self.lowerBound)
    }
}
