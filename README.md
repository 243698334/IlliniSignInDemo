# IlliniSignInDemo

This is a demo to show you how to use [Google+ Sign In](https://developers.google.com/+/mobile/ios/sign-in) in order to let your users to sign in with their University Of Illinois credentials (NetID and AD Password). 

Normally, sign in with NetID is powered by Shibboleth, which would require a seperate server and approval from CITES. To make the our (especially student developers) lives easier, a workaround would be taking the advantage of Google+ Sign In under OAuth protocol. Since the university's email service for undergraduate students at UIUC is provided by Google Apps, the standard Google Account Sign In page will redirect the user to the U of I's Shibboleth Log In page. This would offer users the best sign-in experience without dealing with Shibboleth. 

## How it works

1. A subclass overrides the ``- (BOOL) openURL:(NSURL *)url`` method would send a notification if the Google Accounts Sign In page is requested. You should also add this subclass as ``NSPrincipalClass`` in your ``info.plist``.
2. In the ViewController for sign in, this notification will be handled by creating a ``UIWebView`` for entering user credentials. 
3. The ``UIWebView`` will also handle the OAuth callback to let the app know the authentication succeeded. 

## Setting up

Install project dependencies from [CocoaPods](http://cocoapods.org/#install) by running this script:
```
pod install
```

Then open the Xcode workspace `IlliniSignInDemo.xcworkspace`.

**Note:** I did not use the official Google+ SDK in this demo, so there is no guarantee this pod will work the same as the Google+ SDK. For your own project, you can follow [this guide](https://developers.google.com/+/mobile/ios/getting-started) to set up the dependencies. 
