//
//  CKInboxPlayViewController.h
//  Coordel iPhone
//
//  Created by Jeffry Gorder on 8/3/13.
//  Copyright (c) 2013 Jeffry Gorder. All rights reserved.
//


#import "RNGridMenu.h"


@interface CKInboxPlayViewController : UIViewController <RNGridMenuDelegate>

@property (weak, nonatomic) IBOutlet UIView *messageContainer;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;


- (IBAction)skipMessage:(id)sender;
- (IBAction)cancelPlay:(id)sender;

@end
