//
//  ChattingTableView.swift
//  Nanimo
//
//  Created by ParkJunHyuk on 2023/08/05.
//

import UIKit

class ChattingTableView: UITableView {
    
    // MARK: - Properties
    
    var reverse: Bool = false

    
    // MARK: - Life Cycles
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        self.separatorStyle = .none
        
        self.register(ChattingTableViewCell.self, forCellReuseIdentifier: "ChattingCellId")
        
        self.delegate = self
        self.dataSource = self
    }
    
    convenience init(reverse: Bool) {
        self.init(frame: .zero, style: .plain)
        self.reverse = reverse
        self.transform = reverse ? CGAffineTransform(scaleX: 1, y: -1) : .identity
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - methods for layouts
    
    
}

extension ChattingTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChattingCellId", for: indexPath) as! ChattingTableViewCell
        
        cell.reverse = reverse
        
        cell.chattingLabel.text = "주문하시겠어요"
        
        
        return cell
    }
}

