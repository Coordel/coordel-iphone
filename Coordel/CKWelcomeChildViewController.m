//
//  CKWelcomeChildViewController.m
//  Coordel iPhone
//
//  Created by Jeffry Gorder on 7/31/13.
//  Copyright (c) 2013 Jeffry Gorder. All rights reserved.
//

#import "CKWelcomeChildViewController.h"
#import "AppDelegate.h"

@interface CKWelcomeChildViewController ()

@end

@implementation CKWelcomeChildViewController

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
    // Do any additional setup after loading the view from its nib.
    NSString *text;
    
    switch (self.index){
        case 0:
            text = @"Welcome";
            break;
        case 1:
            text = @"Lists";
            break;
        case 2:
            text = @"Tasks";
            break;
        case 3:
            text = @"Inbox";
            break;
        default:
            text = @"Other";
        
    }
    
    self.pageTitle.text = text;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showSignUp:(id)sender {
    [(AppDelegate*)[[UIApplication sharedApplication]delegate] presentSignupViewController];
}

- (IBAction)showLogin:(id)sender {
    [(AppDelegate*)[[UIApplication sharedApplication]delegate] presentLoginViewController];
}
@end
