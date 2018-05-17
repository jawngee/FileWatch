//
//  FWScriptRunner.m
//  FileWatch
//
//  Created by Jon Gilkison on 5/17/18.
//  Copyright © 2018 Jon Gilkison. All rights reserved.
//

#import "FWScriptRunner.h"

@interface FWScriptRunner() {
    NSTask *task;
}
@end

@implementation FWScriptRunner

-(nonnull instancetype)initWithScript:(nonnull NSString *)scriptPath delegate:(nullable id<FWScriptRunnerDelegate>)runnerDelegate {
    if (self = [super init]) {
        _status = FWScriptRunnerNotRun;
        _script = scriptPath;
        _delegate = runnerDelegate;
    }
    
    return self;
}

-(void)run {
    if (_status == FWScriptRunnerRunning) {
        return;
    }
    
    _status = FWScriptRunnerRunning;
    
    if (_delegate) {
        [_delegate runner:self statusChanged:_status];
    }
    
    task = [[NSTask alloc] init];
    task.launchPath = _script;
    task.environment = NSProcessInfo.processInfo.environment;
    NSLog(@"%@", task.environment);
    task.standardInput = [[NSPipe alloc] init];
    task.standardOutput = [[NSPipe alloc] init];
    task.standardError = [[NSPipe alloc] init];
    task.arguments = @[@"-l"];
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(dataAvailable:) name:NSFileHandleReadCompletionNotification object:[task.standardOutput fileHandleForReading]];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(dataAvailable:) name:NSFileHandleReadCompletionNotification object:[task.standardError fileHandleForReading]];

    [[task.standardError fileHandleForReading] readInBackgroundAndNotify];
    [[task.standardOutput fileHandleForReading] readInBackgroundAndNotify];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(taskTerminated:) name:NSTaskDidTerminateNotification object:task];
    
    [task launch];
}

-(void)taskTerminated:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    _status = FWScriptRunnerFinished;
    
    if (_delegate) {
        [_delegate runner:self statusChanged:_status];
        [_delegate runner:self finishedWithCode:task.terminationStatus];
    }
}

-(void)dataAvailable:(NSNotification *)notification {
    NSData *data = notification.userInfo[NSFileHandleNotificationDataItem];
    if (data && data.length && _delegate) {
        NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if (notification.object == [task.standardOutput fileHandleForReading]) {
            [_delegate runner:self appendOutput:dataString];
        } else if (notification.object == [task.standardError fileHandleForReading]) {
            [_delegate runner:self appendError:dataString];
        }
    }
}

@end
