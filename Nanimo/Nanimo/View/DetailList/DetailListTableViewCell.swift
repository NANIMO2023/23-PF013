//
//  DetailListTableViewCell.swift
//  Nanimo
//
//  Created by Lena on 2023/09/13.
//

import UIKit

class DetailListTableViewCell: UITableViewCell {
    
    static let reusableIdentifier = "DetailListTableViewCell"
    
    var timeLabel = UILabel()
    var soundIdentifierLabel = UILabel()
    var addressLabel = UILabel()
    
    var decibelLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.layer.cornerRadius = 14
        label.clipsToBounds = true
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCell() {
        
        timeLabel.setLabel(labelText: "오후 2시 23분", backgroundColor: .clear, weight: .medium, textSize: 12, labelColor: .gray)
        soundIdentifierLabel.setLabel(labelText: "문 소리", backgroundColor: .clear, weight: .medium, textSize: 16, labelColor: .black)
        addressLabel.setLabel(labelText: "경기 고양시 일산동구", backgroundColor: .clear, weight: .medium, textSize: 12, labelColor: .gray)
        decibelLabel.setLabel(labelText: " 32 dB ", backgroundColor: .customBackgroundGreen, weight: .regular, textSize: 14, labelColor: .customGreen)
        
        [timeLabel, soundIdentifierLabel, addressLabel, decibelLabel].forEach { contentView.addSubview($0) }
        
        timeLabel.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, paddingTop: 5, paddingLeading: 12)
        soundIdentifierLabel.anchor(top: contentView.topAnchor, leading: timeLabel.trailingAnchor, paddingTop: 5, paddingLeading: 12)
        addressLabel.anchor(top: soundIdentifierLabel.bottomAnchor, leading: timeLabel.trailingAnchor, paddingLeading: 12)
        decibelLabel.setWidth(width: 51)
        decibelLabel.setHeight(height: 25)
        decibelLabel.anchor(top: contentView.topAnchor, trailing: contentView.trailingAnchor, paddingTop: 5, paddingTrailing: 12)
        
    }
    
}
