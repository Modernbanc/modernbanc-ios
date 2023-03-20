# modernbanc-ios

Modernbanc iOS is an official Swift library you can use to securely collect sensitive data from your users and store it in Modernbanc's encrypted vault.

## Installation

You can install this library via the Swift Package Manager.

### Usage

This library contains a ModernbancTextfield component that you can embed into your app. Because it extends a native UITextfield component you can style and customize it to your liking.

To use it initialize a Modernbanc API client and then pass it to the textfield.

```swift
  let client = ModernbancApiClient(api_key: "Your api key, ensure it has permissions to Secrets functionality")
  let input = ModernbancTextfield(client: client)
```

Once the user has entered the details you can create a token from the value in the textfield.

```swift
    func tokenize() {
        input.createToken(completionHandler: { (result: Result<CreateTokenResponse, MdbApiError>) in
            switch result {
            case .success(let response):
                let token = response.result.first
                print("Successfully created token: \(String(describing: token))")
                DispatchQueue.main.async {
                    self.label.text = "Token id:\(String(describing: token?.id))"
                }
            case .failure(let error):
                print("Error creating token: \(error)")
            }})
    }
```

We prevent you from accessing textfield's raw text but if you want to validate the input you can use our `validationFn` in the following way:

```swift
func isLongerThan5Characters(text:String?) -> Bool {
    return (text?.count ?? 0) > 5
}

input.validationFn = isLongerThan5Characters

input.text = "Hello world"

print("Value is currently valid \(input.isValid)")

```

### Demo app

To run the demo app, open `./demo-app/demo-app.xcodeproj` and ensure you've created a Constants.swift with below content:

```swift
public let mdb_api_key = "The api key you can get from Modernbanc UI"
```
