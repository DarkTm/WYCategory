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

#import "WYSheetController.h"
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
    
    self.view.backgroundColor = [UIColor darkGrayColor];
    
//    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 100, 100)];
//    btn.backgroundColor = [UIColor redColor];
//    
//    [btn addActionHandler:^(UIButton *btn) {
//        ;
//    }];
//    
//    [self.view addSubview:btn];
//    
//    return;
    NSString *s = [[NSString getFolderWithType:NSDocumentDirectory] stringByAppendingPathComponent:@"db.sqlite"];
    _db = [WYDatabase openDatabaseWitPath:s];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

    [self on_btn:nil];
}

- (IBAction)on_btn:(id)sender {
    
//    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 200)];
//    v.backgroundColor = [UIColor redColor];
//
//    WYSheetController *sheet = [[WYSheetController alloc] init];
//    sheet.view.backgroundColor = [UIColor clearColor];
//    
//    sheet.contentView = v;
//    [sheet customerPresentViewController];
//    
//    return;
//    [_db createTableWithSql:self.txt.text];
    NSLog(@"%@",[[[DBObject alloc] init] getAttributeList]);
    

    
    DBObject *o = [[DBObject alloc] init];
    o.name = @"tang222";
    o.age = @"222";
    o.country = @"2222";

//    [_db queryObjWithClass:[DBObject class] withSql:@"select age,country from DBObject"];
    [_db updateWithSql:@"select age,country from DBObject"];
    
//    [_db createTableWithObj:o];
//    [_db insertWithObjValue:@[o] tableName:[DBObject class]];
//    [_db insertWithSql:@"insert into dbobject (age,name,country) values ('2','ttt','zhonguo');"];
//    NSArray *dic = [_db queryWithSql:@"select * from DBObject limit 0,1" bObj:YES];
//    NSLog(@"%@",dic);
    DLog(@"%d",[_db close]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
