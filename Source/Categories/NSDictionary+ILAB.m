//
//  NSDictionary+ILAB.m
//  ILAB
//
//  Created by Jon Gilkison on 4/18/18.
//  Copyright © 2018 Jon Gilkison. All rights reserved.
//

#import "NSDictionary+ILAB.h"

@implementation NSDictionary (ILAB)

-(NSDictionary *)getModelDictionary:(NSString *)key default:(NSDictionary *)defaultValue {
    if (self[key] && (self[key] != [NSNull null]) && ([self[key] isKindOfClass:[NSDictionary class]])) {
        return self[key];
    }
    
    return defaultValue;
}

-(NSArray *)getModelArray:(NSString *)key default:(NSArray *)defaultValue {
    if (self[key] && (self[key] != [NSNull null]) && ([self[key] isKindOfClass:[NSArray class]])) {
        return self[key];
    }
    
    return defaultValue;
}

-(NSString *)getModelString:(NSString *)key default:(NSString *)defaultValue {
    if (self[key] && (self[key] != [NSNull null]) && ([self[key] isKindOfClass:[NSString class]]) && (![self[key] isEqualToString:@""])) {
        return self[key];
    }
    
    return defaultValue;
}

-(float)getModelFloat:(NSString *)key default:(float)defaultValue {
    if (self[key] && (self[key] != [NSNull null])) {
        return [self[key] floatValue];
    }
    
    return defaultValue;
}

-(NSURL *)getModelURL:(NSString *)key default:(NSURL *)defaultValue {
    if (self[key] && (self[key] != [NSNull null]) && ([self[key] isKindOfClass:[NSString class]]) && (![self[key] isEqualToString:@""])) {
        NSString *url = self[key];
        if ([url hasPrefix:@"bundle://"]) {
            url = [url stringByReplacingOccurrencesOfString:@"bundle://" withString:@""];
            return [NSBundle.mainBundle URLForResource:url withExtension:nil];
        }
        
        return [NSURL URLWithString:self[key]];
    }
    
    return defaultValue;
    
}

-(BOOL)getModelBool:(NSString *)key default:(BOOL)defaultValue {
    if (self[key] && (self[key] != [NSNull null])) {
        return [self[key] boolValue];
    }
    
    return defaultValue;
}

-(NSInteger)getModelInteger:(NSString *)key default:(NSInteger)defaultValue {
    if (self[key] && (self[key] != [NSNull null])) {
        return [self[key] integerValue];
    }
    
    return defaultValue;
}

-(NSUInteger)getModelUnsignedInteger:(NSString *)key default:(NSUInteger)defaultValue {
    if (self[key] && (self[key] != [NSNull null])) {
        return [self[key] unsignedIntegerValue];
    }
    
    return defaultValue;
}


-(CGPoint)getModelCGPoint:(NSString *)key default:(CGPoint)defaultValue {
    if (self[key] && (self[key] != [NSNull null])) {
        return [self[key] CGPointValue];
    }
    
    return defaultValue;
}


-(CGRect)getModelCGRect:(NSString *)key default:(CGRect)defaultValue {
    if (self[key] && (self[key] != [NSNull null])) {
        return [self[key] CGRectValue];
    }
    
    return defaultValue;
}

-(CMTime)getModelCMTime:(NSString *)key default:(CMTime)defaultValue {
    if (self[key] && (self[key] != [NSNull null])) {
        return [self[key] CMTimeValue];
    }
    
    return defaultValue;
}

-(CIImage *)getModelCIImage:(NSString *)key default:(CIImage *)defaultValue {
    if (self[key] && (self[key] != [NSNull null])) {
        return self[key];
    }
    
    return defaultValue;
}

-(nullable id)getModelObject:(nonnull NSString *)key default:(nullable id)defaultValue {
    if (self[key] && (self[key] != [NSNull null])) {
        return self[key];
    }
    
    return defaultValue;
}

-(NSMutableArray *)getMutableArrayOfModels:(NSString *)key processingBlock:(ILABProcessArrayElementBlock)processingBlock {
    if (!self[key] || (self[key] == [NSNull null]) || (![self[key] isKindOfClass:[NSArray class]])) {
        return [NSMutableArray new];
    }
    
    NSMutableArray *resultArray = [NSMutableArray new];
    NSArray *eles = self[key];
    
    for(id ele in eles) {
        if (ele == NSNull.null) {
            continue;
        }
        
        id result = processingBlock(ele);
        if (result) {
            [resultArray addObject:result];
        }
    }
    
    return resultArray;
}

-(id)getModelObjectMatchingFirstKey:(NSArray<NSString *> *)keys defaultValue:(id)defaultValue {
    for(NSString *key in keys) {
        if (self[key] && (self[key] != [NSNull null])) {
            return self[key];
        }
    }
    
    return defaultValue;
}

@end
