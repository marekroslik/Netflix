import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class OnBoardingViewController: UIViewController {
    
    private let backGround = OnBoardingUIView()
    private let firstView = FirstOnBoardingUIView()
    private let secondView = SecondOnBoardingUIView()
    
    var viewModel: OnBoardingViewModel!
    
    private let bag = DisposeBag()
    
    private lazy var views = [firstView, secondView]
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(views.count), height: view.frame.height - 100)
        for index in 0..<views.count {
            scrollView.addSubview(views[index])
            views[index].frame = CGRect(x: view.frame.width * CGFloat(index), y: 0, width: view.frame.width, height: view.frame.height)
        }
        scrollView.delegate = self
        return scrollView
    }()
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = views.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .red
        pageControl.addTarget(self, action: #selector(pageControlTapHandler(sender: )), for: .valueChanged)
        return pageControl
    }()
    
    @objc
    func pageControlTapHandler(sender: UIPageControl) {
        scrollView.scrollTo(horizontalPage: sender.currentPage, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        addSubviews()
        applyConstraints()
        singInButton()
        singUpButton()
    }
    
    // SignInButton
    private func singInButton() {
        self.backGround.signInButton.rx.tap.bind { [ weak self] in
            guard let self = self else { return }
            // Open Login View
            self.viewModel.signIn()
           
            // Add animation
            self.backGround.signInButton.animateWhenPressed(disposeBag: self.bag)
        }.disposed(by: bag)
    }
    
    private func singUpButton() {
        self.secondView.signUpButton.rx.tap.bind { [ weak self] in
            guard let self = self else { return }
            // Open URL
            if let url = URL(string: "https://www.themoviedb.org/signup?") {
                UIApplication.shared.open(url)
            }
            // Add animation
            self.secondView.signUpButton.animateWhenPressed(disposeBag: self.bag)
        }.disposed(by: bag)
    }
    
    // Add subviews
    private func addSubviews() {
        view.addSubview(backGround)
        view.addSubview(scrollView)
        view.addSubview(pageControl)
    }
    
    // Set Constraints
    private func applyConstraints() {
        backGround.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        scrollView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-100)
        }
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-100)
        }
    }
}

extension OnBoardingViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / view.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
}

extension OnBoardingViewController {
    enum Event {
        case login
    }
}
