//
//  WYReflectBaseObject.h
//  CommonProgram
//
//  Created by 谭立栋 on 13-4-14.
//  Copyright (c) 2013年 谭立栋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYReflectBaseObject : NSObject

-(WYReflectBaseObject *)initWithData:(NSDictionary *)aDic;

-(NSMutableDictionary *)dictFromObject;

@end
