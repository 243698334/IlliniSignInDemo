//
//  IlliniSignInViewController.m
//  IlliniSignInDemo
//
//  Created by Kevin Yufei Chen on 2/4/15.
//  Copyright (c) 2015 Kevin Yufei Chen. All rights reserved.
//

#import "IlliniSignInViewController.h"

@interface IlliniSignInViewController ()

@end

@implementation IlliniSignInViewController

static NSString * const kClientID = @"644487797451-jal5aqufd3mjjgj1ap42sl3m0dblvhmv.apps.googleusercontent.com";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Standard Google Plus sign in example
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    signIn.shouldFetchGooglePlusUser = YES;
    signIn.shouldFetchGoogleUserEmail = YES;
    signIn.clientID = kClientID;
    signIn.scopes = @[ @"profile" ];
    signIn.delegate = self;
    
    // Handle the notification sent by GooglePlusSignInApplication class
    [[NSNotificationCenter defaultCenter] addObserverForName:@"OpenGooglePlusSignInNotification" object:nil queue:nil usingBlock:^(NSNotification *note) {
        
        // Create an internal UIWebView instead of jumping to Safari
        self.googlePlusSignInWebView = [[UIWebView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, [UIApplication sharedApplication].statusBarFrame.size.height, self.view.bounds.size.width, self.view.bounds.size.height)];
        self.googlePlusSignInWebView.delegate = self;
        [self.googlePlusSignInWebView loadRequest:[NSURLRequest requestWithURL:note.object]];
        
        // Present the UIWebView, you can do this a lot of ways with better UI effects.
        [self.view addSubview:self.googlePlusSignInWebView];
    }];
}

#pragma mark - GPPSignInDelegate

- (void)finishedWithAuth:(GTMOAuth2Authentication *)auth error:(NSError *)error {
    NSLog(@"Received error %@ and auth object %@" ,error, auth);
    [self.googlePlusSignInWebView removeFromSuperview];
    
    // Now you can access the user's information
    NSString *email = [GPPSignIn sharedInstance].userEmail;
    UIAlertView *finishedWithAuthAlertView = [[UIAlertView alloc] initWithTitle:@"Successfully Signed In" message:[NSString stringWithFormat:@"Email: %@", email] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Sign Out", nil];
    [finishedWithAuthAlertView show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    // Handle the OAuth call back from UIWebView
    if ([[[request URL] absoluteString] hasPrefix:@"com.kevinychen.illinisignindemo:/oauth2callback"]) {
        [GPPURLHandler handleURL:[request URL] sourceApplication:@"com.apple.mobilesafari" annotation:nil];
        return NO;
    } else {
        return YES;
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *sampleNetID = @"ychen131";
    
    // When finished loading the Google Sign In page, fill in the "Email" input with an @illinois.edu email address
    // Then simulate a tap event on the "Sign In" button to let Google redirect you to U of I authentication page
    if ([[[[webView request] URL] absoluteString] hasPrefix:@"https://accounts.google.com/ServiceLogin"]) {
        [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"function simulate(element,eventName){var options=extend(defaultOptions,arguments[2]||{});var oEvent,eventType=null;for(var name in eventMatchers){if(eventMatchers[name].test(eventName)){eventType=name;break;}}if(!eventType)throw new SyntaxError('Only HTMLEvents and MouseEvents interfaces are supported');if(document.createEvent){oEvent=document.createEvent(eventType);if(eventType=='HTMLEvents'){oEvent.initEvent(eventName,options.bubbles,options.cancelable);}else{oEvent.initMouseEvent(eventName,options.bubbles,options.cancelable,document.defaultView,options.button,options.pointerX,options.pointerY,options.pointerX,options.pointerY,options.ctrlKey,options.altKey,options.shiftKey,options.metaKey,options.button,element);}element.dispatchEvent(oEvent);}else{options.clientX=options.pointerX;options.clientY=options.pointerY;var evt=document.createEventObject();oEvent=extend(evt,options);element.fireEvent('on'+eventName,oEvent);}return element;}function extend(destination,source){for(var property in source)destination[property]=source[property];return destination;}var eventMatchers={'HTMLEvents':/^(?:load|unload|abort|error|select|change|submit|reset|focus|blur|resize|scroll)$/,'MouseEvents': /^(?:click|dblclick|mouse(?:down|up|over|move|out))$/};var defaultOptions={pointerX:0,pointerY:0,button:0,ctrlKey:false,altKey:false,shiftKey:false,metaKey:false,bubbles:true,cancelable:true};document.getElementById('Email').value='%@@illinois.edu';simulate(document.getElementById('signIn'),'click');", sampleNetID]];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == [alertView firstOtherButtonIndex]) {
        [[GPPSignIn sharedInstance] signOut];
    }
}

@end
