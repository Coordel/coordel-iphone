//
//  CKInboxDoNowViewController.h
//  Coordel iPhone
//
//  Created by Jeffry Gorder on 8/17/13.
//  Copyright (c) 2013 Jeffry Gorder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKTaskAction.h"

@interface CKInboxDoNowViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;

@property CKTaskAction *action;

- (id)initWithAction:(CKTaskAction *)action;

@end
