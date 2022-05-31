import UIKit
import SnapKit

class CommingSoonUIView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // Create category name for comming soon movies view
    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .darkGray
        textField.textColor = .white
        textField.layer.cornerRadius = 5
        let centeredParagraphStyle = NSMutableParagraphStyle()
        centeredParagraphStyle.alignment = .center
        textField.attributedPlaceholder = NSAttributedString(
            string: "Search",
            attributes: [.paragraphStyle: centeredParagraphStyle, NSAttributedString.Key.foregroundColor: UIColor.gray])
        textField.font = .boldSystemFont(ofSize: 14)
        textField.setLeftPadding(10)
        textField.setRightPadding(10)
        textField.tintColor = .red
        return textField
    }()
    
    // Create collection view for comming soon movies view
    private var commingSoonCollectionView: UICollectionView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        applyConstraints()
    }
    
    // Add subviews fucntion
    private func addSubviews() {
        addSubview(searchTextField)
        createCollectionView()
        addSubview(commingSoonCollectionView!)
    }
    
    // Create collection view for comming soon movies view
    private func createCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
        commingSoonCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        guard let commingSoonCollectionView = commingSoonCollectionView else {
            return
        }
        commingSoonCollectionView.register(CustomCommingSoonCollectionViewCell.self,
                                             forCellWithReuseIdentifier: CustomCommingSoonCollectionViewCell.identifier)
        commingSoonCollectionView.dataSource = self
        commingSoonCollectionView.delegate = self
        commingSoonCollectionView.showsVerticalScrollIndicator = false
        commingSoonCollectionView.backgroundColor = .black
    }
    
    // Set constraints function
    private func applyConstraints() {
        // Set seatch text field name constraints
        searchTextField.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.left.equalToSuperview()
            make.height.equalTo(30)
            make.width.equalToSuperview()
        }
        // Set comming soon moveies collection view
        commingSoonCollectionView!.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(searchTextField.snp.bottom).offset(15)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

// Set settings functions
extension CommingSoonUIView {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCommingSoonCollectionViewCell.identifier, for: indexPath)
        return cell
    }

}
