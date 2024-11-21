//
//  EmailView.swift
//  AveragePriceCalculator
//
//  Created by Davidyoon on 11/21/24.
//

import SwiftUI
import MessageUI

struct EmailView: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = MFMailComposeViewController
    
    let to: String
    
    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let viewController = MFMailComposeViewController()
        viewController.mailComposeDelegate = context.coordinator
        viewController.setToRecipients([to])
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {
        
    }
    
    func makeCoordinator() -> MailCoordinator {
        return MailCoordinator(self)
    }
    
}

final class MailCoordinator: NSObject, MFMailComposeViewControllerDelegate {
    
    let parent: EmailView
    
    init(_ parent: EmailView) {
        self.parent = parent
    }
    
    func mailComposeController(
        _ controller: MFMailComposeViewController,
        didFinishWith result: MFMailComposeResult,
        error: (any Error)?
    ) {
        controller.dismiss(animated: true)
    }
}
