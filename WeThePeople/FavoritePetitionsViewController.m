//
//  FavoritePetitionsViewController.m
//  WeThePeople
//
//  Created by Robert Eickmann on 3/13/13.
//  Copyright (c) 2013 devnull. All rights reserved.
//

#import "FavoritePetitionsViewController.h"
#import <QuartzCore/QuartzCore.h> 

@interface FavoritePetitionsViewController ()

@end

@implementation FavoritePetitionsViewController
@synthesize tableView;

UIWebView *webView;
UIButton *browserCloseButton;
UIButton *zoomButton;
UIActivityIndicatorView *spinner;

NSMutableArray *peitionTableViewArray;
NSMutableSet *favoriteIssuesSet;
NSMutableArray *favoriteIssuesArray; 

-(void)viewWillAppear:(BOOL)animated {
    favoriteIssuesArray = [[NSMutableArray alloc] init];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *arrayPath = [documentsDirectory stringByAppendingPathComponent:@"peitions.dat"];
    NSString *favoriteIssuePath = [documentsDirectory stringByAppendingPathComponent:@"favorite.dat"];
    
    //get built list of fav issues from file.
    favoriteIssuesSet = [[NSMutableSet alloc] initWithArray:[NSKeyedUnarchiver unarchiveObjectWithFile:favoriteIssuePath]];
    
    NSMutableArray *issueSorter = [[NSMutableArray alloc] init];
    issueSorter = [NSKeyedUnarchiver unarchiveObjectWithFile:arrayPath];
    
    NSMutableArray *tmpArray = [[NSMutableArray alloc] init]; 
    for(int i=0; i<[issueSorter count]; i++ ){
        if ([favoriteIssuesSet containsObject:[[issueSorter objectAtIndex:i] objectForKey:@"id"]]) {
            [tmpArray addObject:[issueSorter objectAtIndex:i]];
        }
    }
    //Clear the issueSorter and replace its contents with the favorited items.
    [issueSorter removeAllObjects];
    [issueSorter addObjectsFromArray:tmpArray];
    
    
    NSMutableArray *openPeitionsArray = [[NSMutableArray alloc] init];
    NSMutableArray *respondedPeitionsArray = [[NSMutableArray alloc] init];
    NSMutableArray *peitionsAwaitingResponseArray = [[NSMutableArray alloc] init]; 
    
    for (int i = 0; i<[issueSorter count]; i++ ) {
        if ([[[issueSorter objectAtIndex:i] objectForKey:@"status"] isEqual: @"open"] && [[[issueSorter objectAtIndex:i] objectForKey:@"signatures needed"] integerValue] >0 ) {
            [openPeitionsArray addObject:[issueSorter objectAtIndex:i]];
            
        } else if ([[[issueSorter objectAtIndex:i] objectForKey:@"status"] isEqual: @"responded"]){
            [respondedPeitionsArray addObject:[issueSorter objectAtIndex:i]];
        } else if  ([[[issueSorter objectAtIndex:i] objectForKey:@"status"] isEqual: @"pending response"] && [[[issueSorter objectAtIndex:i] objectForKey:@"signatures needed"] integerValue] ==0 ){
            [peitionsAwaitingResponseArray  addObject:[issueSorter objectAtIndex:i]]; 
        }
        
        else {
            NSLog(@"Other:Shouldn't Happen");
        }
    }

[peitionTableViewArray addObject:respondedPeitionsArray];
[peitionTableViewArray addObject:peitionsAwaitingResponseArray];
[peitionTableViewArray addObject:openPeitionsArray]; 

}

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
    peitionTableViewArray = [[NSMutableArray alloc] init];
    self.view.backgroundColor = [UIColor colorWithRed:0.031 green:0.157 blue:0.349 alpha:1]; /*#082859*/
    self.tableView.separatorColor = [UIColor blackColor]; //[UIColor colorWithRed:0.031 green:0.157 blue:0.349 alpha:1];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(0, 0, 60, buttonHeight);
    [closeButton setTitle:@"close" forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    //closeButton.backgroundColor = [UIColor colorWithRed:0.024 green:0.098 blue:0.235 alpha:1];
    closeButton.layer.borderWidth = 1.0f;
    //    closeButton.layer.cornerRadius= 7.0f;
    [self.view addSubview:closeButton];
//    self.tableView.layer.zPosition = 1;
    
//    UIButton *notificationSettings = [UIButton buttonWithType:UIButtonTypeCustom];
//    notificationSettings.frame = CGRectMake(260, 0, 60, buttonHeight);
//    UIImage *gearImageView =[UIImage imageNamed:@"gear.png"];
//    [notificationSettings setBackgroundImage:gearImageView forState:UIControlStateNormal];
//    [notificationSettings addTarget:self action:@selector(notificationSettingsButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
//    notificationSettings.backgroundColor = [UIColor colorWithRed:0.812 green:0.416 blue:0.349 alpha:1];
//    notificationSettings.layer.borderColor = [UIColor blackColor].CGColor;
//    notificationSettings.layer.borderWidth = 1.0f;
//    notificationSettings.layer.cornerRadius = 7.0f;
//    [self.view addSubview:notificationSettings];
    
    // Do any additional setup after loading the view from its nib.
}

