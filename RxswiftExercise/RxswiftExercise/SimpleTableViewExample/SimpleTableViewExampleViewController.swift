//
//  SimpleTableViewExampleViewController.swift
//  RxswiftExercise
//
//  Created by 刘帅仪 on 2020/1/6.
//  Copyright © 2020 刘帅仪. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SimpleTableViewExampleViewController: ViewController, UITableViewDelegate {
        
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let items = Observable.just(
            (0..<20).map { "\($0)" }
        )

        items
            .bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)) {
                    (row, element, cell) in
                    cell.textLabel?.text = "\(element) @ row \(row)"
                }
            .disposed(by: disposeBag)

        tableView.rx
            .modelSelected(String.self)
            .subscribe(onNext: {
                value in
                DefaultWireframe.presentAlert("Tapped `\(value)`")
            })
            .disposed(by: disposeBag)

        tableView.rx
            .itemAccessoryButtonTapped
            .subscribe(onNext: {
                indexPath in
                DefaultWireframe.presentAlert("Tapped Detail @ \(indexPath.section),\(indexPath.row)")
            })
            .disposed(by: disposeBag)
        
    }
    
}
