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
@property (nonnull, readonly) NSArray<FWItem *> *items;                     ///< Items to watch


/**
 Reloads the items from config
 */
-(void)reload;

@end

@protocol FWItemManagerDelegate<FWItemDelegate>
@end
