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

@interface ViewController ()

@end

@implementation ViewController
@synthesize openPeitionsButton;
@synthesize officialResponseButton; 
@synthesize awaitingResponseButton;

int currentPeitionsDownloadIncrementer = 0;
int secondaryDownloadCount = 0;
bool canAdvanceToNextScreen = FALSE;
NSMutableArray *allPeitions;


NSMutableData *responseData; 

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.282 green:0.506 blue:0.706 alpha:1]; /*#4881b4* aka the color from the official WH app. */

    allPeitions = [[NSMutableArray alloc] init]; 
    responseData = [NSMutableData data]; //Download temp cache.
    [self initialPetitionsDownload:self];
    //[self secondaryPetitionsDownload:self];

	// Do any additional setup after loading the view, typically from a nib.
}

-(IBAction)officialResponseTouch:(id)sender {
    NSLog(@"officialResponseTouch");
    if (canAdvanceToNextScreen) {
        officialResponseViewController *controller = [[officialResponseViewController alloc] initWithNibName:@"officialResponseViewController" bundle:nil];
            [self presentModalViewController:controller animated:YES]; 
    
    } else {
        NSLog(@"No"); 
    }
}

-(IBAction)openPeitionsTouch:(id)sender {
    NSLog(@"openPeitionsTouch");
    if (canAdvanceToNextScreen) {
        openPeitionsViewController *controller = [[openPeitionsViewController alloc] initWithNibName:@"openPeitionsViewController" bundle:nil];
        [self presentModalViewController:controller animated:YES];
        
    } else {
        NSLog(@"No");
    }
}

-(IBAction)awaitingResponseTouch:(id)sender {
    NSLog(@"awitingReponseTouch");
    if (canAdvanceToNextScreen) {
        openPeitionsViewController *controller = [[openPeitionsViewController alloc] initWithNibName:@"openPeitionsViewController" bundle:nil];
        [self presentModalViewController:controller animated:YES];
        
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
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
    NSLog(@"Request finished:");

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
    NSLog(@"Connection Failure: %@", [error description]);
    
    NSLog(@"error: %@", error);
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @"Announcement"
                          message: [NSString stringWithFormat:@"%d, %@", error.code, error.domain ]
                          delegate: nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
    
}



-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
//This needs to be setup for Secondary Downloads but that will happen when the current api fix is put into place.
    
        NSArray *peititionListingResultsArray = [[NSArray alloc] init];
    
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSString *response = responseString;
//NSLog(@"%@", responseString);
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSDictionary *peitionsDict = [parser objectWithString:response]; 
        peititionListingResultsArray =  [peitionsDict objectForKey:@"results"];
    
        
        for (int i = 0; i<[peititionListingResultsArray count]; i++) {
            NSLog(@"Signatures Needed:%@", [[peititionListingResultsArray objectAtIndex:i] objectForKey:@"signatures needed"]);
         
        }
    [allPeitions addObjectsFromArray:peititionListingResultsArray];
    
    NSLog(@"%@", [allPeitions objectAtIndex:4]);
    
    NSLog(@"total records downloaded: %d", [allPeitions count]);
    
    //Write the array to Disk
    NSError *error; 
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *arrayPath = [documentsDirectory stringByAppendingPathComponent:@"example.dat"];

    [NSKeyedArchiver archiveRootObject:peititionListingResultsArray toFile:arrayPath];
    canAdvanceToNextScreen = YES;
    
    
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
