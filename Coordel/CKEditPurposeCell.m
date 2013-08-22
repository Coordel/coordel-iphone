//
//  CKEditPurposeCell.m
//  Coordel iPhone
//
//  Created by Jeffry Gorder on 8/17/13.
//  Copyright (c) 2013 Jeffry Gorder. All rights reserved.
//

#import "CKEditPurposeCell.h"



@implementation CKEditPurposeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
     
        _textView = [[SZTextView alloc]initWithFrame:CGRectNull];
        _textView.contentInset = UIEdgeInsetsZero;
        _textView.placeholder = kLocalizedPurpose;
        _textView.placeholderTextColor = kCKColorPlaceholderGray;
        [self addSubview:_textView];

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews {
    [super layoutSubviews];
    // ensure the gradient layers occupies the full bounds
    const float LABEL_LEFT_MARGIN = 15.0f;
    NSLog(@"bounds size %f, content size %f", self.bounds.size.height, _textView.contentSize.height);
    _textView.frame = CGRectMake(LABEL_LEFT_MARGIN, 0,
                             self.bounds.size.width - LABEL_LEFT_MARGIN,MAX(self.bounds.size.height,_textView.contentSize.height));
    
}

@end
