//
//  ChattingTableViewCell.swift
//  Nanimo
//
//  Created by ParkJunHyuk on 2023/08/05.
//

import UIKit

class ChattingTableViewCell: UITableViewCell {

    // MARK: - Properties
    
    static let chattingCellId = "ChattingCellId"
    
    var reverse: Bool = false {
        didSet {
            self.transform = reverse ? CGAffineTransform(scaleX: -1, y: 1) : .identity
        }
    }
    
    private lazy var messageLabel = ChattingMessageView()
    private var chattingBackgroundWidthConstraint: NSLayoutConstraint?
    var chattingBackgroundHeight: CGFloat = 0.0
    
    // MARK: - Life Cycles
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureTableCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder: ) has not been implemneted")
    }
    
    // MARK: - methods for layouts
    
    private func configureTableCell() {
        self.addSubview(messageLabel)
        
        messageLabel.anchor(top: self.safeAreaLayoutGuide.topAnchor, leading: self.safeAreaLayoutGuide.leadingAnchor, bottom: self.safeAreaLayoutGuide.bottomAnchor, trailing: self.safeAreaLayoutGuide.trailingAnchor)
    }
 
    func configure(name: String?){
        messageLabel.configure(name: name)
    }
}
