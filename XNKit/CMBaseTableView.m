//
//  YCBaseTableView.m
//  yidao_driver
//
//  Created by YongCheHui on 2016/12/15.
//  Copyright © 2016年 yongche. All rights reserved.
//

#import "CMBaseTableView.h"

@interface CMBaseTableView()
@property(nonatomic,strong) NSMutableArray* datas;
@property(nonatomic,strong) NSMutableArray* cellHeights;
@property(nonatomic,assign) Class cellCls;
@end

@implementation CMBaseTableView
-(instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)setCellCls:(Class)cellCls nib:(BOOL)nib
{
    _cellCls = cellCls;
    if (nib) {
         [self registerNib:[UINib nibWithNibName:NSStringFromClass(cellCls) bundle:nil] forCellReuseIdentifier:[self cellIdentifier]];
    }
    else
    {
         [self registerClass:cellCls forCellReuseIdentifier:[self cellIdentifier]];   
    }
}

-(Class)cellClass
{
    return _cellCls;
}

-(NSString*)cellIdentifier
{
    return [[self cellClass] cellIdentifier];
}

-(void)setup{
    _cellCls = [UITableViewCell class];
    self.datas = [NSMutableArray new];
    self.cellHeights = [NSMutableArray new];
    self.autoDeselect = YES;
    self.delegate = self;
    self.dataSource = self;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.showSection) {
        NSArray* subArray = self.datas[section];
        if (![subArray isKindOfClass:[NSArray class]]) {
            NSAssert(YES, @"showSection为YES时，必须是二级结构");
            return 0;
        }
        return subArray.count;
    }
    else
    {
        return _datas.count;
    }
}


-(id)modelWithIndexPath:(NSIndexPath*)idp
{
    if (!self.showSection) {
        return self.datas[idp.row];
    }
    else
    {
        return self.datas[idp.section][idp.row];
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [self dequeueReusableCellWithIdentifier:[self cellIdentifier] forIndexPath:indexPath];
    id model = [self modelWithIndexPath:indexPath];
    [cell yc_setIndexPath:indexPath];
    [cell yc_setModelData:model];
    if (self.refreshCell) {
        self.refreshCell(cell,model);
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (_needCacheHeights) {
        if (self.showSection) {
            return [self.cellHeights[indexPath.section][indexPath.row]floatValue];
        }
        else
        {
            return [self.cellHeights[indexPath.row] floatValue];
        }
    }
    return [[self cellClass] yc_cellHeightWithModel:[self modelWithIndexPath:indexPath]];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (!self.showSection) {
        return 0.0;
    }
    return [[self cellClass] yc_cellSectionHeaderHeightWithSection:section];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return [[self cellClass] yc_cellSectionFooterHeightWithSection:section];
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.showSectionHeaderTitle) {
        return self.sectionHeaderTitles[section];
    }
    else
    {
        return nil;
    }
}

-(NSString*)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (self.sectionFooterTitles) {
        return self.sectionFooterTitles[section];
    }
    else
    {
        return nil;
    }
}

-(BOOL)respondsToSelector:(SEL)aSelector
{
    if (aSelector == @selector(sectionIndexTitlesForTableView:)) {
        return self.showSectionRightBar;
    }
    return [super respondsToSelector:aSelector];
}

- (NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView
{
     return self.sectionRightBarTitles?self.sectionRightBarTitles:(self.sectionHeaderTitles?self.sectionHeaderTitles:self.sectionFooterTitles);
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.showSection) {
        return self.datas.count;
    }
    else
    {
        return 1;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.canEdit;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.canMove;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.editActionHandler) {
        self.editActionHandler(editingStyle,indexPath);
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    if (self.moveActionHandler) {
        self.moveActionHandler(sourceIndexPath,destinationIndexPath);
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectHanlder) {
        self.selectHanlder([self modelWithIndexPath:indexPath]);
    }
    if (self.autoDeselect) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.sectionHeaderView) {
        NSString* sectionTitle = self.sectionRightBarTitles?self.sectionRightBarTitles[section]:self.sectionHeaderTitles[section];
        return self.sectionHeaderView(section,sectionTitle);
    }
    return nil;
}

-(void)refreshHeights:(BOOL)clear datas:(NSArray*)datas
{
    if (_needCacheHeights) {
        if (clear) { //是刷新 还是添加
            [self.cellHeights removeAllObjects];
        }
        if (_showSection) {
            for (NSArray* array in datas) {
                NSMutableArray* subArray = [NSMutableArray new];
                for (id model in array) {
                    [subArray addObject:@([[self cellClass] yc_cellHeightWithModel:model])];
                }
                [self.cellHeights addObject:array];
            }
        }
        else
        {
            for (id model in datas) {
                [self.cellHeights addObject:@([[self cellClass] yc_cellHeightWithModel:model])];
            }
        }
    }
}

-(void)yc_setDatas:(NSArray*)datas
{
    self.datas = [datas mutableCopy];
    [self refreshHeights:YES datas:datas];
    [self reloadData];
}

-(void)yc_addDatas:(NSArray*)datas
{
    [self.datas addObject:datas];
    [self refreshHeights:NO datas:datas];
    [self reloadData];
}

-(void)setSectionFooterTitles:(NSArray *)sectionFooterTitles
{
    _sectionFooterTitles = sectionFooterTitles;
    self.showSectionFooterTitle = YES;
    [self reloadData];
}

-(void)setSectionHeaderTitles:(NSArray *)sectionHeaderTitles
{
    _sectionHeaderTitles = sectionHeaderTitles;
    self.showSectionHeaderTitle = YES;
    [self reloadData];
}

-(void)setSectionRightBarTitles:(NSArray *)sectionRightBarTitles
{
    _sectionRightBarTitles = sectionRightBarTitles;
    self.showSectionRightBar = YES;
    [self reloadData];
}
@end
