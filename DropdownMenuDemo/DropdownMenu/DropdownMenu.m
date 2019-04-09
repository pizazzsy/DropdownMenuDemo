//
//  DropdownMenu.m
//  smartHome_brc
//
//  Created by ra on 2019/3/21.
//  Copyright © 2019年 com.gridlink. All rights reserved.
//

#import "DropdownMenu.h"
#define AnimateTime 0.25f   // 下拉动画时间
@implementation DropdownMenu
{
    UIImageView * _arrowMark;   // 尖头图标
    UIView      * _listView;    // 下拉列表背景View
    UITableView * _tableView;   // 下拉列表
    
    NSArray     * _titleArr;    // 选项数组
    CGFloat       _rowHeight;   // 下拉列表行高
}

- (id)initWithFrame:(CGRect)frame andTitle:(NSString*)title{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self createMainBtnWithFrame:frame andTitle:title];
    }
    return self;
}

- (void)createMainBtnWithFrame:(CGRect)frame andTitle:(NSString*)title{
    
    [_mainBtn removeFromSuperview];
    _mainBtn = nil;
    
    // 主按钮 显示在界面上的点击按钮
    // 样式可以自定义
    _mainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_mainBtn setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [_mainBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_mainBtn setTitle:title forState:UIControlStateNormal];
    [_mainBtn addTarget:self action:@selector(clickMainBtn:) forControlEvents:UIControlEventTouchUpInside];
    _mainBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _mainBtn.titleLabel.font    = [UIFont systemFontOfSize:14.f];
    _mainBtn.titleEdgeInsets    = UIEdgeInsetsMake(0, 15, 0, 0);
    _mainBtn.selected           = NO;
    _mainBtn.backgroundColor    = [UIColor whiteColor];
    _mainBtn.layer.borderColor  = [UIColor blackColor].CGColor;
    _mainBtn.layer.borderWidth  = 1;
    
    [self addSubview:_mainBtn];
    
    
    // 旋转尖头
    _arrowMark = [[UIImageView alloc] initWithFrame:CGRectMake(_mainBtn.frame.size.width - RealValue(15), 0, RealValue(9), RealValue(9))];
    _arrowMark.center = CGPointMake(_arrowMark.center.x, _mainBtn.frame.size.height/2);
    _arrowMark.image  = [UIImage imageNamed:@"login_userlist"];
    [_mainBtn addSubview:_arrowMark];
    
}


- (void)setMenuTitles:(NSArray *)titlesArr rowHeight:(CGFloat)rowHeight{
    
    if (self == nil) {
        return;
    }
    
    _titleArr  = [NSArray arrayWithArray:titlesArr];
    _rowHeight = rowHeight;
    
    
    // 下拉列表背景View
    _listView = [[UIView alloc] init];
    _listView.frame = CGRectMake(self.frame.origin.x ,self.frame.origin.y+self.frame.size.height, self.frame.size.width,  0);
    _listView.clipsToBounds       = YES;
    _listView.layer.masksToBounds = NO;
    _listView.layer.borderColor   = [UIColor grayColor].CGColor;
    _listView.layer.borderWidth   = 0.5f;
    
    
    // 下拉列表TableView
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,_listView.frame.size.width, _listView.frame.size.height)];
    _tableView.delegate        = self;
    _tableView.dataSource      = self;
    _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    _tableView.bounces         = NO;
    [_listView addSubview:_tableView];
}

- (void)clickMainBtn:(UIButton *)button{
    
    [self.superview addSubview:_listView]; // 将下拉视图添加到控件的父视图上
    
    if(button.selected == NO) {
        [self showDropDown];
    }
    else {
        [self hideDropDown];
    }
}

- (void)showDropDown{   // 显示下拉列表
    
    [_listView.superview bringSubviewToFront:_listView]; // 将下拉列表置于最上层
    
    if ([self.delegate respondsToSelector:@selector(dropdownMenuWillShow:)]) {
        [self.delegate dropdownMenuWillShow:self]; // 将要显示回调代理
    }
    
    
    [UIView animateWithDuration:AnimateTime animations:^{
        
        self->_arrowMark.transform = CGAffineTransformMakeRotation(M_PI);
        self->_listView.frame  = CGRectMake(self->_listView.frame.origin.x, self->_listView.frame.origin.y, self->_listView.frame.size.width, self->_rowHeight *self->_titleArr.count);
        self->_tableView.frame = CGRectMake(0, 0, self->_listView.frame.size.width, self->_listView.frame.size.height);
        
    }completion:^(BOOL finished) {
        
        if ([self.delegate respondsToSelector:@selector(dropdownMenuDidShow:)]) {
            [self.delegate dropdownMenuDidShow:self]; // 已经显示回调代理
        }
    }];
    
    
    _mainBtn.selected = YES;
}
- (void)hideDropDown{  // 隐藏下拉列表
    
    if ([self.delegate respondsToSelector:@selector(dropdownMenuWillHidden:)]) {
        [self.delegate dropdownMenuWillHidden:self]; // 将要隐藏回调代理
    }
    
    [UIView animateWithDuration:AnimateTime animations:^{
        
        self->_arrowMark.transform = CGAffineTransformIdentity;
        self->_listView.frame  = CGRectMake(self->_listView.frame.origin.x,self->_listView.frame.origin.y, self->_listView.frame.size.width, 0);
        self->_tableView.frame = CGRectMake(0, 0, self->_listView.frame.size.width, self->_listView.frame.size.height);
        
    }completion:^(BOOL finished) {
        
        if ([self.delegate respondsToSelector:@selector(dropdownMenuDidHidden:)]) {
            [self.delegate dropdownMenuDidHidden:self]; // 已经隐藏回调代理
        }
    }];
    
    
    _mainBtn.selected = NO;
}

#pragma mark - UITableView Delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _rowHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_titleArr count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //---------------------------下拉选项样式，可在此处自定义-------------------------
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.font          = [UIFont systemFontOfSize:11.f];
        cell.textLabel.textColor     = [UIColor blackColor];
        cell.selectionStyle          = UITableViewCellSelectionStyleNone;
        
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, _rowHeight -0.5, cell.frame.size.width, 0.5)];
        line.backgroundColor = [UIColor grayColor];
        [cell addSubview:line];
        //---------------------------------------------------------------------------
    }
    
    cell.textLabel.text =[_titleArr objectAtIndex:indexPath.row];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [_mainBtn setTitle:cell.textLabel.text forState:UIControlStateNormal];
    
    if ([self.delegate respondsToSelector:@selector(dropdownMenu:selectedCellNumber:)]) {
        [self.delegate dropdownMenu:self selectedCellNumber:indexPath.row]; // 回调代理
    }
    
    [self hideDropDown];
}


@end
