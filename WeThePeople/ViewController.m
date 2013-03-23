//
//  ViewController.m
//  WeThePeople
//
//  Created by Robert Eickmann on 2/22/13.
//  Copyright (c) 2013 devnull. All rights reserved.
//

#import "ViewController.h"
#import "officialResponseViewController.h" 
#import "openPeitionsViewController.h" 
#import "awaitingResponseViewController.h" 
#import "FavoritePetitionsViewController.h" 

@interface ViewController ()

@end

@implementation ViewController
@synthesize openPeitionsButton;
@synthesize officialResponseButton; 
@synthesize awaitingResponseButton;
@synthesize favoritePeitionsButton;
@synthesize retryInternetButton; 

int currentPeitionsDownloadIncrementer = 0;
int secondaryDownloadCount = 0;
bool canAdvanceToNextScreen = FALSE;
bool failedConnection = FALSE;
NSMutableArray *allPeitions;
NSMutableArray *favoritePeitions; 

UIActivityIndicatorView *spinner; 


NSMutableData *responseData;



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.282 green:0.506 blue:0.706 alpha:1]; /*#4881b4* aka the color from the official WH app. */

    allPeitions = [[NSMutableArray alloc] init];
    favoritePeitions = [[NSMutableArray alloc] init];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *favoriteIssuePath = [documentsDirectory stringByAppendingString:@"favorite.dat"];
    favoritePeitions = [NSKeyedUnarchiver unarchiveObjectWithFile:favoriteIssuePath];

    responseData = [NSMutableData data]; //Download temp cache.
    
    
    spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinner.frame = CGRectMake(0, 0, 80.0, 80.0);
    spinner.center = CGPointMake(160, 120);
    [self.view addSubview: spinner];
    [self.view bringSubviewToFront:spinner];
    [spinner startAnimating]; 
    
    [self initialPetitionsDownload:self];
    //[self secondaryPetitionsDownload:self];

	// Do any additional setup after loading the view, typically from a nib.
}

-(IBAction)officialResponseTouch:(id)sender {
    NSLog(@"officialResponseTouch");
    if (canAdvanceToNextScreen) {
        officialResponseViewController *controller = [[officialResponseViewController alloc] initWithNibName:@"officialResponseViewController" bundle:nil];
            [self presentViewController:controller animated:YES completion:nil];
    
    } else {
        NSLog(@"No"); 
    }
}

-(IBAction)openPeitionsTouch:(id)sender {
    NSLog(@"openPeitionsTouch");
    if (canAdvanceToNextScreen) {
        openPeitionsViewController *controller = [[openPeitionsViewController alloc] initWithNibName:@"openPeitionsViewController" bundle:nil];
        [self presentViewController:controller animated:YES completion:nil];

        
    } else {
        NSLog(@"No");
    }
}

