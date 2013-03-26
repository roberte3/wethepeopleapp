//
//  openPeitionsViewController.m
//  WeThePeople
//
//  Created by Robert Eickmann on 2/22/13.
//  Copyright (c) 2013 devnull. All rights reserved.
//

#import "openPeitionsViewController.h"
#import <QuartzCore/QuartzCore.h> 
#import "WebViewController.h" 

@interface openPeitionsViewController ()

@end

@implementation openPeitionsViewController
NSMutableArray *peitionTableViewArray;
NSMutableArray *unfilteredPeitionTableViewArray;
NSMutableArray *issuesArray;
NSMutableArray *pickerViewArray;
NSMutableArray *favoriteIssuesArray;
NSMutableSet  *favoriteIssuesSet;

@synthesize tableView;

UIWebView *webView;
UIButton *browserCloseButton;
UIButton *zoomButton;
UIActivityIndicatorView *spinner;

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

#pragma mark pickerView Code
- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    NSLog(@"picker row text: %@", [pickerViewArray objectAtIndex:row]);
    
    if (row == 0) {
        peitionTableViewArray = unfilteredPeitionTableViewArray;
    }
    else {
        if ([issuesArray count] > 0) {
            
            [peitionTableViewArray removeAllObjects];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY issues.name ==%@", [pickerViewArray objectAtIndex:row]];
            [peitionTableViewArray addObjectsFromArray:[unfilteredPeitionTableViewArray filteredArrayUsingPredicate:predicate]];
            
        }
    }
    
    [tableView reloadData]; //Update the table
    
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSUInteger numRows = [pickerViewArray count];
    
    return numRows;
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *catagory;
    catagory = [pickerViewArray objectAtIndex:row];
    
    return catagory;
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    int sectionWidth = 300;
    
    return sectionWidth;
}

