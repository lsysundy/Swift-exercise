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
//import

public enum SingleEvent<Element> {
    case success(Element)
    case error(Swift.Error)
}

public enum CompletableEvent {
    case error(Swift.Error)
    case completed
}

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
            .share(replay: 1, scope: .whileConnected) //用于共享一个源，而不是单独创建新源，减少不必要的开支
        
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

        //disposeBag 管理绑定的生命周期，它被清除后，disposeBag管理的未被清除的绑定也会被清除
        
    //single - 产生一个单独的元素
//        func getRepo(_ repo: String) -> Single<[String: Any]> {
//            return Single<[String: Any]>.create {  single in
//
//                let url = URL(string: "https://api.github.com/repos/\(repo)")!
//                let task = URLSession.shared.dataTask(with: url) { data, _, error in
//                    if let error = error {
//                        single(.error(error))
//                        return
//                    }
//
//                    guard let data = data,
//                        let json = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves),
//                    let result = json as? [String: Any] else {
//                        single(.error(DataError.cantParseJSON))
//                        return
//                    }
//
//                    single(.success(result))
//                }
//                task.resume()
//
//                return Disposables.create {
//                    task.cancel()
//                }
//
//            }
//
//
//        }
//
//        getRepo("ReactiveX/RxSwift")
//            .subscribe(onSuccess: { (json) in
//                print("JSON: ", json)
//            }) { (error) in
//                print("Error: ", error)
//            }
//            .disposed(by: disposeBag)
        
        
        
        //completed - 产生完成事件
//        func cacheLocally() -> Completable {
//            return Completable.create { completable in
//               // Store some data locally
////               ...
////               ...
//
//               guard success else {
//                   completable(.error(CacheError.failedCaching))
//                   return Disposables.create {}
//               }
//
//               completable(.completed)
//               return Disposables.create {}
//            }
//        }
//
//        cacheLocally()
//        .subscribe(onCompleted: {
//            print("Completed with no error")
//        }, onError: { error in
//            print("Completed with an error: \(error.localizedDescription)")
//         })
//        .disposed(by: disposeBag)
        
        
        //Maybe -
//        func generateString() -> Maybe<String> {
//            return Maybe<String>.create { maybe in
//                maybe(.success("RxSwift"))
//
//                // OR
//
//                maybe(.completed)
//
//                // OR
//
//                maybe(.error(error))
//
//                return Disposables.create {}
//            }
//        }
//
//        generateString()
//        .subscribe(onSuccess: { element in
//            print("Completed with element \(element)")
//        }, onError: { error in
//            print("Completed with an error \(error.localizedDescription)")
//        }, onCompleted: {
//            print("Completed with no element")
//        })
//        .disposed(by: disposeBag)
        
        //Driver - 优化UI层代码
        //drive 方法只能被 Driver 调用。这意味着，如果你发现代码所存在 drive，那么这个序列不会产生错误事件并且一定在主线程监听。这样你可以安全的绑定 UI 元素。
        
        
        //Signal - 与driver相似 区别在于Driver会对新观察者回放（重新发送）上一个元素，signal不会
        
        
        //AsyncSubject 将在源 Observable 产生完成事件后，发出最后一个元素（仅仅只有最后一个元素）
//        let subject = AsyncSubject<String>()
//        subject
//            .subscribe { print("Subscription: 1 Event:", $0) }
//            .disposed(by: disposeBag)
//
//        subject.onNext("🐶")
//        subject.onNext("🐱")
//        subject.onNext("🐹")
//        subject.onCompleted()
        
        
        //PublishSubject 将对观察者发送订阅后产生的元素，而在订阅前发出的元素将不会发送给观察者
//        let subject = PublishSubject<String>()
//        subject
//            .subscribe { print("Subscription: 1 Event:", $0) }
//            .disposed(by: disposeBag)
//        subject.onNext("🐶")
//        subject.onNext("🐱")
//
//        subject
//          .subscribe { print("Subscription: 2 Event:", $0) }
//          .disposed(by: disposeBag)
//
//        subject.onNext("🅰️")
//        subject.onNext("🅱️")
////        pSubject.onNext("🐹")
        
        
        //ReplaySubject 将对观察者发送全部的元素，无论观察者是何时进行订阅的, 注意不要在多个线程调用onNext onError onComplete
//        let subject = ReplaySubject<String>.create(bufferSize: 1)
//        subject
//            .subscribe { print("Subscription: 1 Event:", $0) }
//            .disposed(by: disposeBag)
//        subject.onNext("🐶")
//        subject.onNext("🐱")
//        subject.onCompleted()
//
//        subject
//          .subscribe { print("Subscription: 2 Event:", $0) }
//          .disposed(by: disposeBag)
//
//        subject.onNext("🅰️")
//        subject.onNext("🅱️")
        
        
        //操作符
        //1. 温度过滤
        let temperature: Observable<Double> = Observable.create { observer -> Disposable in
            return Disposables.create()
        }
        temperature.filter { temperature -> Bool in
            return temperature > 12
        }
        .subscribe(onNext: { (temperature) in
            print("高温：\(temperature)度")
        })
        .disposed(by: disposeBag)
        
        
        //2. 解析JSON
//        let json: Observable<JSON> = Observable.create { JSON -> Disposable in
//            return Disposables.create()
//        }
//        // map 操作符
//        json.map(Model.init)
//            .subscribe(onNext: { model in
//                print("取得 Model: \(model)")
//            })
//            .disposed(by: disposeBag)
        
        //3. 合并套餐
//        let rxHamburg: Observable<Hamburg> = ...
//        // 薯条
//        let rxFrenchFries: Observable<FrenchFries> = ...
//
//        // zip 操作符
//        Observable.zip(rxHamburg, rxFrenchFries)
//            .subscribe(onNext: { (hamburg, frenchFries) in
//                print("取得汉堡: \(hamburg) 和薯条：\(frenchFries)")
//            })
//            .disposed(by: disposeBag)
        
        //
//        let disposeBag = DisposeBag()
//
//        let subject1 = BehaviorSubject(value: "🍎")
//        let subject2 = BehaviorSubject(value: "🐶")
//
//        let variable = Variable(subject1)
//
//        variable.asObservable()
//                .concat()
//                .subscribe { print($0) }
//                .disposed(by: disposeBag)
//
//        subject1.onNext("🍐")
//        subject1.onNext("🍊")
//
//        variable.value = subject2
//
//        subject2.onNext("I would be ignored")
//        subject2.onNext("🐱")
//
//        subject1.onCompleted()
//
//        subject2.onNext("🐭")
        
        
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
