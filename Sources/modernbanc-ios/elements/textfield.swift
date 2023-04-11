//
//  input-element.swift
//  examp-elements
//
//  Created by Greg Gevorkyan on 3/16/23.
//

import Foundation
import Combine
import UIKit


final public class ModernbancTextfield: UITextField, UITextFieldDelegate {
    
    public var elementId: String = UUID().uuidString
    public var validationFn: ((String?) -> Bool)?
    public var isValid:Bool?
    public var client:ModernbancApiClient?
    
    public init(client: ModernbancApiClient) {
        self.client = client
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    deinit {
    }
    
    private func setup() {
        self.smartDashesType = .no
        self.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    
    public override var text: String? {
        set {
            super.text = newValue
            textFieldDidChange()
        }
        get { return nil }
    }
    
    public func createSecret(completionHandler: @escaping (Result<CreateSecretResponse, MdbApiError>) -> Void) {
        if super.text?.isEmpty == true { return }
        let body = [["name": elementId, "value": super.text!]]
        self.client?.request(path: "secrets", method: .post, body: body, completionHandler: completionHandler)
    }



    override public var selectedTextRange: UITextRange? {
        get {
            return nil
        }
        set {
            // Do nothing
        }
    }
    
    
    @objc func textFieldDidChange() {
        if let validationFn = validationFn {
            isValid = validationFn(super.text)
        }
    }
}

