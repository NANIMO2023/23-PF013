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
    private var isSuccessRecognition = false
    
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
        self.register(ReversedChattingTableViewCell.self, forCellReuseIdentifier: ReversedChattingTableViewCell.reverseChattingCellId)
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
                    print("message: \(message)")
                    cell.configure(name: message)
                }
                .disposed(by: disposeBag)
        } else {
            viewModel.incomingMessages
                .bind(to: self.rx.items(cellIdentifier: ReversedChattingTableViewCell.reverseChattingCellId, cellType: ReversedChattingTableViewCell.self)) { [weak self] row, message, cell in
                    print("incomingMessage: \(message)")
                    cell.configure(name: message.text)
                    viewModel.updateHeight(cell.chattingBackgroundHeight)
                    
                    if message.isFinal {
                        cell.updateDesign(isFinalized: self?.isSuccessRecognition ?? false)
                    }
                    
                }
                .disposed(by: disposeBag)
        }
        
        viewModel.isInputCompletedRelay
            .asObservable()
            .distinctUntilChanged() // 이전 값과 동일한 값의 연속적인 이벤트는 필터링합니다.
            .filter { $0 == true }  // true 값만을 필터링합니다.
            .subscribe(onNext: { [weak self] result in
                self?.isSuccessRecognition = result
                print("Cell 상태: ",self?.isSuccessRecognition)
            })
    }
}
