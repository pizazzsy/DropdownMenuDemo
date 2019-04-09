//
//  ViewController.m
//  DropdownMenuDemo
//
//  Created by ra on 2019/4/9.
//  Copyright © 2019年 com.tyxin.patient. All rights reserved.
//

#import "ViewController.h"
#import "DropdownMenu.h"


@interface ViewController ()<DropdownMenuDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
    DropdownMenu*MenuBtn = [[DropdownMenu alloc] initWithFrame:CGRectMake(RealValue(50), RealValue(100), RealValue(180), RealValue(30)) andTitle:@"请选择"];
    [MenuBtn setMenuTitles:@[@"选择一",@"选择二",@"选择三"] rowHeight:RealValue(50)];
    MenuBtn.mainBtn.layer.borderColor=[UIColor grayColor].CGColor;
    MenuBtn.mainBtn.layer.cornerRadius=5;
    MenuBtn.delegate = self;
    [self.view addSubview:MenuBtn];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)dropdownMenu:(DropdownMenu *)menu selectedCellNumber:(NSInteger)number{
    NSLog(@"选中了第%ld行",(long)number);
}
@end
