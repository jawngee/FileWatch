//
//  NSDictionary+ILAB.h
//  ILAB
//
//  Created by Jon Gilkison on 4/18/18.
//  Copyright © 2018 Jon Gilkison. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>


/**
 Block for processing elements in an array when fetching from the dictionary
 
 @param element The element to process
 @return The result of the processing
 */
typedef id _Nonnull(^ILABProcessArrayElementBlock)(NSDictionary * _Nonnull element);


@interface NSDictionary (ILAB)

/**
 Fetches a NSDictionary for a key, returning the default if it doesn't exist

 @param key The key to get the value for
 @param defaultValue The default value to use if the dictionary doesn't contain key
 @return The value
 */
-(nullable NSDictionary *)getModelDictionary:(nonnull NSString *)key default:(nullable NSDictionary *)defaultValue;

/**
 Fetches a NSArray for a key, returning the default if it doesn't exist
 
 @param key The key to get the value for
 @param defaultValue The default value to use if the dictionary doesn't contain key
 @return The value
 */
-(nullable NSArray *)getModelArray:(nonnull NSString *)key default:(nullable NSArray *)defaultValue;

/**
 Fetches a NSString for a key, returning the default if it doesn't exist
 
 @param key The key to get the value for
 @param defaultValue The default value to use if the dictionary doesn't contain key
 @return The value
 */
-(nullable NSString *)getModelString:(nonnull NSString *)key default:(nullable NSString *)defaultValue;

/**
 Fetches a float for a key, returning the default if it doesn't exist
 
 @param key The key to get the value for
 @param defaultValue The default value to use if the dictionary doesn't contain key
 @return The value
 */
-(float)getModelFloat:(nonnull NSString *)key default:(float)defaultValue;

/**
 Fetches a NSURL for a key, returning the default if it doesn't exist
 
 @param key The key to get the value for
 @param defaultValue The default value to use if the dictionary doesn't contain key
 @return The value
 */
-(nullable NSURL *)getModelURL:(nonnull NSString *)key default:(nullable NSURL *)defaultValue;


/**
 Fetches a boolean for a key, returning the default if it doesn't exist
 
 @param key The key to get the value for
 @param defaultValue The default value to use if the dictionary doesn't contain key
 @return The value
 */
-(BOOL)getModelBool:(nonnull NSString *)key default:(BOOL)defaultValue;

/**
 Fetches a CGPoint for a key, returning the default if it doesn't exist
 
 @param key The key to get the value for
 @param defaultValue The default value to use if the dictionary doesn't contain key
 @return The value
 */
-(CGPoint)getModelCGPoint:(nonnull NSString *)key default:(CGPoint)defaultValue;

/**
 Fetches a CGRect for a key, returning the default if it doesn't exist
 
 @param key The key to get the value for
 @param defaultValue The default value to use if the dictionary doesn't contain key
 @return The value
 */
-(CGRect)getModelCGRect:(nonnull NSString *)key default:(CGRect)defaultValue;

/**
 Fetches a NSUInteger for a key, returning the default if it doesn't exist
 
 @param key The key to get the value for
 @param defaultValue The default value to use if the dictionary doesn't contain key
 @return The value
 */
-(NSUInteger)getModelUnsignedInteger:(nonnull NSString *)key default:(NSUInteger)defaultValue;

/**
 Fetches a NSInteger for a key, returning the default if it doesn't exist
 
 @param key The key to get the value for
 @param defaultValue The default value to use if the dictionary doesn't contain key
 @return The value
 */
-(NSInteger)getModelInteger:(nonnull NSString *)key default:(NSInteger)defaultValue;

/**
 Fetches a CMTime for a key, returning the default if it doesn't exist
 
 @param key The key to get the value for
 @param defaultValue The default value to use if the dictionary doesn't contain key
 @return The value
 */
-(CMTime)getModelCMTime:(nonnull NSString *)key default:(CMTime)defaultValue;

/**
 Fetches a CIImage for a key, returning the default if it doesn't exist
 
 @param key The key to get the value for
 @param defaultValue The default value to use if the dictionary doesn't contain key
 @return The value
 */
-(nullable CIImage *)getModelCIImage:(nonnull NSString *)key default:(nullable CIImage *)defaultValue;

/**
 Fetches an object for a key, returning the default if it doesn't exist
 
 @param key The key to get the value for
 @param defaultValue The default value to use if the dictionary doesn't contain key
 @return The value
 */
-(nullable id)getModelObject:(nonnull NSString *)key default:(nullable id)defaultValue;

/**
 Processes an array of items in the dictionary at the specified key, returning an array of
 the results of the process.

 @param key The key to get the value for
 @param processingBlock The block used to process each element
 @return An NSMutableArray containing processed items
 */
-(nullable NSMutableArray *)getMutableArrayOfModels:(nonnull NSString *)key
                                    processingBlock:(nonnull ILABProcessArrayElementBlock)processingBlock;

/**
 Fetches the first object that matches any of the given keys

 @param keys The keys to use to match
 @param defaultValue The default value to use if no match
 @return The first matched object or the default value
 */
-(nullable id)getModelObjectMatchingFirstKey:(nonnull NSArray<NSString *> *)keys
                                defaultValue:(nullable id)defaultValue;

@end
