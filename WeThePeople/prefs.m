//
//  prefs.m
//  We The People (Unofficial) 
//
//  Created by Robert Eickmann on 
//  Copyright (c) 2013 devnull. All rights reserved.
//

#import "prefs.h"

@implementation prefs

NSString * const MAIN_URL = @"https://petitions.whitehouse.gov/api/v1/peitions?key=";
//BUG
//"https://petitions.whitehouse.gov/api/v1/petitions.json?key=uNa6aXLQaUcBxsW&limit=1000&offset=0;
//BUG -Remove before commiting to git

NSString * const PETITIONS_URL  = @"https://petitions.whitehouse.gov/api/v1/petitions.json?key=";
NSString * const SERVER_NAME = @"petitions.whitehouse.gov";
NSString * const ACCESS_CODE = @"uNa6aXLQaUcBxsW";
NSString * const SIGNATURES_URL = @"https://petitions.whitehouse.gov/api/v1/petitions/";


//NSString * const SIGNATURES_URL = @"https://petitions.whitehouse.gov/api/v1/petitions/51210a5beab72a3b6f000006/signatures.json?key=uNa6aXLQaUcBxsW&limit=100&offset=0";


+(BOOL) firstLaunch

{
    // Does preference exist...
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"] != 0)
        return [[NSUserDefaults standardUserDefaults] integerForKey:@"firstLaunch"];
    else
        return NO;
}


@end
