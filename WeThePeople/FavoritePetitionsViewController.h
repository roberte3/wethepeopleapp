//
//  FavoritePetitionsViewController.h
//  WeThePeople
//
//  Created by Robert Eickmann on 3/13/13.
//  Copyright (c) 2013 devnull. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavoritePetitionsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    UITableView *tableview;
    
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;

@end
