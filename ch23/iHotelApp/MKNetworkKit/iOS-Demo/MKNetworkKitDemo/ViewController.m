//
//  ViewController.m
//  MKNetworkKit
//
//  Created by Mugunth Kumar (@mugunthkumar) on 11/11/11.
//  Copyright (C) 2011-2020 by Steinlogic

//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "ViewController.h"
#import "AppDelegate.h"

@implementation ViewController

@synthesize uploadOperation = _uploadOperation;
@synthesize downloadOperation = _downloadOperation;
@synthesize currencyOperation = _currencyOperation;

@synthesize downloadProgessBar = _downloadProgessBar;
@synthesize uploadProgessBar = _uploadProgessBar;
@synthesize userTextField = _userTextField;
@synthesize passwordTextField = _passwordTextField;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.downloadProgessBar = nil;
    self.uploadProgessBar = nil;
}

-(void) viewDidDisappear:(BOOL)animated {
    
    if(self.currencyOperation) {
        
        [self.currencyOperation cancel];
        self.currencyOperation = nil;
    }
    
    // upload and download operations are expected to run in background even when view disappears
}

-(IBAction)postDataToServer:(id)sender {
    
    [ApplicationDelegate.samplePoster postDataToServer];
}

-(IBAction)convertCurrencyTapped:(id)sender {
        
    self.currencyOperation = [ApplicationDelegate.yahooEngine currencyRateFor:@"SGD" 
                                                                   inCurrency:@"USD" 
                                                                 onCompletion:^(double rate) {
                                                                     
                                                                     [[[UIAlertView alloc] initWithTitle:@"Today's Singapore Dollar Rates"                              
                                                                                                                     message:[NSString stringWithFormat:@"%.2f", rate]
                                                                                                                    delegate:nil
                                                                                                           cancelButtonTitle:NSLocalizedString(@"Dismiss", @"")
                                                                                                           otherButtonTitles:nil] show];
                                                                 } 
                                                                      onError:^(NSError* error) {
                                                                          
                                                                          
                                                                          DLog(@"%@\t%@\t%@\t%@", [error localizedDescription], [error localizedFailureReason], 
                                                                               [error localizedRecoveryOptions], [error localizedRecoverySuggestion]);
                                                                      }];   
}

-(IBAction)uploadImageTapped:(id)sender {
    
    if([kTwitterUserName length] == 0) {
        
        [[[UIAlertView alloc] initWithTitle:@"Twitter Account Not Set" 
                                   message:@"Set your twitter name/password in AppDelegate.h and try again" 
                                   delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil] show];
        return;
    }
    NSString *uploadPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingFormat:@"/SampleImage.jpg"];
    self.uploadOperation = [ApplicationDelegate.sampleAuth uploadImageFromFile:uploadPath 
                                                                       onCompletion:^(NSString *twitPicURL) {
                                                                           
                                                                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uploaded to"                              
                                                                                                                           message:twitPicURL
                                                                                                                          delegate:nil
                                                                                                                 cancelButtonTitle:NSLocalizedString(@"Dismiss", @"")
                                                                                                                 otherButtonTitles:nil];
                                                                           [alert show];
                                                                           self.uploadProgessBar.progress = 0.0;
                                                                       } 
                                                                            onError:^(NSError* error) {
                                                                                
                                                                                [UIAlertView showWithError:error];
                                                                            }];    
    
    [self.uploadOperation onUploadProgressChanged:^(double progress) {
        
        DLog(@"%.2f", progress*100.0);
        self.uploadProgessBar.progress = progress;
    }];
    
}

-(IBAction)downloadFileTapped:(id)sender {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
	NSString *downloadPath = [cachesDirectory stringByAppendingPathComponent:@"DownloadedFile.pdf"];
    
    self.downloadOperation = [ApplicationDelegate.sampleDownloader downloadFatAssFileFrom:@"http://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSURLRequest_Class/NSURLRequest_Class.pdf" 
                                                                                   toFile:downloadPath]; 
    
    [self.downloadOperation onDownloadProgressChanged:^(double progress) {
        
        DLog(@"%.2f", progress*100.0);
        self.downloadProgessBar.progress = progress;
    }];
    
    [self.downloadOperation onCompletion:^(MKNetworkOperation* completedRequest) {
        
        DLog(@"%@", completedRequest);   
        self.downloadProgessBar.progress = 0.0f;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Download Completed"                              
                                                        message:@"The file is in your Caches directory"
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"Dismiss", @"")
                                              otherButtonTitles:nil];
        [alert show];
    }
                                 onError:^(NSError* error) {
                                     
                                     DLog(@"%@", error);
                                     [UIAlertView showWithError:error];
                                 }];
    
}


-(IBAction)emptyCacheTapped:(id)sender {
    
    [ApplicationDelegate.flickrEngine emptyCache];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)testAuthTapped:(id)sender {
    
    //[ApplicationDelegate.sampleAuth basicAuthTest];
    //[ApplicationDelegate.sampleAuth digestAuthTest];
    [ApplicationDelegate.sampleAuth digestAuthTestWithUser:self.userTextField.text password:self.passwordTextField.text];
    //[ApplicationDelegate.sampleAuth clientCertTest];
}
@end
