import UIKit

final class SelectCountryButton: UIButton {

    private let path = UIBezierPath()
    private let arrowSize: CGFloat = 10

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard path.contains(point) else { return nil }
        return self
    }

    private let countryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = .red// Colors.accent.color
        return label
    }()

    override public var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 1) {
                self.backgroundColor = self.isHighlighted ? .systemGray4 : .clear
            }
        }
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawCountryButton()
        addButtonLayer()
    }

    override func setTitle(_ title: String?, for state: UIControl.State) {
        countryLabel.text = title
    }

    private func setupSubviews() {
        addSubview(countryLabel)
        countryLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(40)
            $0.centerY.equalToSuperview().offset(-arrowSize / 2)
        }
    }

    private func drawCountryButton() {
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 0, y: frame.height - arrowSize))
        path.addLine(to: CGPoint(x: frame.width, y: frame.height - arrowSize))
        path.addLine(to: CGPoint(x: frame.width, y: 0))
        path.close()

        path.move(to: CGPoint(x: frame.width, y: frame.height - arrowSize))
        path.addLine(to: CGPoint(x: 69, y: frame.height - arrowSize))
        path.addLine(to: CGPoint(x: 69 - arrowSize, y: frame.height))
        path.addLine(to: CGPoint(x: 69 - arrowSize * 2, y: frame.height - arrowSize))
        path.close()
    }

    private func addButtonLayer() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        layer.mask = shapeLayer
    }
}
