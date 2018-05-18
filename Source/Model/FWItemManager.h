//
//  FWItemManager.h
//  FileWatch
//
//  Created by Jon Gilkison on 5/17/18.
//  Copyright © 2018 Jon Gilkison. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FWItem.h"

@protocol FWItemManagerDelegate;

/**
 Manages the various items to watch.
 */
@interface FWItemManager : NSObject

@property (nullable, weak, nonatomic) id<FWItemManagerDelegate> delegate;   ///< Delegate
@property (readonly) BOOL loaded;                                           ///< Determines if the item manager is loaded
@property (nonnull, readonly) NSArray<FWItem *> *items;                     ///< Items to watch


/**
 Reloads the items from config
 
 @return YES if reloaded, NO if not
 */
-(BOOL)reload;

@end

@protocol FWItemManagerDelegate<FWItemDelegate>


/**
 Triggered when the item manager has reloaded it's config.

 @param manager The FWItemManager instance
 */
-(void)itemManagerReloaded:(nonnull FWItemManager *)manager;

@end