-(IBAction)favoritePeitionsTouch:(id)sender {
    NSLog(@"favoritePeitionsTouch");

    if (canAdvanceToNextScreen && [favoritePeitions count] > 0) {
        FavoritePetitionsViewController *controller = [[FavoritePetitionsViewController alloc] initWithNibName:@"FavoritePetitionsViewController" bundle:nil];
        [self presentViewController:controller animated:YES completion:nil];
        
        
    } else {
        NSLog(@"No");
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Favorite a peition to get notifications, and view this screen. " message:nil delegate:nil
                              cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
    
    
}

-(IBAction)awaitingResponseTouch:(id)sender {
    NSLog(@"awitingReponseTouch");
    if (canAdvanceToNextScreen) {
        awaitingResponseViewController *controller = [[awaitingResponseViewController alloc] initWithNibName:@"awaitingResponseViewController" bundle:nil];
        [self presentViewController:controller animated:YES completion:nil];
        
    } else {
        NSLog(@"No");

    }
}


#pragma mark downloadPeitions
-(IBAction)initialPetitionsDownload:(id)sender {
    NSLog(@"Download petitions");
    
    NSString *petitionsString = [[PETITIONS_URL stringByAppendingString:ACCESS_CODE] stringByAppendingString:@"&limit=1000&offset=0;"];
    //NSString *petitionsString = [PETITIONS_URL stringByAppendingString:ACCESS_CODE];
    
    currentPeitionsDownloadIncrementer = 1000; //set global variable for downloading more peititions.
    NSURL *download_url = [NSURL URLWithString:petitionsString];
    NSLog(@"downloadURL:%@", download_url);
    NSURLRequest *request = [NSURLRequest requestWithURL:download_url];
    NSLog(@"Starting Request:");
    [NSURLConnection connectionWithRequest:request delegate:self];
    

    

}

//-(IBAction)secondaryPetitionsDownload:(id)sender {
//    secondaryDownloadCount +1; 
//    NSLog(@"Secondary PetitionsDownload");
//    NSString *currentOffsetString = [[NSNumber numberWithInt:currentPeitionsDownloadIncrementer] stringValue];
//    NSString *petitionsString = [[[PETITIONS_URL stringByAppendingString:ACCESS_CODE] stringByAppendingString:@"&limit=100o&offset="]stringByAppendingString:currentOffsetString];
//    NSURL *download_url = [NSURL URLWithString:petitionsString];
//    NSURLRequest *request = [NSURLRequest requestWithURL:download_url];
//    [[NSURLConnection alloc] initWithRequest:request delegate:self];
//    
//}

#pragma mark NSURLConnection results code

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [responseData setLength:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData appendData:data];
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [spinner stopAnimating]; 
    NSLog(@"Connection Failure: %@", [error description]);
    
    NSLog(@"error: %@", error);
    
    if (error.code == -1009) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Announcement"
                              message: @"No Internet Connection, please check your device for a working internet connection"
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];    } else {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @"Announcement"
                                  message: [NSString stringWithFormat:@"%d, %@", error.code,  error.localizedDescription ]//error.domain,
                                  delegate: nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        }


    retryInternetButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    retryInternetButton.frame = CGRectMake(116, 200, 88, 88);
    [retryInternetButton setTitle:@"retry" forState:UIControlStateNormal];
    [retryInternetButton addTarget:self action:@selector(retryInternetButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    retryInternetButton.backgroundColor = [UIColor colorWithRed:0.812 green:0.416 blue:0.349 alpha:1];
    retryInternetButton.layer.borderColor = [UIColor blackColor].CGColor;
    retryInternetButton.layer.borderWidth = 1.0f;
    retryInternetButton.layer.cornerRadius= 7.0f;
    [self.view addSubview:retryInternetButton];
    
    [officialResponseButton setHidden:YES];
    [openPeitionsButton setHidden:YES];
    [awaitingResponseButton setHidden:YES];
    [favoritePeitionsButton setHidden:YES]; 
}

-(IBAction)retryInternetButtonTouch:(id)sender {
    [self initialPetitionsDownload:self];
    [retryInternetButton setHidden:YES];
    [officialResponseButton setHidden:NO];
    [openPeitionsButton setHidden:NO];
    [awaitingResponseButton setHidden:NO];
    [favoritePeitionsButton setHidden:NO]; 
}



-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
//This needs to be setup for Secondary Downloads but that will happen when the current api fix is put into place.
    
        NSArray *peititionListingResultsArray = [[NSArray alloc] init];
    
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSString *response = responseString;
//NSLog(@"ResponseString: %@", responseString);
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSDictionary *peitionsDict = [parser objectWithString:response]; 
        peititionListingResultsArray =  [peitionsDict objectForKey:@"results"];
    
        
        for (int i = 0; i<[peititionListingResultsArray count]; i++) {
            NSLog(@"<> %@", [peititionListingResultsArray objectAtIndex:i]); 
            NSLog(@"Signatures Needed:%@", [[peititionListingResultsArray objectAtIndex:i] objectForKey:@"signatures needed"]);
         
        }
    [allPeitions addObjectsFromArray:peititionListingResultsArray];
    
    NSLog(@"%@", [allPeitions objectAtIndex:4]);
    
    NSLog(@"total records downloaded: %d", [allPeitions count]);
    
    //Write the array to Disk
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *arrayPath = [documentsDirectory stringByAppendingPathComponent:@"peitions.dat"];

    [NSKeyedArchiver archiveRootObject:peititionListingResultsArray toFile:arrayPath];
    canAdvanceToNextScreen = YES;
    [spinner stopAnimating];
    
    
//    if (signaturesURLReqest) {
//        NSArray *signaturesArray = [[NSArray alloc] init];
//        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
//        //NSLog(@"responseString: %@", responseString);
//        NSString *response = responseString;
//        SBJsonParser *parser = [[SBJsonParser alloc] init];
//        NSDictionary *signaturesDict = [parser objectWithString:response error:nil];
//        
//        signaturesResultsArray = [signaturesDict objectForKey:@"results"];
//        //NSLog(@"dict: %@",  signaturesResultsArray);
//        NSLog(@"Number of records to download %@", [[[signaturesDict objectForKey:@"metadata"] objectForKey:@"resultset"]objectForKey:@"count"]);
//        
//        signaturesArray = [signaturesDict objectForKey:@"results"];
//        
//        if ([[[[signaturesDict objectForKey:@"metadata"] objectForKey:@"resultset"]objectForKey:@"count"] integerValue] > 1000) {
//            NSLog(@"More than a thousandRecords");
//            //[[[[signaturesDict objectForKey:@"metadata"] objectForKey:@"resultset"]objectForKey:@"count"] integerValue]-1000;
//            
//        }else {
//            NSLog(@"Less than a thousandRecords");
//            
//        }
//        
    
    
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
