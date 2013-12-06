//
//  ViewController.m
//  WYCategory
//
//  Created by tom on 13-12-6.
//  Copyright (c) 2013年 qiaquan. All rights reserved.
//

#import "ViewController.h"

#import "WYDatabase.h"
#import "WYCategory.h"

#import "DBObject.h"

@interface ViewController ()
{

    WYDatabase *_db;
}
@property (strong, nonatomic) IBOutlet UITextView *txt;
@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSString *s = [[NSString getFolderWithType:NSDocumentDirectory] stringByAppendingPathComponent:@"db.sqlite"];
    _db = [WYDatabase openDatabaseWitPath:s];
    
}
- (IBAction)on_btn:(id)sender {
        
//    [_db createTableWithSql:self.txt.text];
    NSLog(@"%@",[[[DBObject alloc] init] getAttributeList]);
    
    DBObject *o = [[DBObject alloc] init];
    o.name = @"tang1";
    o.age = @"1";
    o.country = @"sh";
    
//    [_db insertWithSql:@"insert into dbobject (age,name,country) values ('2','ttt','zhonguo');"];
//    NSArray *dic = [_db queryWithSql:@"select * from DBObject limit 0,1" bObj:YES];
//    NSLog(@"%@",dic);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
