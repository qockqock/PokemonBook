//
//  ViewController.swift
//  PokemonBook
//
//  Created by 머성이 on 8/4/24.
//

import UIKit
import SnapKit
import RxSwift

class MainViewController: UIViewController {

    private var disposeBag = DisposeBag()
    private var pokeInfo = [PokeInfo]()
    private var viewModel = MainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    // 포켓볼 이미지 관련
    private lazy var pokeballImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "pokeball")
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    // 컬렉션 뷰 관련
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: pokeLayout())
        // * 36번 라인은 디테일 뷰 생성해서 셀에 들어갈 내용 정리하고 레지스터에 추가해주면 될 듯?
        //collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "PokemonCell")
        collectionView.delegate
        collectionView.dataSource
        collectionView.backgroundColor = UIColor.cellBackground
        
        return collectionView
    }()
    
    // 데이터 바인딩
    private func bind() {
        viewModel.pokeInfoSubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] results in
                self?.pokeInfo = results
                self?.collectionView.reloadData()
            }, onError: { error in
            print("에러 발생 \(error)")
            }).disposed(by: disposeBag)
    }
    
    private func pokeLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 10
        let numberOfItemsRow: CGFloat = 3
        let width = (view.frame.width - (numberOfItemsRow + 1) * spacing) / numberOfItemsRow
        
        layout.itemSize = CGSize(width: width, height: width)
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        
        return layout
    }
    
    private func configureUI() {
        view.backgroundColor = UIColor.mainRed
        setup()
    }
    
    private func setup() {
        [pokeballImage, collectionView].forEach {
            view.addSubview($0)
        }
        
        // 포켓볼 레이아웃
        pokeballImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(20)
        }
        
        // 컬렉션 뷰 레이아웃
        collectionView.snp.makeConstraints {
            $0.top.equalTo(pokeballImage.snp.bottom).offset(20)
            $0.left.right.bottom.equalToSuperview().inset(10)
        }
    }
}

extension UIColor {
    static let mainRed = UIColor(red: 190/255, green: 30/255, blue: 40/255, alpha: 1.0)
    static let darkRed = UIColor(red: 120/255, green: 30/255, blue: 30/255, alpha: 1.0)
    static let cellBackground = UIColor(red: 245/255, green: 245/255, blue: 235/255, alpha: 1.0)
}

extension MainViewController: UICollectionViewDelegate {
    // 셀 선택 시 동작구현부분
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        <#code#>
    }
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pokeInfo.count
    }
}

//#Preview {
//    let test = MainViewController()
//    return test
//}
