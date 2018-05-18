//
//  FWItem.h
//  FileWatch
//
//  Created by Jon Gilkison on 5/17/18.
//  Copyright © 2018 Jon Gilkison. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FWHotKey.h"

@protocol FWItemDelegate;

/**
 Represents a watched item
 */
@interface FWItem : NSObject

@property (nullable, weak, nonatomic) id<FWItemDelegate> delegate;    ///< Delegate

@property (assign, nonatomic) BOOL enabled;         ///< Determines if this item is enabled
@property (readonly) BOOL watch;                    ///< Determines if this item should be watched
@property (readonly) BOOL runInTerminal;            ///< Runs the script in a terminal, instead of using NSTask

@property (nullable, readonly) NSString *title;             ///< Title of the item
@property (nullable, readonly) NSString *source;            ///< Source file to watch
@property (nullable, readonly) NSString *script;            ///< Script to run when item is changed
@property (nullable, readonly) NSArray<NSString *> *args;   ///< Additional arguments to be passed to the script
@property (nullable, readonly) NSURL *url;                  ///< External URL to launch
@property (nonnull, readonly) NSArray<FWItem *> *items;     ///< Items to watch
@property (nullable, readonly) FWHotKey *hotKey;            ///< Hotkey for this item, if any.

@property (nullable, strong, nonatomic) id<NSObject> objTag;    ///< Object tag

/**
 Creates a new instance type

 @param data The NSDictionary containing the data to populate the model with
 @param baseURL The URL of the config directory
 @return The new instance
 */
-(nonnull instancetype)initWithData:(nonnull NSDictionary *)data baseURL:(nonnull NSURL *)baseURL;


/**
 Asks the item to run it's script if it matches the supplied source

 @param source The path of the source file to match against
 @return YES if this item, or it's children, match
 */
-(BOOL)runIfMatches:(nonnull NSString *)source;

/**
 Executes the item's script
 */
-(void)run;

/**
 Triggered by this item's hotkey
 
 @param sender The sender
 */
-(void)hotkey:(id _Nullable)sender;

@end


/**
 Delegate for FWItem
 */
@protocol FWItemDelegate<NSObject>

/**
 The item's script started running

 @param item The FWItem
 */
-(void)itemScriptStarted:(nonnull FWItem *)item;

/**
 The item's script finished running

 @param item The FWItem
 @param exitCode The exit code of the script
 */
-(void)itemScriptFinished:(nonnull FWItem *)item exitCode:(NSInteger)exitCode;


@end
