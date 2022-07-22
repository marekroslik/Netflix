import UIKit
import RxSwift

extension UIViewController {
    
    func addKeyboardObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardNotifications(notification:)),
            name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil)
    }
    
    func addButtonsAnimation(_ buttons: UIButton..., disposeBag: DisposeBag) {
        for button in buttons {
            button.animateWhenPressed(disposeBag: disposeBag)
        }
    }
    
    // Will notify when keyboard show / hide
    @objc func keyboardNotifications(notification: NSNotification) {
        
        // Calculate the selected textFields Y Position
        var txtFieldY: CGFloat = 0.0
        
        // Set the space between textfield and keyboard
        let spaceBetweenTxtFieldAndKeyboard: CGFloat = 100.0
        
        var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        
        if let activeTextField = UIResponder.currentFirst() as? UITextField ?? UIResponder.currentFirst() as? UITextView {
            
            // Will get accurate frame of textField
            frame = self.view.convert(activeTextField.frame, from: activeTextField.superview)
            txtFieldY = frame.origin.y + frame.size.height
        }
        
        if let userInfo = notification.userInfo {
            
            // Here we will get frame of keyBoard
            let keyBoardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let keyBoardFrameY = keyBoardFrame!.origin.y
            let keyBoardFrameHeight = keyBoardFrame!.size.height
            var viewOriginY: CGFloat = 0.0
            
            // Check keyboards Y position and move view up and down
            if keyBoardFrameY >= UIScreen.main.bounds.size.height {
                viewOriginY = 0.0
            } else {
                
                // If textfields y is greater than keyboards y then only move View to up
                if txtFieldY >= keyBoardFrameY {
                    
                    viewOriginY = (txtFieldY - keyBoardFrameY) + spaceBetweenTxtFieldAndKeyboard
                    
                    // This condition is just to check viewOriginY should not be greater than keyboard height
                    // If its more than keyboard height then there will be black space on the top of keyboard.
                    if viewOriginY > keyBoardFrameHeight { viewOriginY = keyBoardFrameHeight }
                }
            }
            
            // Set the Y position of view
            self.view.frame.origin.y = -viewOriginY
        }
    }
    
    func hideKeyboardWhenTappedAround() {
            let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
            tap.cancelsTouchesInView = false
            view.addGestureRecognizer(tap)
        }
        
        @objc func dismissKeyboard() {
            view.endEditing(true)
        }
}
