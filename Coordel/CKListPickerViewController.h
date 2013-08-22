//
//  CKListPickerViewController.h
//  Coordel iPhone
//
//  Created by Jeffry Gorder on 8/22/13.
//  Copyright (c) 2013 Jeffry Gorder. All rights reserved.
//

@protocol CKListPickerDelegate <NSObject>

- (void)listPickerDidSelectList:(id)list added:(BOOL)isAdded;

@end


@interface CKListPickerViewController : PFQueryTableViewController

@property (nonatomic, assign) IBOutlet id <CKListPickerDelegate> delegate;


@end
