//
//  Utils.h
//  CustomerService
//
//  Created by 天龙 马 on 12-8-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

vm_size_t usedMemory(void) ;

vm_size_t freeMemory(void) ;

void logMemUsage(void) ;

@end
