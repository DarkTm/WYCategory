//
//  WYDatabase.m
//  WYCategory
//
//  Created by tom on 13-12-5.
//  Copyright (c) 2013年 qiaquan. All rights reserved.
//

#import "WYDatabase.h"

@interface WYDatabase()

-(BOOL)executeWithSql:(NSString *)aSql;

-(Class)parseTableName:(NSString *)aSql;

-(NSString *)converCharToString:(char *)pChar;

-(NSMutableArray *)searchWithSql:(NSString *)aSql withClass:(Class)aClass;

-(BOOL)isTableExists:(NSString *)aTableName;

-(NSArray *)getSearchCloumnWithSql:(NSString *)aSql;

@end

const float WYDatabaseCloseRetryDuration = 10.0;

@implementation WYDatabase

+(instancetype)openDatabaseWitPath:(NSString*)aPath{
    
    WYDatabase *db = [[self alloc] initWithPath:aPath];
    
    if([db open])   return db;
    
    return nil;
}

+(instancetype)databaseWithPath:(NSString*)aPath{
    return [[self alloc] initWithPath:aPath];
}

-(instancetype)initWithPath:(NSString*)aPath{
    
    self = [super init];
    
    if(self){
    
        _isTransaction = NO;
        _dbPath = [aPath copy];
    }
    
    return self;
}

-(BOOL)open{
    
    if(_db) return YES;
    
    int err = sqlite3_open([_dbPath UTF8String], &_db);
    
    if(err != SQLITE_OK){
    
        DLog(@"【Error】 open db ! err code = %d",err);
        
        return NO;
    }
    
    return YES;
}

-(BOOL)close{

    int  rc;
    BOOL retry;
    BOOL closeStat = YES;
    int numberOfRetries = 10;
    
    do {
        retry   = NO;
        
        rc      = sqlite3_close(_db);
        
        if (SQLITE_BUSY == rc || SQLITE_LOCKED == rc) {
            
            numberOfRetries--;
            
            retry = YES;
            
            usleep(WYDatabaseCloseRetryDuration);
            
            if (!numberOfRetries) {
                
                DLog(@"【Error】 Database busy, unable to close");
                
                return NO;
            }
            
            if(closeStat){
                
                sqlite3_stmt *pStmt;
                
                closeStat = NO;
                
                while ((pStmt = sqlite3_next_stmt(_db, 0x00)) !=0) {
                    
                    DLog(@"Closing leaked statement");
                    
                    sqlite3_finalize(pStmt);
                }
            
            }

        }
        else if (SQLITE_OK != rc) {
            
            DLog(@"【Error】 closing!: %d", rc);
            
        }
    }
    while (retry);
    
    _db = nil;
    return YES;
}

#pragma  mark - 用对象来创建数据表 -

-(BOOL)createTableWithObj:(id)aObj{

    NSMutableArray *sArray = [aObj getAttributeList];
    
    NSMutableString *aSql = [NSMutableString stringWithFormat:@"create table if not exists %@ (id integer primary key autoincrement",NSStringFromClass([aObj class])];
    
    NSMutableString *subString = [NSMutableString string];
    
    for (NSString *colum in sArray) {
        
        [subString appendString:@","];
        
        [subString appendString:colum];
        
        [subString appendString:@" text"];
    }
    
    [aSql appendString:subString];
    
    [aSql appendString:@");"];
    
    return [self executeWithSql:aSql];
}

-(BOOL)createTableWithSql:(NSString *)aSql{

    return [self executeWithSql:aSql];
}

-(BOOL)insertWithSql:(NSString *)aSql{

    return [self executeWithSql:aSql];
}

-(BOOL)insertWithObjValue:(NSArray *)aValue tableName:(Class)className{

    if(aValue == nil || aValue.count == 0) {
    
        DLog(@"【Error】");
        return NO;
    }
       
    NSString *tableName = NSStringFromClass([className class]);
    
    for (id value in aValue) {
        
        NSDictionary *mDic = nil;
        
        if([value isKindOfClass:[NSDictionary class]] || [value isKindOfClass:[NSMutableDictionary class]]){
        
            mDic = value;
            
        }else{
        
            mDic = [value dictFromObject];
        }
        
        NSMutableString *aSql = [NSMutableString stringWithFormat:@"insert into  %@ (",tableName];
        
        NSMutableString *subString = [NSMutableString string];
        
        for (NSString *colum in [mDic allKeys]) {
            
            [subString appendString:colum];
            
            [subString appendString:@","];
        }
        
        subString = (NSMutableString *)[subString substringToIndex:subString.length - 1];
        
        [aSql appendString:subString];
        
        
        subString = [NSMutableString stringWithFormat:@") values ("];
        
        for (NSString *colum in [mDic allValues]) {
            
            [subString appendFormat:@"\'%@\'",colum];
            
            [subString appendString:@","];
        }
        
        subString = (NSMutableString *)[subString substringToIndex:subString.length - 1];
        
        [aSql appendString:subString];
        
        [aSql appendString:@");"];
        
        if([self executeWithSql:aSql]) continue;
        
        return NO;
    }
    
    return YES;
}

