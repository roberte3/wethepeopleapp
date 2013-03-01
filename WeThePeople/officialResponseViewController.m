//
//  officialResponseViewController.m
//  WeThePeople
//
//  Created by Robert Eickmann on 2/22/13.
//  Copyright (c) 2013 devnull. All rights reserved.
//

#import "officialResponseViewController.h"
#import <QuartzCore/QuartzCore.h> 

@interface officialResponseViewController ()


@end

@implementation officialResponseViewController
@synthesize tableView;


NSMutableArray *peitionTableViewArray;
NSMutableArray *unfilteredPeitionTableViewArray;
NSMutableArray *issuesArray;
NSMutableArray *pickerViewArray;

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
    
// Handle the selection
//    NSArray *issues = [[NSArray alloc] initWithArray:[[peitionTableViewArray objectAtIndex:indexPath.row] objectForKey:@"issues"]];
//    for (int j =0;  j<[issues count]; j++) {
//        NSLog(@"%@", [[issues objectAtIndex:j] objectForKey:@"name"]);
//    }
    
    
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


#pragma mark tableView Code

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // determine the selected data from the IndexPath.row
    
    NSLog(@"Selected Row: %d" , indexPath.row);
    
    NSLog(@"Issue URL: %@", [[peitionTableViewArray objectAtIndex:indexPath.row] objectForKey:@"url" ]);

    NSURL *url = [ [ NSURL alloc ] initWithString:[[peitionTableViewArray objectAtIndex:indexPath.row] objectForKey:@"url"] ];
    [[UIApplication sharedApplication] openURL:url];
    WebViewController *viewController = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];

}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)searchTableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [peitionTableViewArray count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 100, 44)];
    
    return sectionHeaderView;
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
    
    NSArray *issues = [[NSArray alloc] initWithArray:[[peitionTableViewArray objectAtIndex:indexPath.row] objectForKey:@"issues"]];
    for (int j =0;  j<[issues count]; j++) {
        NSLog(@"%@", [[issues objectAtIndex:j] objectForKey:@"name"]);
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

-(void)viewWillAppear:(BOOL)animated {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *arrayPath = [documentsDirectory stringByAppendingPathComponent:@"example.dat"];
    
    NSMutableArray *issueSorter = [[NSMutableArray alloc] init]; 
    issueSorter = [NSKeyedUnarchiver unarchiveObjectWithFile:arrayPath];

    for (int i = 0; i<[issueSorter count]; i++ ) {
        if ([[[issueSorter objectAtIndex:i] objectForKey:@"status"] isEqual: @"responded"]) {
            [unfilteredPeitionTableViewArray addObject:[issueSorter objectAtIndex:i]]; 
            [peitionTableViewArray addObject:[issueSorter objectAtIndex:i]];
        }
    }

}
-(void)viewDidAppear:(BOOL)animated {
    int searchBarHeight = 40; 
        [super viewDidAppear:animated];
        tableView.contentOffset = CGPointMake(0, searchBarHeight);
    
    

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //[webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.URLToLoad]]];


    peitionTableViewArray = [[NSMutableArray alloc] init];
    issuesArray = [[NSMutableArray alloc] init]; 
    unfilteredPeitionTableViewArray = [[NSMutableArray alloc] init]; 
    pickerViewArray = [[NSMutableArray alloc] init];
    
    //Create pickerView array;
    [pickerViewArray addObject:@"Agriculture"];
    [pickerViewArray addObject:@"Arts and Humanities"];
    [pickerViewArray addObject:@"Budget and Taxes"];
    [pickerViewArray addObject:@"Civil Rights and Liberties"];
    [pickerViewArray addObject:@"Climate Change"];
    [pickerViewArray addObject:@"Consumer Protections"];
    [pickerViewArray addObject:@"Criminal Justice and Law Enforcement"];
    [pickerViewArray addObject:@"Defense"];
    [pickerViewArray addObject:@"Disabilities"];
    [pickerViewArray addObject:@"Economy"];
    [pickerViewArray addObject:@"Education"];
    [pickerViewArray addObject:@"Energy"];
    [pickerViewArray addObject:@"Environment"];
    [pickerViewArray addObject:@"Family"];
    [pickerViewArray addObject:@"Firearms"];
    [pickerViewArray addObject:@"Foreign Policy"];
    [pickerViewArray addObject:@"Government Reform"];
    [pickerViewArray addObject:@"Health Care"];
    [pickerViewArray addObject:@"Homeland Security and Disaster Relief"];
    [pickerViewArray addObject:@"Housing"];
    [pickerViewArray addObject:@"Human Rights"];
    [pickerViewArray addObject:@"Immigration"];
    [pickerViewArray addObject:@"Innovation"];
    [pickerViewArray addObject:@"Job Creation"];
    [pickerViewArray addObject:@"Labor"];
    [pickerViewArray addObject:@"Natural Resources"];
    [pickerViewArray addObject:@"Postal Service"];
    [pickerViewArray addObject:@"Poverty"];
    [pickerViewArray addObject:@"Regulatory Reform"];
    [pickerViewArray addObject:@"Rural Policy"];
    [pickerViewArray addObject:@"Science and Space Policy"];
    [pickerViewArray addObject:@"Small Business"];
    [pickerViewArray addObject:@"Social Security"];
    [pickerViewArray addObject:@"Technology and Telecommunications"];
    [pickerViewArray addObject:@"Trade"];
    [pickerViewArray addObject:@"Transportation and Infrastructure"];
    [pickerViewArray addObject:@"Urban Policy"];
    [pickerViewArray addObject:@"Veterans and Military Families"]; 
    [pickerViewArray addObject:@"Women's Issues"];
    
    NSLog(@"pickerViewArray %d", [pickerViewArray count]); 
       
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(0, 0, 60, 22);
    [closeButton setTitle:@"Back" forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    closeButton.backgroundColor = [UIColor colorWithRed:0.812 green:0.416 blue:0.349 alpha:1];
    closeButton.layer.borderColor = [UIColor blackColor].CGColor;
    closeButton.layer.borderWidth = 1.0f;
    closeButton.layer.cornerRadius= 10.0f;
    [self.view addSubview:closeButton];
    
    UIButton *helpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    helpButton.frame = CGRectMake(260, 0, 60, 22);
    [helpButton setTitle:@"Help" forState:UIControlStateNormal];
    [helpButton addTarget:self action:@selector(helpButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    helpButton.backgroundColor = [UIColor colorWithRed:0.812 green:0.416 blue:0.349 alpha:1];
    helpButton.layer.borderColor = [UIColor blackColor].CGColor;
    helpButton.layer.borderWidth = 1.0f; 
    helpButton.layer.cornerRadius = 10.0f;
    [self.view addSubview:helpButton]; 
    
    
    UIButton *filterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    filterButton.frame = CGRectMake(60, 20, 200, 22);
    [filterButton setTitle:@"Filter" forState:UIControlStateNormal];
    [filterButton addTarget:self action:@selector(filterButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    filterButton.backgroundColor = [UIColor colorWithRed:0.812 green:0.416 blue:0.349 alpha:1];
    filterButton.layer.borderColor = [UIColor blackColor].CGColor;
    filterButton.layer.borderWidth = 1.0f;
    filterButton.layer.cornerRadius= 10.0f;
    [self.view addSubview:filterButton];
    

    //Setup the Search Bar
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    searchBar.barStyle=UIBarStyleBlackTranslucent;
    searchBar.showsCancelButton=YES;
    searchBar.autocorrectionType=UITextAutocorrectionTypeNo;
    searchBar.autocapitalizationType=UITextAutocapitalizationTypeNone;
    searchBar.delegate=self;
    self.tableView.tableHeaderView=searchBar;
    
    //Setup the PickerView 
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, 320, 200)];
    pickerView.showsSelectionIndicator = YES;
    pickerView.delegate = self;
    [self.view addSubview:pickerView];
    [self.view bringSubviewToFront:tableView]; 
    

}


#pragma mark IBActions 

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
                             tableView.frame = CGRectMake(0,44, 320, 504);
                         }
                         completion:nil];
    }
}

-(IBAction)helpButtonTouched:(id)sender {
    NSLog(@"Help Button Clicked"); 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end