//
//  PokeCell.swift
//  PokemonBook
//
//  Created by 머성이 on 8/6/24.
//

import UIKit

class PokeCell: UICollectionViewCell {
    static let id = "PokeCell"
    
    let pokeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor.white
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(pokeImageView)
        pokeImageView.frame = contentView.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 렉 줄이기
    override func prepareForReuse() {
        super.prepareForReuse()
        pokeImageView.image = nil
    }
    
    func configure(with pokeInfo: PokeInfo) {
        let id = pokeInfo.id
        
        let urlString = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png"
        
        guard let url = URL(string: urlString) else {return}
        
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {  // URL에서 데이터를 가져옴
                DispatchQueue.main.async {  // 메인 큐에서 UI 업데이트 수행
                    if let image = UIImage(data: data) {
                        self?.pokeImageView.image = image  // 이미지 뷰에 이미지 설정
                    }
                }
            }
        }
    }
}
