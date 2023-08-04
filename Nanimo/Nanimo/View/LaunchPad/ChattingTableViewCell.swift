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
    
    lazy var chattingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
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
        
        self.addSubview(chattingLabel)
        
        chattingLabel.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor)
        
        
    }
}
