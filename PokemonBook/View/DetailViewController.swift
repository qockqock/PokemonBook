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
    
    let disposBag = DisposeBag()
    
    // MARK: - 폰트 기본 설정 및 이미지
    // Label 생성 클로저
    private let createLabel: (String, CGFloat) -> UILabel = { text, fontSize in
        let label = UILabel()
        label.text = text
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: fontSize)
        return label
    }
    
    // Image 생성
    private let pokemonImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    // MARK: - 타입, 키, 몸무게 관련 레이블 선언
    private lazy var numberLabel = createLabel("No.54", 24)
    private lazy var nameLabel = createLabel("고라파덕", 24)
    
    private lazy var typeLabel = createLabel("타입: 12", 16)
    private lazy var heightLabel = createLabel("키: 12 m", 16)
    private lazy var weightLabel = createLabel("몸무게: 12kg", 16)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        view.backgroundColor = UIColor.mainRed
    }
    
    private func configureUI() {
        setupUI()
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
        mainStackView.backgroundColor = .blue
        
//        view.addSubview(mainStackView)
        [pokeView].forEach {
            view.addSubview($0)
        }
        
        pokeView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(100)
            $0.leading.trailing.equalToSuperview().inset(40)
            $0.height.equalTo(500)
                }
        
        mainStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(400)
        }
        
        pokemonImage.snp.makeConstraints {
            $0.width.height.equalTo(180)
        }
    }
}

#Preview {
    let test = DetailViewController()
    return test
}
