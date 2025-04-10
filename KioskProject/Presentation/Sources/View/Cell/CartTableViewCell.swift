import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class CartTableViewCell: UITableViewCell {
    
    static let identifier = "CartTableViewCell"
    
    var disposeBag = DisposeBag()
    weak var delegate: CartCellDelegate?
    
    private lazy var productNameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
    }
    
    private lazy var orderCountLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.textAlignment = .center
    }
    
    private lazy var orderAmountsLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.textAlignment = .right
    }
    
    let incrementButton = UIButton().then {
        $0.setTitle("+", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 12)
    }
    
    let decrementButton = UIButton().then {
        $0.setTitle("-", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 12)
    }
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    // MARK: - Configuration
    
    func configure(item: CartItem) {
        productNameLabel.text = item.product.title
        orderAmountsLabel.text = item.totalPrice.wonFormatter()
        orderCountLabel.text = "\(item.count)"
        delegate?.addedCart()
        bindActions()
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        [
            productNameLabel,
            orderCountLabel,
            orderAmountsLabel,
            incrementButton,
            decrementButton
        ].forEach { contentView.addSubview($0) }
    }
    
    private func setConstraints() {
        productNameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.width.equalTo(100)
            $0.centerY.equalToSuperview()
        }
        
        orderAmountsLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
        }
        
        orderCountLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.equalTo(30)
        }
        
        decrementButton.snp.makeConstraints {
            $0.trailing.equalTo(orderCountLabel.snp.leading).offset(-8)
            $0.centerY.equalTo(orderCountLabel)
            $0.width.height.equalTo(24)
        }
        
        incrementButton.snp.makeConstraints {
            $0.leading.equalTo(orderCountLabel.snp.trailing).offset(8)
            $0.centerY.equalTo(orderCountLabel)
            $0.width.height.equalTo(24)
        }
    }

    // MARK: - Actions
    
    private func bindActions() {
        incrementButton.rx.tap
            .bind { [weak self] in
                guard let self else { return }
                self.delegate?.didTapIncrease(cell: self)
            }
            .disposed(by: disposeBag)

        decrementButton.rx.tap
            .bind { [weak self] in
                guard let self else { return }
                self.delegate?.didTapDecrease(cell: self)
            }
            .disposed(by: disposeBag)
    }
}
