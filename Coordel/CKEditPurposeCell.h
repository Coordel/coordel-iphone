//
//  CKEditPurposeCell.h
//  Coordel iPhone
//
//  Created by Jeffry Gorder on 8/17/13.
//  Copyright (c) 2013 Jeffry Gorder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZTextView.h"

@interface CKEditPurposeCell : UITableViewCell <UITextViewDelegate>

@property (strong, nonatomic) IBOutlet SZTextView *textView;


@end
