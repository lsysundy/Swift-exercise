//
//  ViewController.swift
//  RxswiftExercise
//
//  Created by 刘帅仪 on 2019/12/19.
//  Copyright © 2019 刘帅仪. All rights reserved.
//

import RxSwift

#if os(iOS)
    import UIKit
    typealias OSViewController = UIViewController
#elseif os(macOS)
    import Cocoa
    typealias OSViewController = UIViewController
#endif

class ViewController: OSViewController {
    var disposeBag = DisposeBag()
    
}

