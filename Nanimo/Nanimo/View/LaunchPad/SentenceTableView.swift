//
//  SentenceTableView.swift
//  Nanimo
//
//  Created by ParkJunHyuk on 2023/08/05.
//

import UIKit
import RxSwift
import RxDataSources
import RxCocoa

class SentenceTableView: UIView {

    // MARK: - Properties
    
    var viewModel: SpeechViewModel? {
        didSet {
            bindViewModel()
        }
    }
    
    let imageConfig = UIImage.SymbolConfiguration(pointSize: 16, weight: .regular)
    
    let disposeBag = DisposeBag()
    
    lazy var sentenceTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none // cell line 없애기
        tableView.register(SentenceTableViewCell.self, forCellReuseIdentifier: SentenceTableViewCell.tableCellId)
        return tableView
    }()
    
    // MARK: - Life Cycles
    
    init(viewModel: SpeechViewModel) {
        super.init(frame: .zero)
        self.viewModel = viewModel
        configureTableView()
        sentenceTableView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - layouts

    private func configureTableView() {
        self.addSubview(sentenceTableView)
        
        sentenceTableView.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor)
    }
}

// MARK: - methods

extension SentenceTableView {
    
    /// 선택한 셀의 정보를 가져와 출력
    func handleCellSelection(at indexPath: IndexPath, dataSource: RxTableViewSectionedReloadDataSource<SectionModel<String, SentenceModel>>) {
        let item = dataSource[indexPath]
        let selectedSentence = item.sentence
        print("Selected cell index: \(indexPath.row)")
        print("Selected cell content: \(item.sentence)")
        viewModel?.updateSelectedSentence(selectedSentence)
        
        viewModel?.isEmptyTextField.onNext(false)
    }

    func bindViewModel() {
        guard let viewModel = viewModel else {
            return
        }

        let dataSource = self.dataSource()
        
        Observable.combineLatest(viewModel.recentSentences, viewModel.favoriteSentences) { recent, favorite in
            [SectionModel(model: "최근 사용한 문장", items: recent),
             SectionModel(model: "즐겨찾기 문장", items: favorite)]
        }
        .bind(to: sentenceTableView.rx.items(dataSource: dataSource))
        .disposed(by: disposeBag)
         
         sentenceTableView.rx.itemSelected
             .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                self.handleCellSelection(at: indexPath, dataSource: dataSource)
            })
            .disposed(by: disposeBag)
    }
    
    /// Cell 디자인
    func dataSource() -> RxTableViewSectionedReloadDataSource<SectionModel<String, SentenceModel>> {
        return RxTableViewSectionedReloadDataSource<SectionModel<String, SentenceModel>>(
            configureCell: { dataSource, tableView, indexPath, item in
                if let cell = tableView.dequeueReusableCell(withIdentifier: "TableCellId", for: indexPath) as? SentenceTableViewCell {
                    cell.sentenceLabel.text = item.sentence
                    cell.selectionStyle = .none
                    if item.isBookmark == true {
                        
                        cell.bookmarkButton.configuration?.image = UIImage(systemName: "star.fill", withConfiguration: self.imageConfig)?.withTintColor(.bulletGray, renderingMode: .alwaysOriginal)
                    } else {
                        cell.bookmarkButton.configuration?.image = UIImage(systemName: "star", withConfiguration: self.imageConfig)?.withTintColor(.bulletGray, renderingMode: .alwaysOriginal)
                    }
                    return cell
                }
                return UITableViewCell()
            },
            titleForHeaderInSection: { dataSource, index in
                return dataSource.sectionModels[index].model
            }
        )
    }
}

extension SentenceTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
}
