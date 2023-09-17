//
//  DetailListView.swift
//  Nanimo
//
//  Created by Lena on 2023/09/13.
//

import UIKit

class DetailListViewController: UIViewController {
    
    private var dateLabel = UILabel()
    
    // 테이블뷰
    // 레이블들 : 시간, 소리, 주소, 알람, dB
    private lazy var detailListTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(DetailListTableViewCell.self, forCellReuseIdentifier: DetailListTableViewCell.reusableIdentifier)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        detailListTableView.delegate = self
        detailListTableView.dataSource = self
        view.addSubview(detailListTableView)
        configureLayout()
        
        navigationItem.title = "9월 14일"
    }
    
    private func configureLayout() {
        detailListTableView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
    }
    
    private func configureLabel() {
        dateLabel.setLabel(labelText: "9월 14일", backgroundColor: .clear, weight: .regular, textSize: 20, labelColor: .black)
    }
}

extension DetailListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailListTableViewCell.reusableIdentifier, for: indexPath) as! DetailListTableViewCell
        
        cell.timeLabel.setLabel(labelText: "14:23", backgroundColor: .clear, weight: .medium, textSize: 12, labelColor: .gray)
        cell.soundIdentifierLabel.setLabel(labelText: "문 소리", backgroundColor: .clear, weight: .medium, textSize: 16, labelColor: .black)
        cell.addressLabel.setLabel(labelText: "경기 고양시 일산동구", backgroundColor: .clear, weight: .medium, textSize: 12, labelColor: .gray)
        cell.decibelLabel.setLabel(labelText: "32 dB", backgroundColor: .customBackgroundGreen, weight: .regular, textSize: 14, labelColor: .customGreen)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    
}
