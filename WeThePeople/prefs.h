//
//  prefs.h
//  WeThePeople
//
//  Created by Robert Eickmann on 2/22/13.
//  Copyright (c) 2013 devnull. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface prefs : NSObject
extern NSString * const MAIN_URL;
extern NSString * const SERVER_NAME;
extern NSString * const ACCESS_CODE;
extern NSString * const PETITIONS_URL;
extern NSString * const SIGNATURES_URL;
extern int buttonHeight; 



+(BOOL) firstLaunch;

@end
