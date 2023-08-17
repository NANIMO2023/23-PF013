//
//  ChattingTableView.swift
//  Nanimo
//
//  Created by ParkJunHyuk on 2023/08/05.
//

import UIKit
import RxSwift
import RxCocoa

class ChattingTableView: UITableView {
    
    // MARK: - Properties
    
    var isReversed: Bool = false
    
    var viewModel: ChattingViewModel? {
        didSet {
            bindViewModel()
        }
    }
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.allowsSelection = false
        self.separatorStyle = .none
        self.register(ChattingTableViewCell.self, forCellReuseIdentifier: ChattingTableViewCell.chattingCellId)
    }
    
    convenience init(isReversed: Bool, chattingViewModel: ChattingViewModel) {
        self.init(frame: .zero, style: .plain)
        self.isReversed = isReversed
        self.transform = isReversed ? CGAffineTransform(scaleX: 1, y: -1) : .identity
        self.viewModel = chattingViewModel
        bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ChattingTableView {
    private func bindViewModel() {
        guard let viewModel = viewModel else { return }
        if isReversed == true {
            // 메시지를 가져와 셀에 표시
            viewModel.myMessages
                .bind(to: self.rx.items(cellIdentifier: ChattingTableViewCell.chattingCellId, cellType: ChattingTableViewCell.self)) { [weak self] row, message, cell in
                    cell.reverse = self?.isReversed ?? false
                    
                    print("message: \(message)")
                    cell.configure(name: message)
                }
                .disposed(by: disposeBag)
        } else {
            viewModel.incomingMessages
                .bind(to: self.rx.items(cellIdentifier: ChattingTableViewCell.chattingCellId, cellType: ChattingTableViewCell.self)) { [weak self] row, message, cell in
                    cell.reverse = self?.isReversed ?? false
                    
                    print("incomingMessage: \(message)")
                    cell.configure(name: message)
                    viewModel.updateHeight(cell.chattingBackgroundHeight)
                }
                .disposed(by: disposeBag)
        }
    }
}
