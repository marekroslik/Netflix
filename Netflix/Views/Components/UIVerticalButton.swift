import UIKit

final class UIVerticalButton: UIButton {

    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        let superRect = super.titleRect(forContentRect: contentRect)
        return CGRect(
            x: 0,
            y: contentRect.height - superRect.height,
            width: contentRect.width,
            height: superRect.height
        )
    }

    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        let superRect = super.imageRect(forContentRect: contentRect)
        return CGRect(
            x: contentRect.width / 2 - superRect.width / 2,
            y: (contentRect.height - titleRect(forContentRect: contentRect).height) / 2 - superRect.height / 2,
            width: superRect.width,
            height: superRect.height
        )
    }

    override var intrinsicContentSize: CGSize {
        _ = super.intrinsicContentSize
        guard let image = imageView?.image else { return super.intrinsicContentSize }
        let size = titleLabel?.sizeThatFits(contentRect(forBounds: bounds).size) ?? .zero
        let spacing: CGFloat = 12
        return CGSize(width: max(size.width, image.size.width), height: image.size.height + size.height + spacing)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        titleLabel?.textAlignment = .center
    }
}
