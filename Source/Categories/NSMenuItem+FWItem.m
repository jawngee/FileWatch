//
//  NSMenuItem+FWItem.m
//  FileWatch
//
//  Created by Jon Gilkison on 5/18/18.
//  Copyright © 2018 Jon Gilkison. All rights reserved.
//

#import "NSMenuItem+FWItem.h"
#import <objc/runtime.h>

@implementation NSMenuItem (FWItem)

static char fileWatchItemKey;

@dynamic fileWatchItem;

-(void)setFileWatchItem:(FWItem *)fileWatchItem {
    [self willChangeValueForKey:@"fileWatchItem"];
    objc_setAssociatedObject(self, &fileWatchItemKey, fileWatchItem, OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"fileWatchItem"];
}

-(FWItem *)fileWatchItem {
    return objc_getAssociatedObject(self, &fileWatchItemKey);
}

@end
