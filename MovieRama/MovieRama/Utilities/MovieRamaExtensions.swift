//
//  MovieRamaExtensions.swift
//  MovieRama
//
//  Created by  Dimitris Tasios Personal on 23/10/23.
//

import Foundation
import UIKit

extension UIStackView {
    func removeAllArrangedSubviews() {
        for subview in self.arrangedSubviews {
            self.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
    }
}

extension UIView {
    func setUp(forNib nibName: String, onCompletion: (() -> Void)? = nil) {
        let nib = UINib(nibName: nibName, bundle: nil)
        
        guard let view = nib.instantiate(withOwner: self).first as? UIView else {
            fatalError("Cannot load nib")
        }
        
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        addSubview(view)
        
        onCompletion?()
    }
}

extension UIViewController {
    func presentAlertFor(error: Error) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)

        self.present(alertController, animated: true)
    }
}

extension UITextField {
    func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction(){
        self.resignFirstResponder()
    }
}
