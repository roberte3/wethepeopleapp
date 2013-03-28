//
//  awaitingResponseViewController.h
//  WeThePeople
//
//  Created by Robert Eickmann on 2/22/13.
//  Copyright (c) 2013 devnull. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "prefs.h"

@interface awaitingResponseViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    UITableView *tableView;
    
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UIButton *filterButton; 
@end
