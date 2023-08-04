//
//  SentenceTableViewCell.swift
//  Nanimo
//
//  Created by ParkJunHyuk on 2023/08/05.
//

import UIKit

class SentenceTableViewCell: UITableViewCell {

    static let tableCellId = "TableCellId"
    
    lazy var bookmarkButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.plain()
        button.configuration = configuration
        return button
    }()
    
    lazy var sentenceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .detailTextGrayButton
        return label
    }()
    
    lazy var sentenceBackgroundView: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 366, height: 44)
        view.backgroundColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 0.5)
        view.layer.cornerRadius = 10
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutSubviews()
        configureTableCell()
        
        bookmarkButton.isUserInteractionEnabled = true
        bookmarkButton.addTarget(self, action: #selector(bookmarkButtonClicked(_:)), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder: ) has not been implemneted")
    }
    
    private func configureTableCell() {
        
        self.addSubview(sentenceBackgroundView)
        sentenceBackgroundView.addSubview(bookmarkButton)
        sentenceBackgroundView.addSubview(sentenceLabel)
        
        sentenceBackgroundView.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, paddingTop: 4, paddingBottom: 4)
        
        bookmarkButton.anchor(top: sentenceBackgroundView.topAnchor, leading: sentenceBackgroundView.leadingAnchor, bottom: sentenceBackgroundView.bottomAnchor, paddingLeading: 10, width: 21, height: 24)
        
        sentenceLabel.anchor(top: sentenceBackgroundView.topAnchor, leading: bookmarkButton.trailingAnchor, bottom: sentenceBackgroundView.bottomAnchor, trailing: sentenceBackgroundView.trailingAnchor, paddingLeading: 8)
    }
    
    @objc func bookmarkButtonClicked(_ sender: UIButton) {
        print("버튼 눌림")
    }
}
