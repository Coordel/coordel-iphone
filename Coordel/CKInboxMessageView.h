//
//  CKInboxMessageView.h
//  Coordel iPhone
//
//  Created by Jeffry Gorder on 8/3/13.
//  Copyright (c) 2013 Jeffry Gorder. All rights reserved.
//

#include <MailCore/MailCore.h>

@protocol MCOMessageViewDelegate;

@interface CKInboxMessageView : UIView <UIWebViewDelegate>

@property (nonatomic, copy) NSString *folder;
@property (nonatomic, strong) MCOAbstractMessage *message;

@property (nonatomic, assign) id <MCOMessageViewDelegate> delegate;

- (void) refresh;

@end


