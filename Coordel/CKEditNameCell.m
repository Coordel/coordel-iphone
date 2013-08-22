//
//  CKEditNameCell.m
//  Coordel iPhone
//
//  Created by Jeffry Gorder on 8/17/13.
//  Copyright (c) 2013 Jeffry Gorder. All rights reserved.
//

#import "CKEditNameCell.h"

const float LABEL_LEFT_MARGIN = 15.0f;

@implementation CKEditNameCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _textField = [[UITextField alloc]initWithFrame:CGRectNull];
        [_textField setReturnKeyType:UIReturnKeyDone];
        _textField.placeholder = kLocalizedName;
        [self addSubview:_textField];
        
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

    _textField.frame = CGRectMake(LABEL_LEFT_MARGIN, 0,
                              self.bounds.size.width - LABEL_LEFT_MARGIN,self.bounds.size.height);
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    // close the keyboard on enter
    [textField resignFirstResponder];
    return NO;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    // disable editing of completed to-do items
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    // set the model object state when an edit has complete
   _textField.text = textField.text;
}

@end
