//
//  SearchViewController.m
//  StoreSearch
//
//  Created by Mohit Sadhu on 7/16/14.
//  Copyright (c) 2014 ms. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchResult.h"

@interface SearchViewController ()
@property (nonatomic, weak) IBOutlet UISearchBar* searchBar;
@property (nonatomic, weak) IBOutlet UITableView* tableView;
@end

@implementation SearchViewController
{
    NSMutableArray* _searchResults;
}

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
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma  mark - table view datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_searchResults == nil)
    {
        return 0;
    }
    else if (_searchResults.count == 0)
    {
        return 1;
    }
    else
    {
        return _searchResults.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"SearchResultCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    if(_searchResults.count == 0)
    {
        cell.textLabel.text = @"(Nothing Found)";
        cell.detailTextLabel.text = @"";
    }
    else
    {
        SearchResult* searchResult = _searchResults[indexPath.row];
        cell.textLabel.text = searchResult.name;
        cell.detailTextLabel.text = searchResult.artistName;
    }
    
    return cell;
}

#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_searchResults.count == 0)
    {
        return nil;
    }
    else
    {
        return indexPath;
    }
}

#pragma  mark - Search bar delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
    _searchResults = [NSMutableArray arrayWithCapacity:10];
    if(![searchBar.text isEqualToString:@"juju"])
    {
        for (int i = 0; i < 3; i++)
        {
            SearchResult* searchResult = [[SearchResult alloc] init];
            searchResult.name = [NSString stringWithFormat:
                                 @"Fake Result %d for '%@'", i, searchBar.text];
            searchResult.artistName = searchBar.text;
            [_searchResults addObject:searchResult];
        }
    }
    [self.tableView reloadData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    if([searchBar.text isEqual:@""])
    {
        [_searchResults removeAllObjects];
        _searchResults = nil;
        [self.tableView reloadData];
        NSLog(@"Begin editing : %@", searchBar.text);
    }
}

//This method is called when the text in the search bar changes. 
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText isEqual:@""])
    {
        [_searchResults removeAllObjects];
        _searchResults = nil;
        [self.tableView reloadData];
        NSLog(@"Nothing in the search bar");
    }
}

//This will make the search bar stretch from the top
- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar
{
    return UIBarPositionTopAttached;
}

@end
