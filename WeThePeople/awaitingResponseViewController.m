//
//  awaitingResponseViewController.m
//  WeThePeople
//
//  Created by Robert Eickmann on 2/22/13.
//  Copyright (c) 2013 devnull. All rights reserved.
//

#import "awaitingResponseViewController.h"
#import <QuartzCore/QuartzCore.h> 

@interface awaitingResponseViewController ()

@end

@implementation awaitingResponseViewController

-(IBAction)backButtonClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(0, 0, 60, 22);
    [closeButton setTitle:@"Close" forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    closeButton.backgroundColor = [UIColor colorWithRed:0.812 green:0.416 blue:0.349 alpha:1];
    closeButton.layer.borderColor = [UIColor blackColor].CGColor;
    closeButton.layer.borderWidth = 1.0f;
    closeButton.layer.cornerRadius= 10.0f;
    [self.view addSubview:closeButton];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
