//
//  officialResponseViewController.h
//  WeThePeople
//
//  Created by Robert Eickmann on 2/22/13.
//  Copyright (c) 2013 devnull. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebViewController.h" 


@interface officialResponseViewController : UIViewController <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, UIWebViewDelegate> {
    UITableView *tableView;

}

@property (nonatomic, retain) IBOutlet UITableView *tableView;


@end
