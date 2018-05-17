//
//  FWItem.m
//  FileWatch
//
//  Created by Jon Gilkison on 5/17/18.
//  Copyright © 2018 Jon Gilkison. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FWItem.h"
#import "NSDictionary+ILAB.h"
#import "FWScriptRunner.h"

@interface FWItem()<FWScriptRunnerDelegate> {
    NSMutableArray<FWItem *> *items;
    FWScriptRunner *scriptRunner;
    NSString *scriptPath;
}
@end

@implementation FWItem

@synthesize items = items;

#pragma mark - Initialization

-(instancetype)initWithData:(NSDictionary *)data baseURL:(NSURL *)baseURL {
    if ((self = [super init])) {
        items = [NSMutableArray new];
        
        _title = [data getModelString:@"title" default:nil];
        _source = [data getModelString:@"source" default:nil];
        scriptPath = _script = [data getModelString:@"script" default:nil];
        _enabled = [data getModelBool:@"enabled" default:YES];
        _runInTerminal = [data getModelBool:@"terminal" default:NO];

        _watch = ((_source != nil) && [NSFileManager.defaultManager fileExistsAtPath:_source]);

        if (_enabled) {
            NSArray<NSDictionary *> *itemsData = [data getModelArray:@"items" default:@[]];
            for(NSDictionary *itemData in itemsData) {
                [items addObject:[[FWItem alloc] initWithData:itemData baseURL:baseURL]];
            }
        }

        if (_enabled && scriptPath) {
            _enabled = [NSFileManager.defaultManager fileExistsAtPath:scriptPath];
            if (!_enabled) {
                scriptPath = [baseURL URLByAppendingPathComponent:_script].path;
                _enabled = [NSFileManager.defaultManager fileExistsAtPath:scriptPath];
            }
        }
    }
    
    return self;
}

#pragma mark - Model Data

-(NSDictionary *)modelData {
    return @{
             @"title": _title ?: NSNull.null,
             @"source": _source ?: NSNull.null,
             @"script": _script ?: NSNull.null,
             @"enabled": @(_enabled)
             };
}

#pragma mark - Running Scripts

-(void)run {
    if (scriptRunner && (scriptRunner.status == FWScriptRunnerRunning)) {
        return;
    }
    
    if (!_enabled) {
        return;
    }
    
    if (_runInTerminal) {
        NSTask *task = [NSTask new];
        task.launchPath = @"/usr/bin/open";
        task.arguments = @[@"-b", @"com.googlecode.iterm2", scriptPath];
        [task launch];
    } else {
        scriptRunner = [[FWScriptRunner alloc] initWithScript:scriptPath delegate:self];
        [scriptRunner run];
    }
}

#pragma mark - FWScriptRunnerDelegate

-(void)runner:(nonnull FWScriptRunner *)runner statusChanged:(FWScriptRunnerStatus)newStatus {
    switch(newStatus) {
        case FWScriptRunnerRunning:
            NSLog(@"Script '%@' for item '%@' running ...", _script.lastPathComponent, _source.lastPathComponent);
            break;
        case FWScriptRunnerFinished:
            NSLog(@"Script '%@' for '%@' finished.", _script.lastPathComponent, _source.lastPathComponent);
            break;
        default:
            break;
    }

    if (!_delegate) {
        return;
    }
    
    if (newStatus == FWScriptRunnerRunning) {
        [_delegate itemScriptStarted:self];
    }
}

-(void)runner:(nonnull FWScriptRunner *)runner appendOutput:(nullable NSString *)output {
    NSLog(@"[%@ => %@] %@", _source.lastPathComponent, scriptPath.lastPathComponent, output);
}

-(void)runner:(nonnull FWScriptRunner *)runner appendError:(nullable NSString *)output {
    NSLog(@"[%@ => %@ ERROR] %@", _source.lastPathComponent, scriptPath.lastPathComponent, output);
}

-(void)runner:(nonnull FWScriptRunner *)runner finishedWithCode:(NSInteger)code {
    NSLog(@"[%@ => %@] Finished with code %ld", _source.lastPathComponent, scriptPath.lastPathComponent, code);
    
    if (_delegate) {
        [_delegate itemScriptFinished:self exitCode:code];
    }
}

@end
