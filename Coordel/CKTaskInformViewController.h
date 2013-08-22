//
//  CKTaskInformViewController.h
//  Coordel iPhone
//
//  Created by Jeffry Gorder on 8/9/13.
//  Copyright (c) 2013 Jeffry Gorder. All rights reserved.
//

#import "CKTaskAction.h"
#import "SZTextView.h"

@interface CKTaskInformViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *toLabel;
@property (weak, nonatomic) IBOutlet UILabel *subjectLabel;
@property (weak, nonatomic) IBOutlet SZTextView *personalMessage;
@property (weak, nonatomic) IBOutlet UITextView *templateMessage;

@property (nonatomic) CKTaskAction *action;


- (id)initWithAction:(CKTaskAction *)action;

@end
