//
//  CKTasksViewController.m
//  Coordel
//
//  Created by Jeffry Gorder on 7/27/13.
//  Copyright (c) 2013 Jeffry Gorder. All rights reserved.
//

#import "CKTasksViewController.h"
#import "SWRevealViewController.h"

@interface CKTasksViewController ()

@end

@implementation CKTasksViewController

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
	// Do any additional setup after loading the view.
    SWRevealViewController *revealController = [self revealViewController];
    
    [self.navigationController.navigationBar addGestureRecognizer:revealController.panGestureRecognizer];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                                         style:UIBarButtonItemStylePlain target:revealController action:@selector(revealToggle:)];
    
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    self.navigationController.navigationBar.tintColor = kCKColorTasks;
    self.segmentIndex = 1;
    
    NSLog(@"segment indes for tasks %d",self.segmentIndex);

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
