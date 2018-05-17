//
//  NSMenuItem+FWItem.h
//  FileWatch
//
//  Created by Jon Gilkison on 5/18/18.
//  Copyright © 2018 Jon Gilkison. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FWItem.h"

@interface NSMenuItem (FWItem)

@property (weak, nonatomic, nullable) FWItem *fileWatchItem;

@end
