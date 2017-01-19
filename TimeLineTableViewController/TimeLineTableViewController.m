//
//  TimeLineTableViewController.m
//  loginapp
//
//  Created by Vadim on 9/21/16.
//  Copyright © 2016 Marcel Spinu. All rights reserved.
//

#import "TimeLineTableViewController.h"
#import "TimeLineTableViewCell.h"
#import "MapViewController.h"
#import "TimeLineCellViewController.h"
@interface TimeLineTableViewController () <UITableViewDataSource,UITableViewDelegate ,UITabBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *timelineTableView;

@end

@implementation TimeLineTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.timelineTableView.rowHeight = UITableViewAutomaticDimension;
    self.timelineTableView.estimatedRowHeight = 300;
    [self initTableViewWithCusstomCell];
  
}


-(void)initTableViewWithCusstomCell
{
    [self.timelineTableView registerNib:[UINib nibWithNibName:@"TimeLineTableViewCell" bundle:nil]
                                         forCellReuseIdentifier:@"cell"];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 50;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifier = @"cell";
    TimeLineTableViewCell *cell = [self.timelineTableView dequeueReusableCellWithIdentifier:identifier];
    
    cell.mapActionButton.tag=indexPath.row;
    [cell.mapActionButton addTarget:self action:@selector(showMapAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.dataLabel.text=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
    return cell;
}

-(void)showMapAction:(UIButton*)sender
{
    
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(TimeLineTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 168;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TimeLineCellViewController *timeLineCell = [self.storyboard instantiateViewControllerWithIdentifier:@"TimeLineCellViewController"];
    [self.navigationController pushViewController:timeLineCell animated:YES];
  
//   MapViewController *viewControllerB = [self.storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
//    viewControllerB.text=@"Vadim";
//    viewControllerB.mapData=[[MapData alloc]init];
//    viewControllerB.mapData.text=@"Cadim";
//    viewControllerB.mapData.userDefault =[NSUserDefaults standardUserDefaults];
//    viewControllerB.mapData.touchMapCoordinate =CLLocationCoordinate2DMake([ viewControllerB.mapData.userDefault doubleForKey:@"lat"],[viewControllerB.mapData.userDefault doubleForKey:@"long"]);
//    viewControllerB.pointAnnotation = [[MKPointAnnotation alloc] init];
//    viewControllerB.pointAnnotation.coordinate=viewControllerB.mapData.touchMapCoordinate;
//    [viewControllerB buildPathAction];
//    [self.navigationController pushViewController:viewControllerB animated:YES];
    
    
#pragma corect
//    UITabBarController *tabbarController= [self.storyboard instantiateViewControllerWithIdentifier: @"UITabBarController"];
//    tabbarController.selectedIndex=2;
//    MapViewController *c =[tabbarController.viewControllers objectAtIndex:2];
//    c.text = @"Vadim";
//      c.mapData.touchMapCoordinate =CLLocationCoordinate2DMake([ c.mapData.userDefault doubleForKey:@"lat"],[c.mapData.userDefault doubleForKey:@"long"]);
//        c.pointAnnotation.coordinate=c.mapData.touchMapCoordinate;
//    [c buildPathAction];
//    [self presentViewController: tabbarController animated: YES completion: nil];

}
@end
