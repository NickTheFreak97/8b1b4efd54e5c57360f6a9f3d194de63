import CoreGraphics

extension CGSize {
    static func sizeThatFits(containerSize: CGSize, containedAR: CGFloat) -> CGSize {
        if containedAR.isZero || containedAR.isNaN || containedAR.isInfinite {
            #if DEBUG
                print("Unexpected input parameter `containedAR` value: \(containedAR)")
            #endif
            return .zero
        } else {
            let proposedHeightAtMaxWidth: CGFloat = containerSize.width/containedAR
            if proposedHeightAtMaxWidth > containerSize.height {
                let sizeThatFits = CGSize(width: containerSize.height*containedAR, height: containerSize.height)
                #if DEBUG
                if sizeThatFits.width > containerSize.width || sizeThatFits.height > containerSize.height {
                    print("Computed size \(sizeThatFits) unexpectedly exceeds container size \(containerSize)")
                }
                #endif
                return sizeThatFits
            } else {
                let sizeThatFits = CGSize(width: containerSize.width, height: containerSize.width/containedAR)
                #if DEBUG
                if sizeThatFits.width > containerSize.width || sizeThatFits.height > containerSize.height {
                    print("Computed size \(sizeThatFits) unexpectedly exceeds container size \(containerSize)")
                }
                #endif
                return sizeThatFits
            }
        }
    }
}

