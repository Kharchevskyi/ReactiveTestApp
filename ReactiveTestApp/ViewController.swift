//
//  ViewController.swift
//  ReactiveTestApp
//
//  Created by Anton Kharchevskyi on 28/08/2020.
//  Copyright © 2020 Anton Kharchevskyi. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    let viewModel = ViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        Observable
            .zip(
                viewModel.a,
                viewModel.b
            )
            .filter { $0.0 }
            .subscribe(onNext: { (aValue, bValue) in
                print("^^ a = \(aValue) ---- b = \(bValue)")
            })
            .disposed(by: disposeBag)

     
        viewModel.startEmitValues()
    }
}

struct ViewModel {
    // 1
    private let isExist: PublishSubject<Bool> = PublishSubject()
    
    private let bPublishSubject: PublishSubject<Int> = PublishSubject()
    
    var a: Observable<Bool> { isExist.asObserver() }
    var b: Observable<Int> { bPublishSubject.asObserver() }
     
    func startEmitValues() {
        // 2 - стартуем с true
        isExist.onNext(true)
        bPublishSubject.onNext(1)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.isExist.onNext(false)
        }
        
        // 2 должно скипнуть потому что isExist = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.bPublishSubject.onNext(2)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.isExist.onNext(true)
        }
        
        // 3 должно прийти потому что isExist = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            self.bPublishSubject.onNext(3)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
            self.isExist.onNext(false)
        }
        
        // 4 должно скипнуть потому что isExist = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 9) {
            self.bPublishSubject.onNext(4)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            self.isExist.onNext(true)
        }
        
        // 5 должно скипнуть потому что isExist = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 11) {
            self.bPublishSubject.onNext(5)
        }
    }
}
