//
//  WYUncaughtExceptionHandler.h
//  CaughtExceptionHandle
//
//  Created by tom on 13-12-2.
//  Copyright (c) 2013年 tom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYUncaughtExceptionHandler : NSObject{
    BOOL dismissed;
}

@end
void HandleException(NSException *exception);
void SignalHandler(int signal);

//call in appdelegate didFinishLaunchingWithOptions
void InstallUncaughtExceptionHandler(void);