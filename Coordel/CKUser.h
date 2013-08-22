//
//  CKUser.h
//  Coordel iPhone
//
//  Created by Jeffry Gorder on 8/13/13.
//  Copyright (c) 2013 Jeffry Gorder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CKUser : PFUser<PFSubclassing>

@property (nonatomic) NSString *defaultList;
@property (nonatomic) NSString *fullName;

+ (CKUser *)currentUser;



@end
