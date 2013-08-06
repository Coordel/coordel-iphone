//
//  CKInboxPlayViewController.h
//  Coordel iPhone
//
//  Created by Jeffry Gorder on 8/3/13.
//  Copyright (c) 2013 Jeffry Gorder. All rights reserved.
//

#include <MailCore/MailCore.h>


@interface CKInboxPlayViewController : UIViewController

- (IBAction)cancelPlay:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *messageContainer;

@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

- (IBAction)skip:(id)sender;


@end
