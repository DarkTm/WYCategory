//
//  WYReflectBaseObject.m
//  CommonProgram
//
//  Created by 谭立栋 on 13-4-14.
//  Copyright (c) 2013年 谭立栋. All rights reserved.
//

#import "WYReflectBaseObject.h"
#import <objc/runtime.h>

@implementation WYReflectBaseObject

-(WYReflectBaseObject *)initWithData:(NSDictionary *)aDic{

    unsigned int varCount;

    Ivar *vars = class_copyIvarList([self class], &varCount);
    
    for (unsigned int i = 0; i < varCount; i++) {
        Ivar var = vars[i];
        NSString *propertyName = [NSString stringWithFormat:@"%s",ivar_getName(var)];
        if ([propertyName hasPrefix:@"_"]) {
            propertyName =[propertyName substringWithRange:NSMakeRange(1, propertyName.length - 1)];
        }
        
        NSString *value = aDic[propertyName];
        
        if ((![value isEqual:[NSNull class]]) && value) {

            if ([value isKindOfClass:[NSArray class]]
                || [value isKindOfClass:[NSDictionary class]]
                || [value isKindOfClass:[NSMutableArray class]]
                || [value isKindOfClass:[NSMutableDictionary class]]) {
                
                NSLog(@"复合对象 %@",propertyName);
                continue;
            }
            
            NSString *propertyType = [NSString stringWithFormat:@"%s",ivar_getTypeEncoding(var)];
            if ([propertyType isEqualToString:@"@\"NSString\""]) {
                object_setIvar(self, var, [NSString stringWithFormat:@"%@",value]);
            }
        }
        
        NSLog(@"[%@] %@:%@",[self class],propertyName, object_getIvar(self, var));
    }
    free(vars);
    
    return self;
}


-(NSMutableDictionary *)dictFromObject {

    NSMutableDictionary *dictReturn = [[NSMutableDictionary alloc] init];
    
    unsigned int varCount;
    Ivar *vars = class_copyIvarList([self class], &varCount);
    
    for (unsigned int i = 0; i < varCount; i++) {
        Ivar var = vars[i];
        NSString *propertyName = [NSString stringWithFormat:@"%s",ivar_getName(var)];
        if ([propertyName hasPrefix:@"_"]) {
            propertyName =[propertyName substringWithRange:NSMakeRange(1, propertyName.length - 1)];
        }
        
        [dictReturn setValue:object_getIvar(self, var) forKey:propertyName];
    }
    free(vars);
    return dictReturn;
}

@end
