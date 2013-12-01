//
//  NSObject+Reflect.h
//  TestProject
//
//  Created by 3TI on 13-12-1.
//  Copyright (c) 2013年 3TI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Reflect)

-(id)initWithReflectData:(NSDictionary *)aDic;

-(NSMutableDictionary *)dictFromObject;

@end
