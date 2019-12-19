//
//  SVViewController.swift
//  RxswiftExercise
//
//  Created by 刘帅仪 on 2019/12/19.
//  Copyright © 2019 刘帅仪. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SVViewController: UIViewController {

    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var usernameValidLab: UILabel!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var pwdValidLab: UILabel!
    @IBOutlet weak var doSomething: UIButton!
    
    var minimalUsernameLength: Int = 5
    var minimalPasswordLength: Int = 5
    var disposable: Disposable?
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameValidLab.text = "Username has to be at least \(minimalUsernameLength) characters"
        pwdValidLab.text = "Password has to be at least \(minimalPasswordLength) characters"
        
        
        // 用户名是否有效
        let usernameValid = usernameTF.rx.text.orEmpty
        //用户名 -> 用户名是否有效
            .map { $0.count >= self.minimalUsernameLength } //map转化成用户名是否有效
            .share(replay: 1, scope: .whileConnected)
        
        let passwordValid = passwordTF.rx.text.orEmpty
            .map { $0.count >= self.minimalPasswordLength }
            .share(replay: 1, scope: .whileConnected)
        
        //合并两者是否同时有效
        let everythingValid = Observable.combineLatest(usernameValid, passwordValid) { $0 && $1 }.share(replay: 1, scope: .whileConnected) //合并两者是否同时有效
        everythingValid
            .bind(to: doSomething.rx.isEnabled)
            .disposed(by: disposeBag)
        
        // 用户名是否有效 -> 密码输入框是否可用
        usernameValid
            .bind(to: passwordTF.rx.isEnabled) //决定密码框是否可用
            .disposed(by: disposeBag)
        
        // 用户名是否有效 -> 用户名提示语是否隐藏
        usernameValid
            .bind(to: usernameValidLab.rx.isHidden) //决定username提示语是否隐藏
            .disposed(by: disposeBag)
        
        passwordValid
            .bind(to: pwdValidLab.rx.isHidden)
            .disposed(by: disposeBag)
        
        doSomething.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.showAlert()
            })
            .disposed(by: disposeBag)

        
    }
    
    func showAlert() -> Void {
        let alertVC = UIAlertController.init(title: "RxExample", message: "This is wonderful", preferredStyle: .alert)
        let alertAC = UIAlertAction(title: "ok", style: .cancel, handler: nil)
        alertVC.addAction(alertAC)
        
        self.present(alertVC, animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