-(BOOL)deleteWithSql:(NSString *)aSql{

    return [self executeWithSql:aSql];
}

-(BOOL)updateWithSql:(NSString *)aSql{

    return [self executeWithSql:aSql];
}

#pragma  mark - 查询数据 -

-(NSMutableArray *)queryWithSql:(NSString *)aSql{
        
    NSAssert(aSql != nil && aSql.length != 0, @"【Error】 ");
    
    return [self searchWithSql:aSql withClass:nil];

}

-(NSMutableArray *)queryObjWithClass:(Class)aClass{

    return [self queryObjWithClass:aClass withSql:nil];
}

-(NSMutableArray *)queryObjWithClass:(Class)aClass withSql:(NSString *)aSql{

    NSAssert(aClass != nil && aSql != nil && aSql.length != 0, [NSString stringWithFormat:@"queryObjWithClass : class can't nil"]);
    
    return [self searchWithSql:aSql withClass:aClass];
}

-(NSMutableArray *)queryObjWithClass:(Class)aClass condition:(NSDictionary *)aCondition{

    NSAssert(aClass != nil, [NSString stringWithFormat:@"queryObjWithClass : class can't nil"]);
    
    NSMutableString *sql = [NSMutableString stringWithFormat:@"select * from %@ ",NSStringFromClass(aClass)];
    
    NSArray *keys = [aCondition allKeys];
    for (int i = 0; i < keys.count;i++){
    
        NSString *key = keys[i];
        if(i == 0){
        
            [sql appendFormat:@"where %@ = '%@'",key,aCondition[key]];
        }else{
            
            [sql appendFormat:@" and %@ = '%@'",key,aCondition[key]];
        }
        
    }
    [sql appendString:@";"];
    
    return [self searchWithSql:sql withClass:aClass];
}

-(NSString *)queryWithSql:(NSString *)aSql columnIndex:(NSInteger)aIndex{
    
    const char *err;
    sqlite3_stmt *pStmt;
    
    NSString *result = nil;
    
    if(SQLITE_OK != sqlite3_prepare_v2(_db, [aSql UTF8String], -1, &pStmt, &err)){
        
        DLog(@"【Error】 with sql : %@",aSql);
        return nil;
    }
    
    DLog(@"%@",aSql);
    
    while (SQLITE_ROW == sqlite3_step(pStmt)) {
        
        char *s = (char *)sqlite3_column_text(pStmt, aIndex);
        
        result = [self converCharToString:s];
        
        break;
    }
    
    sqlite3_finalize(pStmt);
    
    return result;
}

#pragma  mark - Transaction -

- (BOOL)beginTransaction{

    if(_isTransaction)
    {
        NSAssert(0, @"please commit pre transaction");
        return NO;
    }
    return _isTransaction = [self executeWithSql:@"begin exclusive transaction"];
}

- (BOOL)commit{

    if(_isTransaction)
    {
        NSAssert(0, @"please commit pre transaction");
        return NO;
    }
    
    return _isTransaction = [self executeWithSql:@"commit transaction"];
}

- (BOOL)rollback{
    
    if(_isTransaction)
    {
        NSAssert(0, @"please commit pre transaction");
        return NO;
    }

    return _isTransaction = [self executeWithSql:@"rollback transaction"];
}


#pragma  mark - other -

- (sqlite_int64)lastInsertRowId{
    
    return  sqlite3_last_insert_rowid(_db);
}

#pragma  mark - private method -

