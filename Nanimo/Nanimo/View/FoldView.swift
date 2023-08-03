//
//  FoldView.swift
//  Nanimo
//
//  Created by Lena on 2023/08/02.
//

import UIKit

class FoldView: UIView {
    
    private var chevronImage = UIImageView(image: UIImage(systemName: "chevron.up"))
    private var foldLabel = UILabel()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        configureImage()
        foldLabel.setLabel(labelText: "접어두기", backgroundColor: .clear, weight: .light, textSize: 14, labelColor: .black)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureImage() {
        chevronImage.tintColor = .black
        chevronImage.setHeight(height: 4.95)
    }
    
    func configureLayout() {
        backgroundColor = .clear
        [chevronImage, foldLabel].forEach { addSubview($0) }
        [chevronImage, foldLabel].forEach { $0.centerX(inView: self) }
    
        chevronImage.anchor(top: self.topAnchor)
        foldLabel.anchor(top: chevronImage.bottomAnchor, paddingTop: 2)
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct FoldViewPreview: PreviewProvider{
    static var previews: some View {
        UIViewPreview {
            FoldView()
        }.previewLayout(.sizeThatFits)
    }
}
#endif
