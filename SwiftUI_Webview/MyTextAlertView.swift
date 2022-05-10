import Foundation
import UIKit
import SwiftUI

struct MyTextAlertView : UIViewControllerRepresentable {
    @Binding var textString: String
    @Binding var showAlert: Bool

    var title: String
    var message: String
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<MyTextAlertView>) -> some UIViewController {
        return UIViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: UIViewControllerRepresentableContext<MyTextAlertView>) {
        
        guard context.coordinator.uiAlertController == nil else { return }
        
        if self.showAlert == false { return }
        
        let uiAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        uiAlertController.addTextField(configurationHandler: {
            TextField in TextField.placeholder = "전달할 값을 입력허세요"
            TextField.text = textString
        })
        
        uiAlertController.addAction(UIAlertAction(title: "취소", style: .destructive, handler: {
            _ in
                print("취소가 클릭되었다.")
                self.textString = ""
        }))
        
        uiAlertController.addAction(UIAlertAction(title: "확인", style: .default, handler: {
            _ in
                
            if let textField = uiAlertController.textFields?.first,
               let inputText = textField.text {
                self.textString = inputText
            }
            
            uiAlertController.dismiss(animated: true, completion: {
                print("보내기")
                self.textString = ""
                self.showAlert = false
            })
        }))
        
        DispatchQueue.main.async {
            uiViewController.present(uiAlertController, animated: true, completion: {
                self.showAlert = false
                context.coordinator.uiAlertController = nil
            })
        }
    }
    
    func makeCoordinator() -> MyTextAlertView.Coordinator {
        MyTextAlertView.Coordinator(self)
    }
    
    class Coordinator : NSObject {
        var uiAlertController: UIAlertController?
        var myTextAlertView: MyTextAlertView
        
        init(_ myTextAlertView: MyTextAlertView) {
            self.myTextAlertView = myTextAlertView
        }
    }
}

extension MyTextAlertView.Coordinator : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text as NSString? {
            self.myTextAlertView.textString = text.replacingCharacters(in: range, with: string)
        } else  {
            self.myTextAlertView.textString = ""
        }
        return true
    }
}
