//
//  Constants.h
//  Coordel iPhone
//
//  Created by Jeffry Gorder on 7/28/13.
//  Copyright (c) 2013 Jeffry Gorder. All rights reserved.
//


typedef NS_ENUM(NSInteger, CKListStatus) {
    CKListStatusPending,
    CKListStatusActive,
    CKListStatusPaused,
    CKListStatusResumed,
    CKListStatusCancelled,
    CKListStatusDone,
    CKListStatusDeleted
};

typedef NS_ENUM(NSInteger, CKListType) {
    CKListTypeDiscussion,
    CKListTypePersonal,
    CKListTypeDefault
};

typedef NS_ENUM(NSInteger, CKListRole) {
    CKListRoleOrganizer,
    CKListRoleParticipant,
    CKListRoleFollower
};

typedef NS_ENUM(NSInteger, CKListRoleStatus) {
    CKListRoleStatusInvited,
    CKListRoleStatusAccepted,
    CKListRoleStatusDeclined,
    CKListRoleStatusProposedChange,
    CKListRoleStatusAgreedChange,
    CKListRoleStatusAmendedChange,
    CKListRoleStatusLeft
};


typedef NS_ENUM(NSInteger, CKTaskStatus) {
    CKTaskStatusUnassigned,
    CKTaskStatusPendingDelegated,
    CKTaskStatusPendingProposed,
    CKTaskStatusPendingAgreed,
    CKTaskStatusDelegated,
    CKTaskStatusProposedChange,
    CKTaskStatusAgreedChange,
    CKTaskStatusAmendedChange,
    CKTaskStatusDeclined,
    CKTaskStatusAccepted,
    CKTaskStatusProposedDone,
    CKTaskStatusReturned,
    CKTaskStatusPaused,
    CKTaskStatusResumed,
    CKTaskStatusCancelled,
    CKTaskStatusIssueRaised,
    CKTaskStatusIssueCleared,
    CKTaskStatusAgreedDone,
    CKTaskStatusDoneNoAgreement,
    CKTaskStatusArchived,
    CKTaskStatusDeleted
};

typedef NS_ENUM(NSInteger, CKTaskActionType) {
    CKTaskActionTypeDoNow,
    CKTaskActionTypeDefer,
    CKTaskActionTypeDelegate,
    CKTaskActionTypeAttachEmail,
    CKTaskActionTypeArchive,
    CKTaskActionTypeDelete
};






typedef NS_ENUM(NSInteger, CKTaskProperty) {
    CKTaskPropertyName,
    CKTaskPropertyPurpose
};


#pragma mark - Coordel Colors

#define kCKColorLists [UIColor colorWithRed:122/255.0f green:207/255.0f blue:21/255.0f alpha:1]
#define kCKColorTasks [UIColor colorWithRed:63/255.0f green:169/255.0f blue:245/255.0f alpha:1]
#define kCKColorInbox [UIColor colorWithRed:255/255.0f green:29/255.0f blue:37/255.0f alpha:1]
#define kCKColorLightGray [UIColor colorWithRed:230/255.0f green:230/255.0f blue:230/255.0f alpha:1]
#define kCKColorPlaceholderGray [UIColor colorWithRed:199/255.0f green:198/255.0f blue:205/255.0f alpha:1]




#pragma mark - User Defaults Keys
// Class key
extern NSString *const kCKUserDefaultsAfterFirstLaunch;
extern NSString *const kCKUserDefaultsInboxSliderDate;
extern NSString *const kCKUserDefaultsInboxPlayBatchSize;
extern NSString *const kCKUserDefaultsListDefaultDeadlineDayInterval;
extern NSString *const kCKUserDefaultsTaskDefaultDeadlineDayInterval;



#pragma mark - Core Data Keys
extern NSString *const kCKInboxDataMessagesEntity;
extern NSString *const kCKInboxDataMessagesEntityMessageIDKey;
extern NSString *const kCKInboxDataMessagesEntityReceivedDateKey;
extern NSString *const kCKInboxDataMessagesEntityTypeKey;
extern NSString *const kCKInboxDataMessagesEntityUIDKey;
extern NSString *const kCKInboxDataMessagesEntityUsernameKey;

