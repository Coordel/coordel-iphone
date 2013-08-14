//
//  CKInboxPlayViewController.h
//  Coordel iPhone
//
//  Created by Jeffry Gorder on 8/3/13.
//  Copyright (c) 2013 Jeffry Gorder. All rights reserved.
//

#import <MailCore/MailCore.h>
#import "RNGridMenu.h"


@interface CKInboxPlayViewController : UIViewController <RNGridMenuDelegate>

- (IBAction)cancelPlay:(id)sender;


@property (weak, nonatomic) IBOutlet UIView *messageContainer;

@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

- (IBAction)showActions:(id)sender;

- (IBAction)skipMessage:(id)sender;

@end
