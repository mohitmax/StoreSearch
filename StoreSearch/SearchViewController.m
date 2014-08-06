//
//  SearchViewController.m
//  StoreSearch
//
//  Created by Mohit Sadhu on 7/16/14.
//  Copyright (c) 2014 ms. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchResult.h"
#import "SearchResultCell.h"

static NSString* const SearchResultCellIdentifier = @"SearchResultCell";
static NSString* const NothingFoundCellIdentifier = @"NothingFoundCell";

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
    
    UINib *cellNib = [UINib nibWithNibName:NothingFoundCellIdentifier bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:NothingFoundCellIdentifier];
    
    UINib *searchNib = [UINib nibWithNibName:SearchResultCellIdentifier bundle:nil];
    [self.tableView registerNib:searchNib forCellReuseIdentifier:SearchResultCellIdentifier];
    
    [self.searchBar becomeFirstResponder];
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
    if(_searchResults.count == 0)
    {
       return [tableView dequeueReusableCellWithIdentifier:NothingFoundCellIdentifier
                                              forIndexPath:indexPath];
    }
    else
    {
        SearchResultCell* cell = (SearchResultCell*)[tableView dequeueReusableCellWithIdentifier:SearchResultCellIdentifier
                                                                                    forIndexPath:indexPath];
        SearchResult* searchResult = _searchResults[indexPath.row];
        cell.nameLabel.text = searchResult.name;
        cell.artistNameLabel.text = searchResult.artistName;
        return cell;
    }
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}

#pragma  mark - Search bar delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (searchBar.text.length > 0)
    {
        [searchBar resignFirstResponder];
        
        _searchResults = [NSMutableArray arrayWithCapacity:10];
        
        NSURL* url = [self urlWithSearchText:searchBar.text];
        NSLog(@"URL : '%@' ",url);
        
        NSString* jsonString = [self performStoreRequestWithUrl:url];
        NSLog(@"Received JSON string: '%@' ", jsonString);
        if (jsonString == nil)
        {
            [self showNetworkError];
            return;
        }
        
        NSDictionary*  dictionary = [self parseJson:jsonString];
        NSLog(@"Dictionary : '%@'", dictionary);
        if(dictionary == nil)
        {
            [self showNetworkError];
            return;
        }
        
        [self parseDictionary:dictionary];
        
        [self.tableView reloadData];
    }
}

- (NSURL*)urlWithSearchText:(NSString*)searchText;
{
    NSString *escapedSearchText = [searchText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *urlString = [NSString stringWithFormat:@"http://itunes.apple.com/search?term=%@", escapedSearchText];
    NSURL *url = [NSURL URLWithString:urlString];
    
    return url;
}

- (NSString*)performStoreRequestWithUrl: (NSURL*)url
{
    NSError* error;
    NSString *resultString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    
    if (resultString == nil)
    {
        NSLog(@"Download Error: %@", error);
        return nil;
    }
    
    return resultString;
}

- (NSDictionary*)parseJson:(NSString*)jsonString
{
    NSData* data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError* error;
    id resultObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    if (resultObject == nil)
    {
        NSLog(@"JSON error: %@", error);
        return nil;
    }
    
    if (![resultObject isKindOfClass:[NSDictionary class]])
    {
        NSLog(@"JSON Error: Expected Dictionary -- SearchViewController - parseJson:jsonString");
        return nil;
    }
    
    return resultObject;
}

- (void)showNetworkError
{
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Whoops.."
                                                        message:@"There was an error reading from the iTunes store. Please try again."
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil, nil];
    
    [alertView show];
}

- (void)parseDictionary:(NSDictionary*)dictionary
{
    NSArray* array = dictionary[@"results"];
    if (array == nil)
    {
        NSLog(@"Expected 'results' array");
        return;
    }
    
    for (NSDictionary* resultDict in array)
    {
        NSLog(@"wrapperType: %@, kind: %@", resultDict[@"wrapperType"], resultDict[@"kind"]);
    }
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
