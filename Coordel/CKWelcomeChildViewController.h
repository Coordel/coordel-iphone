//
//  CKWelcomeChildViewController.h
//  Coordel iPhone
//
//  Created by Jeffry Gorder on 7/31/13.
//  Copyright (c) 2013 Jeffry Gorder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CKWelcomeChildViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *pageTitle;

@property (assign, nonatomic) NSInteger index;

- (IBAction)showSignUp:(id)sender;
- (IBAction)showLogin:(id)sender;
@end
