//
//  AlertManager.swift
//  Stocktopus
//
//  Created by Enes Buğra Yenidünya on 7.10.2023.
//

import Foundation
import UIKit

// MARK: - AlertShowable
protocol AlertShowable {
    func showAlert(with error: NetworkError)
}

// MARK: - AlertManager
final class AlertManager: AlertShowable {
    
    // MARK: Properties
    static let shared: AlertShowable = AlertManager.init()
    
    weak var controller: UIViewController?
    
    // MARK: Init
    private init() { }
    
    func showAlert(with error: NetworkError) {
        let message = getMessageForNetworkError(error)
        guard let controller = controller, !message.isEmpty else { return }
        
        let alert = UIAlertController(title: Constant.Alert.title, message: message, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: Constant.Alert.ok, style: .cancel, handler: { _ in
        }))

        DispatchQueue.main.async {
            controller.present(alert, animated: true, completion: nil)
        }
    }
}

// MARK: - Helpers
private extension AlertManager {
    func getMessageForNetworkError(_ error: NetworkError) -> String {
        switch error {
        case .invalidResponse:
            return Constant.API.invalidResponseMessage
        case .networkError(let error):
            return error.localizedDescription
        case .graphQLErrors(_, let string):
            return string
        case .apiCallLimitExceeded:
            showAlertWithTimer()
            return ""
        }
    }
    
    func showAlertWithTimer() {
        guard let controller = controller else { return }
        
        // 1 minute for the waiting time
        let initialRemainingTime = 60
        
        let alertController = createAlertController(with: initialRemainingTime)
        
        DispatchQueue.main.async {
            controller.present(alertController, animated: true, completion: nil)
        }
        
        startTimer(for: alertController, with: initialRemainingTime)
    }
    
    func createAlertController(with remainingTime: Int) -> UIAlertController {
        let alertController = UIAlertController(title: Constant.Alert.title, message: Constant.Alert.apiLimitErrorMessage(time: "\(remainingTime)"), preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: Constant.Alert.ok, style: .default) { [weak self] _ in
            self?.resetRemainingTime(for: alertController)
        }
        
        okAction.isEnabled = false
        alertController.addAction(okAction)
        
        return alertController
    }

    func startTimer(for alertController: UIAlertController, with initialRemainingTime: Int) {
        var remainingTime = initialRemainingTime
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            remainingTime -= 1
            alertController.message = Constant.Alert.apiLimitErrorMessage(time: "\(remainingTime)")
            
            if remainingTime == .zero {
                self.enableOKAction(for: alertController)
                timer.invalidate()
            }
        }
    }

    func resetRemainingTime(for alertController: UIAlertController) {
        alertController.message = Constant.Alert.apiLimitErrorMessage(time: "60")
        if let okAction = alertController.actions.first {
            okAction.isEnabled = false
        }
    }

    func enableOKAction(for alertController: UIAlertController) {
        if let okAction = alertController.actions.first {
            okAction.isEnabled = true
        }
    }
}
