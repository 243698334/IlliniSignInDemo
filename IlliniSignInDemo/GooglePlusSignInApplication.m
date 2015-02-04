//
//  GooglePlusSignInApplication.m
//  IlliniSignInDemo
//
//  Created by Kevin Yufei Chen on 2/4/15.
//  Copyright (c) 2015 Kevin Yufei Chen. All rights reserved.
//

#import "GooglePlusSignInApplication.h"

@implementation GooglePlusSignInApplication

- (BOOL)openURL:(NSURL *)url {
    if ([[url absoluteString] hasPrefix:@"googlechrome-x-callback:"]) {
        return  NO;
    } else if ([[url absoluteString] hasPrefix:@"https://accounts.google.com/o/oauth2/auth"]) {
        
        // Notify IlliniSignInViewController to start the sign in process
        [[NSNotificationCenter defaultCenter] postNotificationName:@"OpenGooglePlusSignInNotification" object:url];
        return NO;
    }
    return [super openURL:url];
}

@end
