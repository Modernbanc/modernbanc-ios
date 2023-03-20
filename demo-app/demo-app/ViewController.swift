//
//  ViewController.swift
//  examp-elements
//
//  Created by Greg Gevorkyan on 3/15/23.
//

import UIKit
import Inject
import modernbanc_ios

class ViewController: UIViewController, UITextFieldDelegate {
    
    var hotReloadView = UIView()
    let stackView = UIStackView()
    let button = UIButton()
    
    var client:ModernbancApiClient
    var label:UILabel
    var input: ModernbancTextfield
    
    init() {
        self.client = ModernbancApiClient(api_key: "nsoPZVAk9EXXx2InwRs6qrWEWVfxaR")
        self.label = UILabel()
        self.input = ModernbancTextfield(client: self.client)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.client = ModernbancApiClient(api_key: "nsoPZVAk9EXXx2InwRs6qrWEWVfxaR")
        self.label = UILabel()
        self.input = ModernbancTextfield(client: self.client)
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHotReloadView()
        setupSubviews()
    }
    
    func setupHotReloadView() {
        view.addSubview(hotReloadView)
        hotReloadView.translatesAutoresizingMaskIntoConstraints = false
        hotReloadView.backgroundColor = .white
        NSLayoutConstraint.activate([
            hotReloadView.widthAnchor.constraint(equalTo: view.widthAnchor),
            hotReloadView.heightAnchor.constraint(equalTo: view.heightAnchor),
            hotReloadView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            hotReloadView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    
        // Add stack
        hotReloadView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        
        NSLayoutConstraint.activate([
            stackView.widthAnchor.constraint(equalTo: hotReloadView.widthAnchor),
            stackView.topAnchor.constraint(equalTo: hotReloadView.topAnchor, constant: 54),
            stackView.centerXAnchor.constraint(equalTo: hotReloadView.centerXAnchor)
        ])
    }

    
    func setupSubviews() {
        
        stackView.spacing = 20
        
        label.text = "Input element now."
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .gray
        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalToConstant: 50)
        ])
        stackView.addArrangedSubview(label)

        
        input = ModernbancTextfield(client: self.client)
        input.backgroundColor = .cyan
        input.translatesAutoresizingMaskIntoConstraints = false
        input.placeholder = "Card number"
        input.layer.borderColor = .init(red: 0, green: 0, blue: 0, alpha: 1)
        stackView.addArrangedSubview(input)
        

        NSLayoutConstraint.activate([
            input.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        button.setTitle("Create token", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .gray
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
        stackView.addArrangedSubview(button)

        button.addTarget(self, action: #selector(tokenize), for: .touchUpInside)
        
    }
    
    @objc func tokenize() {
        input.createToken(completionHandler: { (result: Result<CreateTokenResponse, MdbApiError>) in
            switch result {
            case .success(let response):
                let token = response.result.first
                print("Successfully created token: \(token)")
                DispatchQueue.main.async {
                    self.label.text = "Input element. Token id:\(token?.id)"
                }
            case .failure(let error):
                print("Error creating token: \(error)")
            }})
    }

}

