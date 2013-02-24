//
//  ViewController.h
//  WeThePeople
//
//  Created by Robert Eickmann on 2/22/13.
//  Copyright (c) 2013 devnull. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h> 
#import <SBJson/SBJson.h>

#import "prefs.h"



@interface ViewController : UIViewController {
    UIButton *officialResponsesButton;
    UIButton *openPeitionsButton;
    UIButton *awaitingResponseButton;
    
    
}

@property (nonatomic, retain) IBOutlet UIButton *officialResponseButton;
@property (nonatomic, retain) IBOutlet UIButton *openPeitionsButton;
@property (nonatomic, retain) IBOutlet UIButton *awaitingResponseButton;



@end
