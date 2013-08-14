//
//  CKTaskAction.m
//  Coordel iPhone
//
//  Created by Jeffry Gorder on 8/10/13.
//  Copyright (c) 2013 Jeffry Gorder. All rights reserved.
//

#import "CKTaskAction.h"
#import "CKTaskNameCell.h"


@interface CKTaskAction ()

//this method returns a property value template for
- (NSString *)propertyTemplateFromEmail:(NSInteger)property;


@end

@implementation CKTaskAction

@synthesize navigationTitle = _navigationTitle;


- (NSString*)navigationTitle
{
    NSString *title = @"";
    
    switch (_actionType) {
        case CKTaskActionTypeDefer:
            title = @"Defer Task";
            break;
        case CKTaskActionTypeDelegate:
            title = @"Delegate Task";
            break;
            
        
    }
    return title;
}


- (id)initWithEmail: (MCOMessageParser *)email forAction:(NSInteger)actionType
{
    self = [super init];
    if (self) {
        
                
        //since this is from an email, we know there isn't a task yet
        //so make a new one
        _actionType = actionType;
        _email = email;

        _task = [[CKTask alloc]init];
        _task.name = [self getTaskNameFromEmail];
        _task.purpose = [self getTaskPurposeFromEmail];
        
        
        // Custom initialization
        NSMutableArray *keys = [[NSMutableArray alloc] init];
        NSMutableDictionary *contents = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *footers = [[NSMutableDictionary alloc]init];
        
        NSString *namePurposeKey = @"Task";
        NSString *listsKey = @"List";
        NSString *deliverablesKey = @"Deliverables";
        
        [contents setObject:[NSArray arrayWithObjects:@[_task.name, @0],@[_task.purpose,@1], nil] forKey:namePurposeKey];
        [contents setObject:[NSArray arrayWithObjects:@[@"Add List...",@2], nil] forKey:listsKey];
        [contents setObject:[NSArray arrayWithObjects:@[@"Add Deliverable...",@3], nil] forKey:deliverablesKey];
        
        [keys addObject:namePurposeKey];
        [keys addObject:listsKey];
        [keys addObject:deliverablesKey];
        
        [footers setObject:@"Footer for name purpose" forKey:namePurposeKey];
        [footers setObject:@"Footer list" forKey:listsKey];
        [footers setObject:@"Footer for deliverables" forKey:deliverablesKey];
        
        [self setSectionKeys:keys];
        [self setSectionContents:contents];
        [self setSectionFooters:footers];
        
    }
    return self;
}

- (id)initWithTask:(CKTask *)task forAction:(NSInteger)actionType
{
    self = [super init];
    if (self) {
        _task = task;
        _actionType = actionType;
    }
    return self;
}


#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    NSInteger sections = [[self sectionKeys] count];
    
    return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key = [[self sectionKeys] objectAtIndex:section];
    NSArray *contents = [[self sectionContents] objectForKey:key];
    NSInteger rows = [contents count];
    
    return rows;}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = [[self sectionKeys] objectAtIndex:[indexPath section]];
    NSArray *contents = [[self sectionContents] objectForKey:key];
    NSArray *contentForThisRow = [contents objectAtIndex:[indexPath row]];
    
    if ([[contentForThisRow objectAtIndex:1] intValue] == 0){
        static NSString *nameCellIdentifier = @"TaskNameCellReuseId";
        CKTaskNameCell *cell = [tableView dequeueReusableCellWithIdentifier:nameCellIdentifier];
        if (cell == nil) {
            cell = [[CKTaskNameCell alloc] init];
        }
        // Configure the cell...
        NSLog(@"value for cell %@",[contentForThisRow objectAtIndex:0] );
        [cell.cellLabel  setText:[contentForThisRow objectAtIndex:0]];
        return cell;
        
    } else {
        
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *defaultCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (defaultCell == nil) {
            defaultCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        [[defaultCell textLabel] setText:[contentForThisRow objectAtIndex:0]];

         return defaultCell;
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    NSString *key = [[self sectionKeys] objectAtIndex:section];
    if (section == 0){
        key = nil;
    }
    
    return key;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    NSString *key = [[self sectionKeys] objectAtIndex:section];
    NSString *footer = [[self sectionFooters] objectForKey:key];
    return footer;
}

#pragma mark - Task values derived from email
- (NSString *)getTaskNameFromEmail
{
    return [self propertyTemplateFromEmail:CKTaskPropertyName];
}

- (NSString *)getTaskPurposeFromEmail
{
    return [self propertyTemplateFromEmail:CKTaskPropertyPurpose];
}

- (NSArray *)getTaskAttachmentsFromEmail
{
    return [[NSArray alloc]init];
}

#pragma mark - Task property value templates

//this method returns a property value template for a task property for an action
- (NSString *)propertyTemplateFromEmail:(NSInteger)property
{
    NSString *template = @"";
    
    NSLog(@"getting template property - %d, action - %d ",property, _actionType);
    
    switch (property) {
        case CKTaskPropertyName:
            switch (_actionType) {
                case CKTaskActionTypeDoNow:
                    template = [NSString stringWithFormat:@"Handle e-mail request from %@", _email.header.from.displayName];
                    break;
                case CKTaskActionTypeDefer:
                    template = [NSString stringWithFormat:@"Handle e-mail request from %@", _email.header.from.displayName];
                    break;
                case CKTaskActionTypeDelegate:
                    template = [NSString stringWithFormat:@"Handle e-mail request from %@", _email.header.from.displayName];
                    break;
                case CKTaskActionTypeAttachEmail:
                    template = nil;
                    break;
                case CKTaskActionTypeArchive:
                    template = nil;
                    break;
                case CKTaskActionTypeDelete:
                    template = nil;
                    break;
                    
            }
            break;
        case CKTaskPropertyPurpose:
            switch (_actionType) {
                case CKTaskActionTypeDoNow:
                    template = [NSString stringWithFormat:@"Do work requested in attached email from %@ on %@. Original message subject: %@", _email.header.from.displayName, _email.header.receivedDate, _email.header.subject];
                    break;
                case CKTaskActionTypeDefer:
                    template = [NSString stringWithFormat:@"(defer)Do work requested in attached email from %@ on %@. Original message subject: %@", _email.header.from.displayName, _email.header.receivedDate, _email.header.subject];
                    break;
                case CKTaskActionTypeDelegate:
                    template = [NSString stringWithFormat:@"(delegate)Do work requested in attached email from %@ on %@. Original message subject: %@", _email.header.from.displayName, _email.header.receivedDate, _email.header.subject];
                    break;
                case CKTaskActionTypeAttachEmail:
                    template = nil;
                    break;
                case CKTaskActionTypeArchive:
                    template = nil;
                    break;
                case CKTaskActionTypeDelete:
                    template = nil;
                    break;
                    
            }
            
            break;
            
    }
    return template;
}



@end