-(IBAction)notificationSettingsButtonTouch:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Push notifications are not implemented in the source code release" message:nil delegate:nil
                          cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // determine the selected data from the IndexPath.row
    
    //NSLog(@"Issue URL: %@", [[[peitionTableViewArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"url" ]);
    
    NSURL *url = [ [ NSURL alloc ] initWithString:[[[peitionTableViewArray objectAtIndex: indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"url"]];
    
    webView = [[UIWebView alloc] initWithFrame:self.view.bounds];  //Change self.view.bounds to a smaller CGRect if you don't want it to take up the whole screen
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    webView.scalesPageToFit = YES;
    webView.delegate  = self;
    //webView.layer.zPosition = 1;
    [self.view addSubview:webView];
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.frame = CGRectMake(0.0, 0.0, 80.0, 80.0);
    spinner.center = self.view.center;
    [self.view addSubview: spinner];
    [self.view bringSubviewToFront:spinner];
    spinner.layer.zPosition = 10;
    
    
    browserCloseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    browserCloseButton.frame = CGRectMake(0, 0, 60, buttonHeight);
    [browserCloseButton setTitle:@"close" forState:UIControlStateNormal];
    [browserCloseButton addTarget:self action:@selector(browserCloseClick:) forControlEvents:UIControlEventTouchUpInside];
    browserCloseButton.backgroundColor = [UIColor colorWithRed:0.031 green:0.157 blue:0.349 alpha:1];
    browserCloseButton.layer.borderColor = [UIColor blackColor].CGColor;
    browserCloseButton.layer.borderWidth = 1.0f;
    browserCloseButton.layer.cornerRadius= 7.0f;
    browserCloseButton.titleLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:browserCloseButton]; 
    [self.view bringSubviewToFront:browserCloseButton]; 
    
    zoomButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    zoomButton.frame = CGRectMake(260, ([[UIScreen mainScreen] applicationFrame].size.height -buttonHeight), 60, buttonHeight);
    [zoomButton setTitle:@"Zoom" forState:UIControlStateNormal];
    [zoomButton addTarget:self action:@selector(resizeWebView:) forControlEvents:UIControlEventTouchUpInside];
    zoomButton.layer.borderColor = [UIColor blackColor].CGColor;
    zoomButton.backgroundColor = [UIColor colorWithRed:0.812 green:0.416 blue:0.349 alpha:1];
    zoomButton.layer.borderWidth = 1.0f;
    zoomButton.layer.cornerRadius= 7.0f;
    [self.view addSubview:zoomButton];
    [self.view bringSubviewToFront:zoomButton]; 
    
    
}
-(IBAction)browserCloseClick:(id)sender {
    [zoomButton removeFromSuperview];
    [browserCloseButton removeFromSuperview];
    [webView removeFromSuperview];
    
}

