//
//  CKInboxViewController.h
//  Coordel
//
//  Created by Jeffry Gorder on 7/27/13.
//  Copyright (c) 2013 Jeffry Gorder. All rights reserved.
//

#import "CKBaseSegmentedViewController.h"

@interface CKInboxViewController : UIViewController

@property int segmentIndex;

@property (weak, nonatomic) IBOutlet UISlider *slider;

@property (weak, nonatomic) IBOutlet UILabel *sliderLabel;


@property (weak, nonatomic) IBOutlet UILabel *inboxCount;

- (void)showPrimaryNavBar;

- (IBAction)valueChanged:(id)sender;

- (IBAction)startPlay:(id)sender;

@end
