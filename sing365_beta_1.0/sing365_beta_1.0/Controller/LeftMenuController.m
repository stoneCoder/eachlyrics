//
//  LeftMenuController.m
//  sing365_beta_1.0
//
//  Created by 张 磊 on 13-11-6.
//  Copyright (c) 2013年 Stone_Zl. All rights reserved.
//

#import "LeftMenuController.h"
//#import "DDMenuController.h"
#import "AppDelegate.h"
#import "AlbumsViewController.h"
#import "FFMusicController.h"
#import "SettingViewController.h"


@interface LeftMenuController ()

@end

@implementation LeftMenuController
@synthesize menuArray = _menuArray;
@synthesize selectIndex = _selectIndex;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
      
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _menuArray = [[NSArray alloc] initWithObjects:NSLocalizedString(@"firstMenu", @""),NSLocalizedString(@"secondMenu", @""),NSLocalizedString(@"thirdMenu", @""),NSLocalizedString(@"forthMenu", @""), nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*ios7适配*/
- (void) viewDidLayoutSubviews {
    if (!_selectIndex) {
        NSIndexPath *selectIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        _selectIndex = selectIndexPath;
    }
    [self.tableView selectRowAtIndexPath:_selectIndex animated:YES scrollPosition:UITableViewScrollPositionTop];
    CGRect viewBounds = self.view.bounds;
    CGFloat topBarOffset = self.topLayoutGuide.length;
    viewBounds.origin.y = topBarOffset * -1;
    self.view.bounds = viewBounds;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _menuArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [_menuArray objectAtIndex:indexPath.row];
    return cell;
}


#pragma mark - Table view delegate

 /*菜单切换*/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DDMenuController *menuController = (DDMenuController*)((AppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;
    _selectIndex = indexPath;
    if (indexPath.row == 0) {
        MainViewController *mvc = [[MainViewController alloc] initWithMusicCollection:nil];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:mvc];
        [menuController setRootController:navController animated:YES];
    }else if (indexPath.row == 1){
        AlbumsViewController *avc = [[AlbumsViewController alloc] init];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:avc];
        [menuController setRootController:navController animated:YES];
    }else if (indexPath.row == 2){
        FFMusicController *fvc = [[FFMusicController alloc] init];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:fvc];
        [menuController setRootController:navController animated:YES];
    }else if (indexPath.row == 3)
    {
        SettingViewController *svc = [[SettingViewController alloc] init];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:svc];
        [menuController setRootController:navController animated:YES];
    }
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