-(IBAction)resizeWebView:(id)sender {
    NSLog(@"resizeWebView");
    NSString *jsCommand = [NSString stringWithFormat:@"document.body.style.zoom = .5;"];
    [webView stringByEvaluatingJavaScriptFromString:jsCommand];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[peitionTableViewArray objectAtIndex:section] count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 22)];
    UILabel *sectionHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 22)];
    sectionHeaderLabel.textColor = [UIColor whiteColor]; 
    if (section == 0) {
        sectionHeaderLabel.text = [NSString stringWithFormat:@"Responded petitions"];
    }else if (section == 1) {
        sectionHeaderLabel.text = [NSString stringWithFormat:@"Petitions awaiting response"];
    }else if (section == 2) {
        sectionHeaderLabel.text = [NSString stringWithFormat:@"Open petitions"];

    }
     [sectionHeaderView addSubview:sectionHeaderLabel];
    sectionHeaderLabel.backgroundColor = [UIColor redColor];
    return sectionHeaderView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
  [cell setBackgroundColor: [UIColor colorWithRed:0.282 green:0.506 blue:0.706 alpha:1]];
    
    
    //[[[[peitionTableViewArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"deadline"] doubleValue]]
    
    float threshold = [[[[peitionTableViewArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"signature threshold"]floatValue];
    float signatures = [[[[peitionTableViewArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"signature count"] floatValue];
    NSNumber *thresholdNumber = [NSNumber numberWithFloat:threshold];
    NSNumber *signatureNumber = [NSNumber numberWithFloat:signatures];
    NSNumberFormatter *formmatter = [[NSNumberFormatter alloc] init];
    [formmatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *thresholdString = [formmatter stringFromNumber:thresholdNumber];
    NSString *signatureString = [formmatter stringFromNumber:signatureNumber];
    
    
    UIImageView *discloseNavView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"disclosureNav.png"]];
    discloseNavView.frame = CGRectMake(260, 50, 50, 87);
    [cell.contentView addSubview:discloseNavView];
    
    
    // create the title label:                                             x    y   width  height
    // create the title label:                                             x    y   width  height
    UILabel *peitionTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 280, 120)];
    [peitionTitleLabel setTag:1];
    [peitionTitleLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
    peitionTitleLabel.textAlignment= NSTextAlignmentLeft;
    peitionTitleLabel.textColor = [UIColor whiteColor];
    peitionTitleLabel.numberOfLines = 5;
    peitionTitleLabel.backgroundColor = [UIColor colorWithRed:0.024 green:0.098 blue:0.235 alpha:1];  /*#4881b4*/

    
    // custom views should be added as subviews of the cell's contentView:
   [cell.contentView addSubview:peitionTitleLabel];
    
    UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, 0, 280, 20)];
    [statusLabel setTag:4];
    [statusLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
    statusLabel.textAlignment = NSTextAlignmentLeft;
    statusLabel.textColor = [UIColor whiteColor];
    statusLabel.backgroundColor = [UIColor colorWithRed:0.024 green:0.098 blue:0.235 alpha:1];
    //[cell.contentView addSubview:statusLabel];

    //create the remaining signatures label
    UILabel *signaturesCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 160, 180, 20)];
    [signaturesCountLabel setTag:2];
    [signaturesCountLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
    signaturesCountLabel.textAlignment = NSTextAlignmentLeft;
    signaturesCountLabel.textColor = [UIColor whiteColor];
    signaturesCountLabel.backgroundColor =[UIColor colorWithRed:0.024 green:0.098 blue:0.235 alpha:1];
    [cell.contentView addSubview:signaturesCountLabel];
  
    //create the time left label
    NSLocale *locale = [NSLocale currentLocale];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSString *dateFormat = [NSDateFormatter dateFormatFromTemplate:@"E MMM d" options:0 locale:locale];
    [formatter setDateFormat:dateFormat];
    [formatter setLocale:locale];
    //NSLog(@"Formatted date: %@", [formatter stringFromDate:myDate]);
    
    UILabel *daysLeftLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 140, 200, 20)];
    [daysLeftLabel setTag:3];
    [daysLeftLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
    daysLeftLabel.textAlignment = NSTextAlignmentLeft;
    daysLeftLabel.backgroundColor = [UIColor colorWithRed:0.024 green:0.098 blue:0.235 alpha:1];
    daysLeftLabel.textColor = [UIColor whiteColor];
    
    UIProgressView *progressBar = [[UIProgressView alloc] initWithFrame:CGRectMake(10, 180, 180, 30)];
    progressBar.progressViewStyle = UIProgressViewStyleDefault;
    //NSLog(@"%f", threshold/signatures);
    [progressBar setProgress:signatures/threshold];
    [cell.contentView addSubview:progressBar]; 
    
//
//    //Create the favorite switch
//    UILabel *favoriteSwitchLabel = [[UILabel alloc] initWithFrame:CGRectMake(220, 140, 180, 20)];
//    favoriteSwitchLabel.text = @"Favorite";
//    favoriteSwitchLabel.font = [UIFont boldSystemFontOfSize:11.0];
//    favoriteSwitchLabel.textColor = [UIColor blackColor];
//    [cell.contentView addSubview:favoriteSwitchLabel];
//    
//    UISwitch *favoriteSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(200, 160, 180, 20)];
//    favoriteSwitch.tag = indexPath.row;
//    [favoriteSwitch addTarget:self action:@selector(updateSwitchAtIndexPath:) forControlEvents:UIControlEventTouchUpInside];
//    [cell.contentView addSubview:favoriteSwitch];

    //display the signatures needed
    NSString *signaturesNeededText = [NSString stringWithFormat:@"%@ of %@ Signatures", signatureString, thresholdString];
    signaturesCountLabel.text = signaturesNeededText;
    
    //NSString *signaturesNeededText = [NSString stringWithFormat:@"Signatures Count: %@", [[[peitionTableViewArray objectAtIndex: indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"signature count"] ];
    signaturesCountLabel.text = signaturesNeededText;
    
    //display the peition title
    peitionTitleLabel.text = [[[peitionTableViewArray objectAtIndex:indexPath.section ] objectAtIndex:indexPath.row] objectForKey:@"title"];
    
    //display the status
    statusLabel.text = [NSString stringWithFormat:@"Status: %@", [[[peitionTableViewArray  objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"status"]];
    
    //display the days left
    //We get the Unix timeStamp for @"deadline" and convert it into a displayable string in the tableview.
    //Apple often gets their date math wrong, hopefully this is all correct and works...
    NSDate *lastDayDate = [NSDate dateWithTimeIntervalSince1970:[[[[peitionTableViewArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"deadline"] doubleValue]];
    NSDate *now = [NSDate date];
    NSTimeInterval diff = [lastDayDate  timeIntervalSinceDate:now];
    int numberOfDays = diff / 86400;
    daysLeftLabel.text = [NSString stringWithFormat:@"Day petition closes: %@",  [formatter stringFromDate:lastDayDate]];
    [cell.contentView addSubview:daysLeftLabel];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
//    NSArray *issues = [[NSArray alloc] initWithArray:[[peitionTableViewArray objectAtIndex:indexPath.row] objectForKey:@"issues"]];
//    for (int j =0;  j<[issues count]; j++) {
//        // NSLog(@"Cell Issues: %@", [[issues objectAtIndex:j] objectForKey:@"name"]);
//    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell.backgroundColor = [UIColor colorWithRed:0.024 green:0.098 blue:0.235 alpha:1];
    
}


-(void)updateSwitchAtIndexPath:(UISwitch *)aswitch {
      //  NSLog(@"Row %i", aswitch.tag);
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 1.0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200.0;
}


@end
