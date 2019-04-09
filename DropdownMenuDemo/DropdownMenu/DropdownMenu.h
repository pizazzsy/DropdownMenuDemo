//
//  DropdownMenu.h
//  smartHome_brc
//
//  Created by ra on 2019/3/21.
//  Copyright © 2019年 com.gridlink. All rights reserved.
//

#import <UIKit/UIKit.h>
//宏里的375指的是6宽度的点位，如果效果图是iPhone5为基准，请将375替换成320
#define RealValue(value) ((value)/375.0*[UIScreen mainScreen].bounds.size.width)
//封装下拉控件
NS_ASSUME_NONNULL_BEGIN
@class DropdownMenu;
@protocol DropdownMenuDelegate <NSObject>

@optional

- (void)dropdownMenuWillShow:(DropdownMenu *)menu;    // 当下拉菜单将要显示时调用
- (void)dropdownMenuDidShow:(DropdownMenu *)menu;     // 当下拉菜单已经显示时调用
- (void)dropdownMenuWillHidden:(DropdownMenu *)menu;  // 当下拉菜单将要收起时调用
- (void)dropdownMenuDidHidden:(DropdownMenu *)menu;   // 当下拉菜单已经收起时调用

- (void)dropdownMenu:(DropdownMenu *)menu selectedCellNumber:(NSInteger)number; // 当选择某个选项时调用

@end
@interface DropdownMenu : UIView<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UIButton * mainBtn;  // 主按钮 

@property (nonatomic, assign) id <DropdownMenuDelegate>delegate;
- (id)initWithFrame:(CGRect)frame andTitle:(NSString*)title;

- (void)setMenuTitles:(NSArray *)titlesArr rowHeight:(CGFloat)rowHeight;  // 设置下拉菜单控件样式

- (void)showDropDown; // 显示下拉菜单
- (void)hideDropDown; // 隐藏下拉菜单
@end

NS_ASSUME_NONNULL_END
