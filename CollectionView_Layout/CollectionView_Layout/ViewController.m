//
//  ViewController.m
//  CollectionView_Layout
//
//  Created by mac on 16/3/13.
//  Copyright © 2016年 LS. All rights reserved.
//

#import "ViewController.h"
#import "XLPlainFlowLayout.h"
#import "TableViewController.h"
#define WIDTH self.view.bounds.size.width
@interface ViewController ()
{
    UISegmentedControl *segment;
    UIScrollView *_scrollView;
}
@end

@implementation ViewController
static NSString *cellID = @"cellID";
static NSString *headerID = @"headerID";
static NSString *footerID = @"footerID";
- (void)viewDidLoad {
    [super viewDidLoad];
    XLPlainFlowLayout *layout = [XLPlainFlowLayout new];
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.itemSize = CGSizeMake(120, 120);
    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 10;
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.dataSource = self;
    collectionView.delegate =self;
    collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:collectionView];
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellID];
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"11"];
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"22"];
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"33"];
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader  withReuseIdentifier:headerID];
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter  withReuseIdentifier:footerID];
    
//    TableViewController *controller = [[TableViewController alloc]init];
//    controller.tableView.frame = CGRectMake(0, CGRectGetMaxY(collectionView.frame), self.view.bounds.size.width, 720);
//    [self.view addSubview:controller.tableView];
//    [self addChildViewController:controller];
    
}

#pragma mark - datasource
//返回区数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 4;
}
//返回每个区的单元格数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section==3) {
        return 1;
    }
    return 9;
}
//返回单元格的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==3) {
        return CGSizeMake(self.view.bounds.size.width, 720);
    }
    return CGSizeMake(120, 120);
}
//返回单元格
- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = nil;
    if (indexPath.section==0) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    }
    else if (indexPath.section==1)
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"11" forIndexPath:indexPath];
    }
    else if (indexPath.section==2)
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"22" forIndexPath:indexPath];
    }
    else
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"33" forIndexPath:indexPath];
        _scrollView = [[UIScrollView alloc]initWithFrame:cell.contentView.bounds];
        _scrollView.contentSize = CGSizeMake(414*7, 0);
        _scrollView.backgroundColor = [UIColor grayColor];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        [cell.contentView addSubview:_scrollView];
    }
    cell.backgroundColor = [UIColor purpleColor];
    return cell;
}
//返回区头和区尾
- (UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind==UICollectionElementKindSectionHeader) {
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerID forIndexPath:indexPath];
        header.backgroundColor = [UIColor redColor];
        if (indexPath.section==3) {
            UIScrollView *scroview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, header.frame.size.height)];
            scroview.contentSize = CGSizeMake(70*7, 0);
            [header addSubview:scroview];
            NSArray *arr = @[@"推荐",@"关注",@"话题",@"今日爆款",@"新品首发",@"买家秀",@"性价比好货"];
            segment = [[UISegmentedControl alloc]initWithItems:arr];
            segment.frame = CGRectMake(0, 0, header.frame.size.width+100, header.frame.size.height);
            segment.selectedSegmentIndex = 0;
            segment.backgroundColor = [UIColor redColor];
            [segment addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventValueChanged];
            [scroview addSubview:segment];
        }
        return header;
    }
    else
    {
        UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerID forIndexPath:indexPath];
        footer.backgroundColor = [UIColor cyanColor];
        return footer;
    }
    
}
//返回区头高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section==3) {
        return CGSizeMake(0, 50);
    }
    else
    {
        return CGSizeZero;
    }

}
//返回区尾高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
   return CGSizeZero;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    segment.selectedSegmentIndex = scrollView.contentOffset.x/WIDTH;
}
- (void)segmentClick:(UISegmentedControl*)sender
{
    NSLog(@"%ld",sender.selectedSegmentIndex);
    [_scrollView setContentOffset:CGPointMake(WIDTH*sender.selectedSegmentIndex, 0) animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
