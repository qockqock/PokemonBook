//
//  DetailViewController.swift
//  PokemonBook
//
//  Created by 머성이 on 8/6/24.
//

import UIKit
import RxSwift
import SnapKit

class DetailViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    private var viewModel: DetailViewModel
    
    // MARK: - 폰트 기본 설정 및 이미지
    // Label 생성 클로저
    private let createLabel: (CGFloat) -> UILabel = {fontSize in
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: fontSize)
        return label
    }
    
    // Image 생성
    private let pokemonImage: UIImageView = {
        let imageView = UIImageView()
//        imageView.setImage(with:URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(viewModel.pokemonID).png"))
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    // MARK: - 타입, 키, 몸무게 관련 레이블 선언
    private lazy var numberLabel = createLabel(24)
    private lazy var nameLabel = createLabel(24)
    private lazy var typeLabel = createLabel(16)
    private lazy var heightLabel = createLabel(16)
    private lazy var weightLabel = createLabel(16)
    
    init(id: Int) {
        self.viewModel = DetailViewModel(pokemonID: String(id))
        super.init(nibName: nil, bundle: nil)
        
        fetchPokemonImage(id: id)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind()
        
        view.backgroundColor = UIColor.mainRed
    }
    
    private func configureUI() {
        setupUI()
    }
    
    private func bind() {
        viewModel.pokeDetail
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] info in
                guard let self = self else { return }
                
                let id = " NO." + String(info.id!)
                let name = PokemonTranslator.getKoreanName(for: info.name ?? "")
                let types =  "타입: " + (info.types.first.map { self.viewModel.translatedTypeName(from: $0.type.name ?? "") } ?? "")
                let weight = "키: \(String(format: "%.1f", (info.weight ?? 0) * 0.1)) cm"
                let height = " 몸무게: \(String(format: "%.1f", (info.height ?? 0) * 0.1)) kg"
                
                self.numberLabel.text = id
                self.nameLabel.text = name
                self.typeLabel.text = types
                self.weightLabel.text = weight
                self.heightLabel.text = height
            },
                       onError: { error in
                print(error)
            }).disposed(by: disposeBag)
    }
    
    private func fetchPokemonImage(id: Int) {
        PokeNetworkManager.shared.fetchImage(id: id)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] image in
                self?.pokemonImage.image = image
            })
            .disposed(by: disposeBag)
    }
    
    private func setupUI() {
        // 뷰 생성
        lazy var pokeView: UIView = {
            let view = UIView()
            view.addSubview(mainStackView)
            view.backgroundColor = UIColor.darkRed
            view.layer.cornerRadius = 20
            return view
        }()
        
        // numberLabel과 nameLabel을 가로로 배치
        let horizontalStackView = UIStackView(arrangedSubviews: [numberLabel, nameLabel])
        horizontalStackView.axis = .horizontal
        horizontalStackView.alignment = .center
        horizontalStackView.spacing = 8
        
        // 레이블 관련 스택뷰
        let labelsStackView = UIStackView(arrangedSubviews: [horizontalStackView, typeLabel, heightLabel, weightLabel])
        labelsStackView.axis = .vertical
        labelsStackView.alignment = .center
        labelsStackView.spacing = 10
        
        // 메인 스택뷰
        let mainStackView = UIStackView(arrangedSubviews: [pokemonImage, labelsStackView])
        mainStackView.axis = .vertical
        mainStackView.alignment = .center
        mainStackView.spacing = 20
        mainStackView.backgroundColor = UIColor.darkRed
        
        [pokeView].forEach {
            view.addSubview($0)
        }
        
        pokeView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(100)
            $0.leading.trailing.equalToSuperview().inset(40)
            $0.height.equalTo(400)
                }
        
        mainStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(320)
        }
        
        pokemonImage.snp.makeConstraints {
            $0.width.height.equalTo(180)
        }
    }
}
