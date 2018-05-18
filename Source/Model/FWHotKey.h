//
//  FWHotKey.h
//  FileWatch
//
//  Created by Jon Gilkison on 5/18/18.
//  Copyright © 2018 Jon Gilkison. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/**
 Defines a hot key
 */
@interface FWHotKey : NSObject

@property (readonly) NSEventModifierFlags modifiers;    ///< Modifiers for the Hotkey
@property (nullable, readonly) NSString *key;           ///< The key for the modifier
@property (readonly) unsigned short keyCode;            ///< Keycode equivalent (hopefully)

/**
 Creates a new instance type
 
 @param data The NSDictionary containing the data to populate the model with
 @return The new instance
 */
-(nonnull instancetype)initWithData:(nonnull NSDictionary *)data;

@end
