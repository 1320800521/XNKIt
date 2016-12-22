//
//  ExSelectItemsView.m
//  RongYiJu
//
//  Created by tvie on 15/5/9.
//  Copyright (c) 2015年 YangXIAOYU. All rights reserved.
//

#import "ExSelectItemsView.h"
#import "flowBtn.h"

@interface ExSelectItemsView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSMutableArray *selectedInfo;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *backgroundTouchView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *list;
@property (nonatomic, assign) flowBtn *selectedBtn;
@end

@implementation ExSelectItemsView

- (void)setupWithArr:(NSArray *)arr {
    self.items = arr;
    [self setup];
}

- (void)setup {
    CGRect frame = self.frame;
    frame.size = CGSizeMake([UIScreen mainScreen].bounds.size.width, 39);
    self.frame = frame;
    self.backgroundColor = [UIColor whiteColor];
    
    CGFloat itemWidth = frame.size.width/[self.items count];
    CGFloat itemHeight = frame.size.height;
    for (int i = 0; i < [self.items count]; i++) {
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        btn.frame = CGRectMake(itemWidth*i, 0, itemWidth, itemHeight);
//        [btn setTitle:self.items[i][@"name"] forState:UIControlStateNormal];
//        [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        
        
        flowBtn *btn = [flowBtn buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(itemWidth*i, 10, itemWidth, itemHeight);
//        [btn setTitle:self.items[i][@"name"] forState:UIControlStateNormal];
        [btn setNomeltitle:self.items[i][@"name"]];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];

        [btn setTitleColor:[UIColor colorWithRed:67.0/255 green:67.0/255 blue:67.0/255 alpha:1.0] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRed:234.0/255 green:68.0/255 blue:40.0/255 alpha:1.0] forState:UIControlStateSelected];
//        [btn setImage:[UIImage imageNamed:@"pull_down_01"] forState:UIControlStateNormal];
//        [btn setImage:[UIImage imageNamed:@"pull_down_02"] forState:UIControlStateSelected];

        
        
//        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 85, 0, 0)];
//        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
        [btn setTag:i];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        if (i) {
            UIImageView *line = [[UIImageView alloc] init];
            line.frame = CGRectMake(itemWidth*i, 0, 1, itemHeight);
            line.image = [UIImage imageNamed:@"v_line1"];
            line.contentMode = UIViewContentModeCenter;
            [self addSubview:line];
        }
    }
    UIImageView *line = [[UIImageView alloc] init];
    line.frame = CGRectMake(0, itemHeight-1, frame.size.width, 1);
    line.image = [UIImage imageNamed:@"h_line1"];
    line.contentMode = UIViewContentModeBottom;
    [self addSubview:line];
    
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < [self.items count]; i++) {
        if ([self.items[i][@"options"] count]>0) {
            NSDictionary *dic = self.items[i][@"options"][0];
             [arr addObject:dic];
        }
    }
    
    self.selectedInfo = arr;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectItemsAtLine:atIndex:andSelectInfo:)]) {
        [self.delegate selectItemsAtLine:0 atIndex:0 andSelectInfo:self.selectedInfo];
    }
}

- (void)btnAction:(flowBtn *)sender {
    if (self.selectedBtn && self.selectedBtn != sender) {
        self.selectedBtn.selected = NO;
    }
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.selectedBtn = sender;
        UIView *container = self;
//        [self.selectedBtn setselectTitle:self.items[sender.tag][@"name"]];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(getContainer)]) {
            container = [self.delegate getContainer];
        }
        
        if (!self.backgroundView) {
            self.backgroundView = [[UIView alloc] init];
        }
        self.backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        self.backgroundView.frame = container.frame;
        [container.superview addSubview:self.backgroundView];
        [self.superview bringSubviewToFront:self];
        
        self.backgroundTouchView = [[UIView alloc] init];
        self.backgroundTouchView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        self.backgroundTouchView.frame = self.backgroundView.bounds;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchAction:)];
        [self.backgroundTouchView addGestureRecognizer:tap];
        [self.backgroundView addSubview:self.backgroundTouchView];
        
        if (!self.tableView) {
            self.tableView = [[UITableView alloc] init];
            self.tableView.backgroundColor = [UIColor clearColor];
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            self.tableView.bounces = NO;
            self.tableView.delegate = self;
            self.tableView.dataSource = self;
        }
        CGRect frame = [self.backgroundView bounds];
        frame.origin.y -= frame.size.height;
        self.tableView.frame = frame;
        [self.backgroundView addSubview:self.tableView];
        
        self.list = self.items[sender.tag][@"options"];
        [UIView animateWithDuration:0.3 animations:^{
            self.backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
            CGRect f = [self.backgroundView bounds];
            f.size.height = [self.list count]*44>f.size.height?f.size.height:[self.list count]*44;
            self.tableView.frame = f;
        }];
        [self.tableView reloadData];
    } else {
        self.selectedBtn = nil;
//         [self.selectedBtn setselectTitle:self.items[sender.tag][@"name"]];
        [UIView animateWithDuration:0.3 animations:^{
            self.backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
            CGRect frame = [self.backgroundView bounds];
            frame.origin.y -= frame.size.height;
            self.tableView.frame = frame;
        } completion:^(BOOL finished) {
            [self.backgroundTouchView removeFromSuperview];
            [self.tableView removeFromSuperview];
            [self.backgroundView removeFromSuperview];
        }];
        
    }
}

- (void)touchAction:(UITapGestureRecognizer*)sender {
    [self btnAction:self.selectedBtn];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView *line = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"h_line"]];
        line.frame = CGRectMake(0, cell.frame.size.height-1, tableView.frame.size.width, 1);
        line.contentMode = UIViewContentModeBottom;
        [cell addSubview:line];
    }
    cell.textLabel.text = self.list[indexPath.row][@"name"];
    cell.textLabel.font = APP_FONT_14;
    int order = [self.list[indexPath.row][@"order"] intValue];
    int selectedOrder = [self.selectedInfo[[self.selectedBtn tag]][@"order"] intValue];
    if (order == selectedOrder) {
        cell.textLabel.textColor = [UIColor colorWithRed:234.0/255 green:68.0/255 blue:40.0/255 alpha:1.0];
    } else {
        cell.textLabel.textColor = [UIColor colorWithRed:149.0/255 green:149.0/255 blue:149.0/255 alpha:1.0];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.list[indexPath.row];
    [self.selectedInfo replaceObjectAtIndex:[self.selectedBtn tag] withObject:dic];
    NSString *name = dic[@"name"];
    if ([name isEqualToString:@"全部"] || [name isEqualToString:@"不限"]) {
        [self.selectedBtn setNomeltitle:self.items[[self.selectedBtn tag]][@"name"]];
    } else {
        if ([name length] > 6) {
            name = [NSString stringWithFormat:@"%@..",[name substringToIndex:5]];
        }
        [self.selectedBtn setNomeltitle:name];
    }
    [self btnAction:self.selectedBtn];
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectItemsAtLine:atIndex:andSelectInfo:)]) {
        [self.delegate selectItemsAtLine:0 atIndex:0 andSelectInfo:self.selectedInfo];
    }
}

@end
