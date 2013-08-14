//
//  CKListsViewController.h
//  Coordel
//
//  Created by Jeffry Gorder on 7/27/13.
//  Copyright (c) 2013 Jeffry Gorder. All rights reserved.
//

#import "CKBaseSegmentedViewController.h"

@interface CKListsSegmentViewController :  PFQueryTableViewController

@property int segmentIndex;

- (void)showPrimaryNavBar;


@end
