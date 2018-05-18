//
//  FWScriptRunner.h
//  FileWatch
//
//  Created by Jon Gilkison on 5/17/18.
//  Copyright © 2018 Jon Gilkison. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    FWScriptRunnerNotRun,       ///< Script hasn't been run yet
    FWScriptRunnerRunning,      ///< Script is running
    FWScriptRunnerFinished,     ///< Script has been run
} FWScriptRunnerStatus;

@protocol FWScriptRunnerDelegate;

/**
 Runs shell scripts
 */
@interface FWScriptRunner : NSObject

@property (readonly) FWScriptRunnerStatus status;       ///< Current status of the runner

@property (nullable, weak, nonatomic) id<FWScriptRunnerDelegate> delegate;      ///< Delegate
@property (nonnull, readonly) NSString *script;         ///< Full path to the script being run

/**
 Creates a new FWScriptRunner instance

 @param scriptPath Full path to the script
 @param runnerDelegate The delegate
 @return The new instance
 */
-(nonnull instancetype)initWithScript:(nonnull NSString *)scriptPath
                                 args:(nullable NSArray<NSString *> *)args
                             delegate:(nullable id<FWScriptRunnerDelegate>)runnerDelegate;

/**
 Runs the script
 */
-(void)run;

@end


/**
 Delegate for FWScriptRunner
 */
@protocol FWScriptRunnerDelegate<NSObject>

/**
 The runner's status has changed.

 @param runner The FWScriptRunner
 @param newStatus The new status
 */
-(void)runner:(nonnull FWScriptRunner *)runner statusChanged:(FWScriptRunnerStatus)newStatus;

/**
 Output has been received from the script

 @param runner The FWScriptRunner
 @param output The output text received from the script
 */
-(void)runner:(nonnull FWScriptRunner *)runner appendOutput:(nullable NSString *)output;

/**
 Error output has been received from the script
 
 @param runner The FWScriptRunner
 @param output The error output text received from the script
 */
-(void)runner:(nonnull FWScriptRunner *)runner appendError:(nullable NSString *)output;

/**
 The script has finished running for one reason or the other
 
 @param runner The FWScriptRunner
 @param code The exit code of the script
 */
-(void)runner:(nonnull FWScriptRunner *)runner finishedWithCode:(NSInteger)code;

@end
