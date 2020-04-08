//
//  UITestScreenMaker.swift
//  CoLocate
//
//  Created by NHSX.
//  Copyright © 2020 NHSX. All rights reserved.
//

import UIKit

#if INTERNAL || DEBUG

struct UITestScreenMaker: ScreenMaking {
    
    func makeViewController(for screen: Screen) -> UIViewController {
        switch screen {
        case .potential:
            let viewController = UIViewController()
            viewController.title = "Potential"
            return UINavigationController(rootViewController: viewController)
        case .onboarding:
            return OnboardingViewController.instantiate {
                $0.environment = OnboardingEnvironment(mockWithHost: $0)
                // TODO: Remove this – currently needed to kick `updateState()`
                $0.rootViewController = nil
            }
        }
    }
    
}

private extension OnboardingEnvironment {
    
    convenience init(mockWithHost host: UIViewController) {
        self.init(
            persistence: InMemoryPersistence(),
            privacyViewControllerInteractor: MockPrivacyViewControllerInteractor(host: host)
        )
    }
    
}

private class InMemoryPersistence: Persisting {
    
    var allowedDataSharing = false
    var registration: Registration? = nil
    var diagnosis = Diagnosis.unknown
    
}

private class MockPrivacyViewControllerInteractor: PrivacyViewControllerInteracting {
    weak var host: UIViewController?
    init(host: UIViewController) {
        self.host = host
    }
    
    func allowDataSharing(completion: @escaping () -> Void) {
        let alert = UIAlertController(title: "Recorded data sharing consent", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in completion() }))
        host?.present(alert, animated: false, completion: nil)
    }

}

#endif
