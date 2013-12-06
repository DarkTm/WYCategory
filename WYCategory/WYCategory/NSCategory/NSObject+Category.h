//
//  NSObject+Reflect.h
//  TestProject
//
//  Created by 3TI on 13-12-1.
//  Copyright (c) 2013年 3TI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Category)

-(id)initWithReflectData:(NSDictionary *)aDic;
-(NSMutableDictionary *)dictFromObject;

-(NSMutableArray *)getAttributeList;

+(id)unArchiverWithPath:(NSString *)path;
+(void)archiverWithObj:(id)obj withPath:(NSString *)path;

@end