-(NSMutableArray *)searchWithSql:(NSString *)aSql withClass:(Class)aClass{
    
    
    NSMutableArray *sArray = [[NSMutableArray alloc] initWithCapacity:10];
    
    const char *err;
    sqlite3_stmt *pStmt;
    
    BOOL bObj = (aClass == nil ? NO : YES);
    
    
    if(SQLITE_OK != sqlite3_prepare_v2(_db, [aSql UTF8String], -1, &pStmt, &err)){
        
        DLog(@"【Error】 with sql : %@",aSql);
        return nil;
    }
    
    NSMutableArray *sAttribyte = [[NSMutableArray alloc] initWithCapacity:10];
    
    Class obj = aClass;
    
    if(bObj)
    {
        sAttribyte = [obj getAttributeList];
    }
    
    if([aSql rangeOfString:@"*"].location == NSNotFound){
        
#warning: 可以返回成 obj 对象
        bObj = NO;
        
        sAttribyte = [[NSMutableArray alloc] initWithArray:[self getSearchCloumnWithSql:aSql]];
    }
    
   
    DLog(@"%@",aSql);

    while (SQLITE_ROW == sqlite3_step(pStmt)) {
        
        NSMutableDictionary *aDic = [[NSMutableDictionary alloc] initWithCapacity:10];
        
        
        NSInteger index = 0;
        if(bObj)
            index = 1;
        for (int i = 0; i < [sAttribyte count]; i++) {
            
            char *s = (char *)sqlite3_column_text(pStmt, index + i);
            
            [aDic setValue:[self converCharToString:s] forKey:sAttribyte[i]];
        }
        
        //转换成对象
        if(bObj){
            
            [sArray addObject:[[obj alloc] initWithReflectData:aDic]];
        }else{
            
            [sArray addObject:aDic];
        }
    }
    sqlite3_finalize(pStmt);
    return sArray;
}

int sqlite3CallBack( void * para, int n_column, char ** column_value, char ** column_name ){

    char *sss = (char *)para;
    DLog(@"sqlite3CallBack [%s][%d][%s][%s]",sss,n_column,*column_value,*column_name);
    return 0;
}

-(BOOL)executeWithSql:(NSString *)aSql{

    if(aSql == nil || aSql.length == 0 || [aSql rangeOfString:@"select"].location != NSNotFound){
    
        DLog(@"bad sql : %@",aSql);
        return NO;
    }
    
    char *err;
    
    int rc = sqlite3_exec(_db, [aSql UTF8String], sqlite3CallBack, (__bridge void *)(aSql), &err);
    
    if(err){
    
        DLog(@"【Error】:%s with sql : %@",err,aSql);
        return NO;
    }
    if(rc == SQLITE_OK){
        
        DLog(@"Success with sql : %@",aSql);
    }
    return YES;
    
}

-(Class)parseTableName:(NSString *)aSql{
    
// sql 中的表名必须与对象名称一样，区别大小写
    NSString *tableName = nil;
    NSString *sql = [aSql copy];
    sql = [sql stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSRange rangeFrom = [sql rangeOfString:@"from" options:NSCaseInsensitiveSearch];
    NSRange rangeWhere = [sql rangeOfString:@"where"];
    
    if(rangeWhere.location == NSNotFound){
        
        NSRange subRange = NSMakeRange(rangeFrom.location + 4, sql.length - rangeFrom.location - 5);
        tableName = [sql substringWithRange:subRange];
    }else{
    
        NSRange subRange = NSMakeRange(rangeFrom.location, rangeWhere.location - rangeFrom.location);
        tableName = [sql substringWithRange:subRange];
    }
    
    Class rClass = NSClassFromString(tableName);
    
    return rClass;
}

-(NSArray *)getSearchCloumnWithSql:(NSString *)aSql{

    NSString *sCloumn = nil;
    NSString *sql = [aSql copy];
    sql = [sql stringByReplacingOccurrencesOfString:@" " withString:@""];

    NSRange rangeFrom = [sql rangeOfString:@"from" options:NSCaseInsensitiveSearch];
    
    @try {
        
        NSRange subRange = NSMakeRange(6, rangeFrom.location - 6);
        sCloumn = [sql substringWithRange:subRange];
        
        return [sCloumn componentsSeparatedByString:@","];
    }
    @catch (NSException *exception) {
        DLog(@"%@",exception);
        return nil;
    }
    @finally {
        
    }
}

-(NSString *)converCharToString:(char *)pChar{

    return pChar == NULL ? @"" : [NSString stringWithUTF8String:pChar];
}

-(BOOL)isTableExists:(NSString *)aTableName{

    NSString *tableName = [NSString stringWithFormat:@"select count(*) from sqlite_master where type='table' and name = '%@'",aTableName];
    
    NSString *rsult = [self queryWithSql:tableName columnIndex:0];
    
    return (rsult == nil || rsult.length == 0) ? NO : YES;
}

@end