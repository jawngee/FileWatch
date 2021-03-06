//
//  FWItemManager.m
//  FileWatch
//
//  Created by Jon Gilkison on 5/17/18.
//  Copyright © 2018 Jon Gilkison. All rights reserved.
//

#import "FWItemManager.h"
#import "NSDictionary+ILAB.h"
#import "VDKQueue.h"

@interface FWItemManager()<VDKQueueDelegate, FWItemDelegate> {
    NSMutableArray<FWItem *> *items;
    NSURL *itemsDataURL;
    VDKQueue *queue;
}
@end

@implementation FWItemManager

@synthesize items = items;

#pragma mark - Initialization

-(instancetype)init {
    if ((self = [super init])) {
        queue = [[VDKQueue alloc] init];
        queue.delegate = self;
        
        _loaded = [self reload];
    }
    
    return self;
}

#pragma mark - Item Management

-(BOOL)reload {
    NSString *homeDir = NSHomeDirectory();
    itemsDataURL = [[NSURL fileURLWithPath:homeDir] URLByAppendingPathComponent:@".filewatch/config.json"];
    
    if ([NSFileManager.defaultManager fileExistsAtPath:itemsDataURL.path]) {
        NSData *data = [NSData dataWithContentsOfURL:itemsDataURL];
        NSDictionary *configJSONData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        BOOL processedItems = NO;
        if (configJSONData && [configJSONData isKindOfClass:NSDictionary.class]) {
            [queue removeAllPaths];
            items = [NSMutableArray new];

            NSArray<NSDictionary *> *itemsData = [configJSONData getModelArray:@"items" default:@[]];
            for(NSDictionary *itemData in itemsData) {
                FWItem *item = [[FWItem alloc] initWithData:itemData baseURL:itemsDataURL.URLByDeletingLastPathComponent];
                [items addObject:item];
            }

            [self processItems:items];
            
            processedItems = YES;
        }
        
        [queue addPath:itemsDataURL.path];
        
        _loaded = processedItems;
        
        return processedItems;
    }
    
    return NO;
}

-(void)processItems:(NSArray<FWItem *> *)itemsToProcess {
    for(FWItem *item in itemsToProcess) {
        item.delegate = self;
        if (item.watch && item.enabled) {
            [queue addPath:item.source];
        }
        
        [self processItems:item.items];
    }
}

#pragma mark - VDKQueueDelegate

- (void)queue:(VDKQueue *)queue didReceiveNotification:(NSString *)notificationName forPath:(NSString *)fpath {
    BOOL shouldRun = NO;
    if ([notificationName isEqualToString:VDKQueueWriteNotification]) {
        shouldRun = YES;
    } else if ([notificationName isEqualToString:VDKQueueDeleteNotification]) {
        shouldRun = YES;
        [queue removePath:fpath];
        [queue addPath:fpath];
    }
    
    if (shouldRun) {
        if ([itemsDataURL.path isEqualToString:fpath]) {
            if ([self reload] && _delegate) {
                [_delegate itemManagerReloaded:self];
            }
        } else {
            for(FWItem *item in items) {
                if ([item runIfMatches:fpath]) {
                    break;
                }
            }
        }
    }
}

#pragma mark - FWItemDelegate

-(void)itemScriptStarted:(FWItem *)item {
    if (_delegate) {
        [_delegate itemScriptStarted:item];
    }
}

-(void)itemScriptFinished:(FWItem *)item exitCode:(NSInteger)exitCode {
    if (_delegate) {
        [_delegate itemScriptFinished:item exitCode:exitCode];
    }
}

@end
