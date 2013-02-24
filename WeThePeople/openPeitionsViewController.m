//
//  openPeitionsViewController.m
//  WeThePeople
//
//  Created by Robert Eickmann on 2/22/13.
//  Copyright (c) 2013 devnull. All rights reserved.
//

#import "openPeitionsViewController.h"
#import <QuartzCore/QuartzCore.h> 

@interface openPeitionsViewController ()

@end

@implementation openPeitionsViewController
NSMutableArray *peitionTableViewArray;
@synthesize tableView;

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

-(void)viewWillAppear:(BOOL)animated {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *arrayPath = [documentsDirectory stringByAppendingPathComponent:@"example.dat"];
    
    NSMutableArray *issueSorter = [[NSMutableArray alloc] init];
    issueSorter = [NSKeyedUnarchiver unarchiveObjectWithFile:arrayPath];
    
    for (int i = 0; i<[issueSorter count]; i++ ) {
        if ([[[issueSorter objectAtIndex:i] objectForKey:@"status"] isEqual: @"open"]) {
            NSLog(@"open");
            [peitionTableViewArray addObject:[issueSorter objectAtIndex:i]];
        } else {
            NSLog(@"responded");
        }
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    peitionTableViewArray = [[NSMutableArray alloc] init];
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(0, 0, 60, 22);
    [closeButton setTitle:@"Close" forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    closeButton.backgroundColor = [UIColor colorWithRed:0.812 green:0.416 blue:0.349 alpha:1];
    closeButton.layer.borderColor = [UIColor blackColor].CGColor;
    closeButton.layer.borderWidth = 1.0f;
    closeButton.layer.cornerRadius= 10.0f;
    [self.view addSubview:closeButton];
    
}

#pragma mark tableView Code

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // determine the selected data from the IndexPath.row
    
    NSLog(@"Selected Row: %d" , indexPath.row);
    
    NSLog(@"Issue URL: %@", [[peitionTableViewArray objectAtIndex:indexPath.row] objectForKey:@"url" ]);
    
    
    NSURL *url = [ [ NSURL alloc ] initWithString:[[peitionTableViewArray objectAtIndex:indexPath.row] objectForKey:@"url"] ];
    [[UIApplication sharedApplication] openURL:url];
    
    //    CGRect webFrame = CGRectMake(0.0, 0.0, 320.0, 460.0);
    //    UIWebView *webView = [[UIWebView alloc] initWithFrame:webFrame];
    //    [webView setBackgroundColor:[UIColor greenColor]];
    //    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    //    [webView loadRequest:requestObj];
    
    
    
    
    
    
    
    //Stub slide out UIView with details about the peition.
    //NSLog(@"%@", [[peitionTableViewArray objectAtIndex:indexPath.row] objectForKey:@"body"]);
    
    //    selectedSignaturesID = [[peitionTableViewArray objectAtIndex:indexPath.row] objectForKey:@"id"];
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Select your issue";
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)searchTableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [peitionTableViewArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.backgroundColor = [UIColor colorWithRed:0.282 green:0.506 blue:0.706 alpha:1];  /*#4881b4*/
    
    // create the title label:                                             x    y   width  height
    UILabel *peitionTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10.0, 210, 120)];
    [peitionTitleLabel setTag:1];
    [peitionTitleLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
    peitionTitleLabel.textAlignment= NSTextAlignmentCenter;
    peitionTitleLabel.textColor = [UIColor blackColor];
    peitionTitleLabel.numberOfLines = 5;
    peitionTitleLabel.layer.borderWidth = 1.0f;
    peitionTitleLabel.layer.cornerRadius= 10.0f;
    peitionTitleLabel.backgroundColor = [UIColor colorWithRed:0.282 green:0.506 blue:0.706 alpha:1];  /*#4881b4*/
    
    // custom views should be added as subviews of the cell's contentView:
    [cell.contentView addSubview:peitionTitleLabel];
    
    UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 140, 180, 20)];
    [statusLabel setTag:4];
    [statusLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
    statusLabel.textAlignment = NSTextAlignmentLeft;
    statusLabel.textColor = [UIColor blackColor];
    statusLabel.layer.borderWidth = 1.0f;
    statusLabel.layer.cornerRadius = 10.0f;
    statusLabel.backgroundColor = [UIColor colorWithRed:0.282 green:0.506 blue:0.706 alpha:1];  /*#4881b4*/
    [cell.contentView addSubview:statusLabel];
    
    //create the remaing signatures label
    UILabel *signaturesNeededLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 160, 180, 20)];
    [signaturesNeededLabel setTag:2];
    [signaturesNeededLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
    signaturesNeededLabel.textAlignment = NSTextAlignmentLeft;
    signaturesNeededLabel.textColor = [UIColor blackColor];
    signaturesNeededLabel.layer.borderWidth = 1.0f;
    signaturesNeededLabel.layer.cornerRadius = 10.0f;
    signaturesNeededLabel.backgroundColor = [UIColor colorWithRed:0.282 green:0.506 blue:0.706 alpha:1];  /*#4881b4*/
    [cell.contentView addSubview:signaturesNeededLabel];
    
    //create the time left label
    UILabel *daysLeftLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 180, 180, 20)];
    [daysLeftLabel setTag:3];
    [daysLeftLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
    daysLeftLabel.textAlignment = NSTextAlignmentLeft;
    daysLeftLabel.textColor = [UIColor blackColor];
    daysLeftLabel.layer.borderWidth = 1.0f;
    daysLeftLabel.layer.cornerRadius = 10.0f;
    daysLeftLabel.backgroundColor = [UIColor colorWithRed:0.282 green:0.506 blue:0.706 alpha:1];  /*#4881b4*/
    [cell.contentView addSubview:daysLeftLabel];
    
    //Create the favorite switch
    UILabel *favoriteSwitchLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 140, 180, 20)];
    favoriteSwitchLabel.text = @"Favorite Issue";
    favoriteSwitchLabel.font = [UIFont boldSystemFontOfSize:10.0];
    favoriteSwitchLabel.textColor = [UIColor blackColor];
    [cell.contentView addSubview:favoriteSwitchLabel];
    
    UISwitch *favoriteSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(200, 160, 180, 20)];
    [cell.contentView addSubview:favoriteSwitch];
    
    //display the signatures needed
    NSString *signaturesNeededText = [NSString stringWithFormat:@"Signatures Needed:%@", [[peitionTableViewArray objectAtIndex:indexPath.row] objectForKey:@"signatures needed"] ];
    signaturesNeededLabel.text = signaturesNeededText;
    
    //display the peition title
    peitionTitleLabel.text = [[peitionTableViewArray objectAtIndex:indexPath.row] objectForKey:@"title"];
    
    //display the status
    statusLabel.text = [NSString stringWithFormat:@"Status: %@", [[peitionTableViewArray objectAtIndex:indexPath.row] objectForKey:@"status"]];
    
    //display the days left
    //We get the Unix timeStamp for @"deadline" and convert it into a displayable string in the tableview.
    //Apple often gets their date math wrong, hopefully this is all correct and works...
    NSDate *lastDayDate = [NSDate dateWithTimeIntervalSince1970:[[[peitionTableViewArray objectAtIndex:indexPath.row] objectForKey:@"deadline"] doubleValue]];
    NSDate *now = [NSDate date];
    NSTimeInterval diff = [lastDayDate  timeIntervalSinceDate:now];
    int numberOfDays = diff / 86400;
    daysLeftLabel.text = [NSString stringWithFormat:@"%d days left on petition", numberOfDays];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 44.0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200.0;
}






- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