-(void)viewWillAppear:(BOOL)animated {
    favoriteIssuesArray = [[NSMutableArray alloc] init];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *arrayPath = [documentsDirectory stringByAppendingPathComponent:@"peitions.dat"];
    NSString *favoriteIssuePath = [documentsDirectory stringByAppendingPathComponent:@"favorite.dat"];
    
    //favoriteIssuesSet = the on off state of the favorite switches on the cells.
    favoriteIssuesSet = [[NSMutableSet alloc] initWithArray:[NSKeyedUnarchiver unarchiveObjectWithFile:favoriteIssuePath]];
    [favoriteIssuesArray addObjectsFromArray:[favoriteIssuesSet allObjects]];
    NSLog(@"favoriteIssueSetMonkey: %@", favoriteIssuesSet);
    
    NSMutableArray *issueSorter = [[NSMutableArray alloc] init];
    issueSorter = [NSKeyedUnarchiver unarchiveObjectWithFile:arrayPath];
    
    for (int i = 0; i<[issueSorter count]; i++ ) {
        if ([[[issueSorter objectAtIndex:i] objectForKey:@"status"] isEqual: @"open"] && [[[issueSorter objectAtIndex:i] objectForKey:@"signatures needed"] integerValue] >0 ) {
            [peitionTableViewArray addObject:[issueSorter objectAtIndex:i]];
            [unfilteredPeitionTableViewArray addObject:[issueSorter objectAtIndex:i]];

        } else {
            NSLog(@"responded");
        }
    }
    
    //Create pickerView array;
    
    //Becuse they can add new topic types beyond the first 29, we dynamically build a mutableArray of alphabetaically sorted
    //issue types to display for the UIPickerView.
    
    [pickerViewArray addObject:@"(none)"];
    
    NSMutableSet *pickerDisplaySet = [[NSMutableSet alloc] init]; //Temp Set for sorting.
    NSMutableArray *tempPickerArray = [[NSMutableArray alloc] init];
    
    for (int i=0; i<[unfilteredPeitionTableViewArray count]; i++) {
        NSMutableArray *tmpArray = [[unfilteredPeitionTableViewArray objectAtIndex:i] objectForKey:@"issues"];
        
        for (int j=0; j<[tmpArray count]; j++) {
            [pickerDisplaySet addObject:[[tmpArray objectAtIndex:j]objectForKey:@"name"]];
        }
    }
    NSLog(@"pickerDisplaySet: %@", pickerDisplaySet);
    for(id element in pickerDisplaySet) {
        [tempPickerArray addObject:element];
    }
    NSSortDescriptor *nameSorter = [[NSSortDescriptor alloc] initWithKey:nil ascending:YES selector:@selector(caseInsensitiveCompare:)];
    [tempPickerArray sortUsingDescriptors:[NSArray arrayWithObject:nameSorter]]; //Everything should be a string and sorted Alpha
    
    [pickerViewArray addObjectsFromArray:tempPickerArray];
    NSLog(@"pickerViewArray Count:%d", [pickerViewArray count]);

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    peitionTableViewArray = [[NSMutableArray alloc] init];
    issuesArray = [[NSMutableArray alloc] init];
    unfilteredPeitionTableViewArray = [[NSMutableArray alloc] init];
    pickerViewArray = [[NSMutableArray alloc] init];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(0, 0, 60, buttonHeight);
    [closeButton setTitle:@"Back" forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    closeButton.backgroundColor = [UIColor colorWithRed:0.812 green:0.416 blue:0.349 alpha:1];
    closeButton.layer.borderColor = [UIColor blackColor].CGColor;
    closeButton.layer.borderWidth = 1.0f;
    closeButton.layer.cornerRadius= 7.0f;
    [self.view addSubview:closeButton];
    
    UIButton *helpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    helpButton.frame = CGRectMake(260, 0, 60, buttonHeight);
    [helpButton setTitle:@"Help" forState:UIControlStateNormal];
    [helpButton addTarget:self action:@selector(helpButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    helpButton.backgroundColor = [UIColor colorWithRed:0.812 green:0.416 blue:0.349 alpha:1];
    helpButton.layer.borderColor = [UIColor blackColor].CGColor;
    helpButton.layer.borderWidth = 1.0f;
    helpButton.layer.cornerRadius = 7.0f;
    [self.view addSubview:helpButton];
    
    
    UIButton *filterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    filterButton.frame = CGRectMake(62, 20, 196, 24);
    [filterButton setTitle:@"Filter" forState:UIControlStateNormal];
    [filterButton addTarget:self action:@selector(filterButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    filterButton.backgroundColor = [UIColor colorWithRed:0.812 green:0.416 blue:0.349 alpha:1];
    filterButton.layer.borderColor = [UIColor blackColor].CGColor;
    filterButton.layer.borderWidth = 1.0f;
    filterButton.layer.cornerRadius= 6.0f;
    [self.view addSubview:filterButton];
    
    //Setup the PickerView
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, 320, 200)];
    pickerView.showsSelectionIndicator = YES;
    pickerView.delegate = self;
    [self.view addSubview:pickerView];
    [self.view bringSubviewToFront:tableView];
    
}

#pragma mark tableView Code

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // determine the selected data from the IndexPath.row
    
    NSLog(@"Selected Row: %d" , indexPath.row);
    
    NSLog(@"Issue URL: %@", [[peitionTableViewArray objectAtIndex:indexPath.row] objectForKey:@"url" ]);
    
    NSURL *url = [ [ NSURL alloc ] initWithString:[[peitionTableViewArray objectAtIndex:indexPath.row] objectForKey:@"url"] ];
    
    
    
    webView = [[UIWebView alloc] initWithFrame:self.view.bounds]; 
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    webView.scalesPageToFit = YES;
    webView.delegate  = self;
    [self.view addSubview:webView];
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.frame = CGRectMake(0.0, 0.0, 80.0, 80.0);
    spinner.center = self.view.center;
    [self.view addSubview: spinner];
    [self.view bringSubviewToFront:spinner];
    
    
    browserCloseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    browserCloseButton.frame = CGRectMake(0, 0, 60, buttonHeight);
    [browserCloseButton setTitle:@"Back" forState:UIControlStateNormal];
    [browserCloseButton addTarget:self action:@selector(browserCloseClick:) forControlEvents:UIControlEventTouchUpInside];
    browserCloseButton.backgroundColor = [UIColor colorWithRed:0.812 green:0.416 blue:0.349 alpha:1];
    browserCloseButton.layer.borderColor = [UIColor blackColor].CGColor;
    browserCloseButton.layer.borderWidth = 1.0f;
    browserCloseButton.layer.cornerRadius= 7.0f;
    [self.view addSubview:browserCloseButton];
    
    zoomButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    zoomButton.frame = CGRectMake(260, ([[UIScreen mainScreen] applicationFrame].size.height -buttonHeight), 60, buttonHeight);
    [zoomButton setTitle:@"Zoom" forState:UIControlStateNormal];
    [zoomButton addTarget:self action:@selector(resizeWebView:) forControlEvents:UIControlEventTouchUpInside];
    zoomButton.layer.borderColor = [UIColor blackColor].CGColor;
    zoomButton.backgroundColor = [UIColor colorWithRed:0.812 green:0.416 blue:0.349 alpha:1];
    zoomButton.layer.borderWidth = 1.0f;
    zoomButton.layer.cornerRadius= 7.0f;
    [self.view addSubview:zoomButton];

    
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)searchTableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [peitionTableViewArray count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 100, buttonHeight)];
    
    return sectionHeaderView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.backgroundColor = [UIColor colorWithRed:0.282 green:0.506 blue:0.706 alpha:1];  /*#4881b4*/
    
    // create the title label:                                             x    y   width  height
    UILabel *peitionTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10.0, 280, 120)];
    [peitionTitleLabel setTag:1];
    [peitionTitleLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
    peitionTitleLabel.textAlignment= NSTextAlignmentCenter;
    peitionTitleLabel.textColor = [UIColor whiteColor];
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
    statusLabel.textColor = [UIColor whiteColor];
    statusLabel.layer.borderWidth = 1.0f;
    statusLabel.layer.cornerRadius = 10.0f;
    statusLabel.backgroundColor = [UIColor colorWithRed:0.282 green:0.506 blue:0.706 alpha:1];  /*#4881b4*/
    [cell.contentView addSubview:statusLabel];
    
    //create the remaining signatures label
    UILabel *signaturesCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 160, 180, 20)];
    [signaturesCountLabel setTag:2];
    [signaturesCountLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
    signaturesCountLabel.textAlignment = NSTextAlignmentLeft;
    signaturesCountLabel.textColor = [UIColor whiteColor];
    signaturesCountLabel.layer.borderWidth = 1.0f;
    signaturesCountLabel.layer.cornerRadius = 10.0f;
    signaturesCountLabel.backgroundColor = [UIColor colorWithRed:0.282 green:0.506 blue:0.706 alpha:1];  /*#4881b4*/
    [cell.contentView addSubview:signaturesCountLabel];
    
    //create the time left label
    UILabel *daysLeftLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 180, 180, 20)];
    [daysLeftLabel setTag:3];
    [daysLeftLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
    daysLeftLabel.textAlignment = NSTextAlignmentLeft;
    daysLeftLabel.textColor = [UIColor whiteColor];
    daysLeftLabel.layer.borderWidth = 1.0f;
    daysLeftLabel.layer.cornerRadius = 10.0f;
    daysLeftLabel.backgroundColor = [UIColor colorWithRed:0.282 green:0.506 blue:0.706 alpha:1];  /*#4881b4*/
    [cell.contentView addSubview:daysLeftLabel];
    
    //Create the favorite switch
    UILabel *favoriteSwitchLabel = [[UILabel alloc] initWithFrame:CGRectMake(220, 140, 180, 20)];
    favoriteSwitchLabel.text = @"Favorite";
    favoriteSwitchLabel.font = [UIFont boldSystemFontOfSize:11.0];
    favoriteSwitchLabel.textColor = [UIColor blackColor];
    [cell.contentView addSubview:favoriteSwitchLabel];
    
    UISwitch *favoriteSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(200, 160, 180, 20)];
    favoriteSwitch.tag = indexPath.row;
    [favoriteSwitch addTarget:self action:@selector(updateSwitchAtIndexPath:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:favoriteSwitch];
    
    //display the signatures needed
    NSString *signaturesNeededText = [NSString stringWithFormat:@"Signatures Count: %@", [[peitionTableViewArray objectAtIndex:indexPath.row] objectForKey:@"signature count"] ];
    signaturesCountLabel.text = signaturesNeededText;
    
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
    
    if ( [favoriteIssuesSet containsObject:[[peitionTableViewArray objectAtIndex:indexPath.row] objectForKey:@"id"]]) {
        [favoriteSwitch setOn:YES];
    }
    
    return cell;
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 1.0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200.0;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


#pragma mark IBActions
-(void)updateSwitchAtIndexPath:(UISwitch *)aswitch {
    
    if (aswitch.on) {
        NSLog(@"On");
        [favoriteIssuesSet addObject:[[peitionTableViewArray objectAtIndex:aswitch.tag] objectForKey:@"id"]];
        [favoriteIssuesArray addObject:[[peitionTableViewArray objectAtIndex:aswitch.tag] objectForKey:@"id"]];
        NSLog(@"favorite issues Array Count: %d", [favoriteIssuesArray count]);
        
    }else {
        NSLog(@"Off");
        
        [favoriteIssuesSet removeObject:[[peitionTableViewArray objectAtIndex:aswitch.tag] objectForKey:@"id"]];
        [favoriteIssuesArray removeAllObjects];
        [favoriteIssuesArray addObjectsFromArray:[favoriteIssuesSet allObjects]];
        
    }
    //TODO Block this
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *favoriteIssuePath = [documentsDirectory stringByAppendingPathComponent:@"favorite.dat"];
    NSLog(@"favsize:%d", [favoriteIssuesArray count]);
    
    [NSKeyedArchiver archiveRootObject:favoriteIssuesArray toFile:favoriteIssuePath];
    
    NSMutableArray *returnedMutableArray = [[NSMutableArray alloc] init];
    returnedMutableArray = [NSKeyedUnarchiver unarchiveObjectWithFile:favoriteIssuePath];
    
}

-(IBAction)filterButtonTouched:(id)sender {
    NSLog(@"Filter Button Touched");
    
    
    if (tableView.frame.origin.y == 44.0f) { //Tableview is at top of screen.
        //slide the tableview down.
        [UIView animateWithDuration:0.5
                         animations:^{
                             tableView.frame = CGRectMake(0,200, 320, 504);
                         }
                         completion:nil];
        for (int i=0; i<[unfilteredPeitionTableViewArray count]; i++) {
            //NSArray *issues = [[NSArray alloc] initWithArray:[[unfilteredPeitionTableViewArray objectAtIndex:i] objectForKey:@"issues"];
            
            NSDictionary *issuesDic = [[[unfilteredPeitionTableViewArray objectAtIndex:i] objectForKey:@"issues"] objectAtIndex:0];
            [issuesArray addObject:issuesDic];
            
            
            
        }
    } else {        //Slide the tableview up
        [UIView animateWithDuration:0.5
                         animations:^{
                             //([[UIScreen mainScreen] applicationFrame].size.height -44) takes care of bug with screen size on all devices.
                             tableView.frame = CGRectMake(0,44, 320, ([[UIScreen mainScreen] applicationFrame].size.height -buttonHeight));                         }
                         completion:nil];
    }
}

-(IBAction)helpButtonTouched:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Not Implemented Yet" message:nil delegate:nil
                          cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];}

#pragma mark WebView Code 

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [spinner startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [spinner stopAnimating];
    [spinner removeFromSuperview];
}

-(IBAction)resizeWebView:(id)sender {
    NSLog(@"resizeWebView");
    NSString *jsCommand = [NSString stringWithFormat:@"document.body.style.zoom = .5;"];
    [webView stringByEvaluatingJavaScriptFromString:jsCommand];
}
-(IBAction)browserCloseClick:(id)sender {
    [zoomButton removeFromSuperview];
    [browserCloseButton removeFromSuperview];
    [webView removeFromSuperview];
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
