//
//  officialResponseViewController.h
//  WeThePeople
//
//  Created by Robert Eickmann on 2/22/13.
//  Copyright (c) 2013 devnull. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebViewController.h" 
#import "prefs.h" 


@interface officialResponseViewController : UIViewController <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, UIWebViewDelegate> {
    UITableView *tableView;
    NSString *savedSearchTerm;
    BOOL SearchWasActive;
    NSInteger savedScopeButtonIndex; 

}
@property (nonatomic, retain) IBOutlet UIImageView *headerImage; 
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UIButton *filterButton; 

@end
