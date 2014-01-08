//
//  NSObject+Reflect.h
//  TestProject
//
//  Created by 3TI on 13-12-1.
//  Copyright (c) 2013年 3TI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Category)


@end


@interface NSObject (reflect)

-(id)initWithReflectData:(NSDictionary *)aDic;
-(NSMutableDictionary *)dictFromObject;

-(NSMutableArray *)getAttributeList;

@end


@interface NSObject (archiver)

+(id)unArchiverWithPath:(NSString *)path;
+(void)archiverWithObj:(id)obj withPath:(NSString *)path;

@end