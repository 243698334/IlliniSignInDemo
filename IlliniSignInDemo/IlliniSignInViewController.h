//
//  IlliniSignInViewController.h
//  IlliniSignInDemo
//
//  Created by Kevin Yufei Chen on 2/4/15.
//  Copyright (c) 2015 Kevin Yufei Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GooglePlus/GooglePlus.h>

@class GPPSignInButton;

@interface IlliniSignInViewController : UIViewController <GPPSignInDelegate, UIWebViewDelegate, UIAlertViewDelegate>

@property (retain, nonatomic) IBOutlet GPPSignInButton *signInButton;
@property (nonatomic, strong) UIWebView *googlePlusSignInWebView;

@end

