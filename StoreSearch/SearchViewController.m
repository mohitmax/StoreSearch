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
#import "DetailViewController.h"
#import <AFNetworking/AFNetworking.h>

static NSString* const SearchResultCellIdentifier = @"SearchResultCell";
static NSString* const NothingFoundCellIdentifier = @"NothingFoundCell";
static NSString* const LoadingCellIdentifier = @"LoadingCell";

@interface SearchViewController ()

@property (nonatomic, weak) IBOutlet UISearchBar* searchBar;
@property (nonatomic, weak) IBOutlet UITableView* tableView;
@property (nonatomic, weak) IBOutlet UISegmentedControl *segmentedControl;
@end

@implementation SearchViewController
{
    NSMutableArray* _searchResults;
    BOOL _isLoading;
    NSOperationQueue* _queue;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _queue = [[NSOperationQueue alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.contentInset = UIEdgeInsetsMake(108, 0, 0, 0);
    
    UINib *cellNib = [UINib nibWithNibName:NothingFoundCellIdentifier bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:NothingFoundCellIdentifier];
    
    UINib *searchNib = [UINib nibWithNibName:SearchResultCellIdentifier bundle:nil];
    [self.tableView registerNib:searchNib forCellReuseIdentifier:SearchResultCellIdentifier];
    
    cellNib = [UINib nibWithNibName:LoadingCellIdentifier bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:LoadingCellIdentifier];
    
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
    if (_isLoading)
    {
        return 1;
    }
    else if(_searchResults == nil)
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
    if (_isLoading)
    {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:LoadingCellIdentifier forIndexPath:indexPath];
        
        UIActivityIndicatorView* spinner = (UIActivityIndicatorView*)[cell viewWithTag:100];
        [spinner startAnimating];
        
        return cell;
    }
    
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
        [cell configureForSearchResult:searchResult];
        return cell;
    }
}

#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DetailViewController* controller = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
//    [self presentViewController:controller animated:YES completion:nil];
    
    [self.view addSubview:controller.view];
    [self addChildViewController:controller];
    [controller didMoveToParentViewController:self];
}

- (NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_searchResults.count == 0 || _isLoading)
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
    [self performSearch];
}

- (void)performSearch
{
    if (self.searchBar.text.length > 0)
    {
        [self.searchBar resignFirstResponder];
        [_queue cancelAllOperations];
        
        _isLoading = YES;
        [self.tableView reloadData];
        _searchResults = [NSMutableArray arrayWithCapacity:10];
        
//        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//        dispatch_async(queue, ^{
//            NSURL* url = [self urlWithSearchText:searchBar.text];
//            NSString* jsonString = [self performStoreRequestWithUrl:url];
//            if (jsonString == nil)
//            {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [self showNetworkError];
//                });
//                NSLog(@"Error");
//                return;
//            }
//
//            NSDictionary*  dictionary = [self parseJson:jsonString];
//            NSLog(@"Dictionary : '%@'", dictionary);
//            if(dictionary == nil)
//            {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [self showNetworkError];
//                });
//                NSLog(@"Error!");
//                return;
//            }
//
//            [self parseDictionary:dictionary];
//            [_searchResults sortUsingSelector:@selector(compareName:)];
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                _isLoading = NO;
//                [self.tableView reloadData];
//            });
//            
//            NSLog(@"DONE!");
//        });
        
        NSURL* url = [self urlWithSearchText:self.searchBar.text category:self.segmentedControl.selectedSegmentIndex];
        NSURLRequest* request = [NSURLRequest requestWithURL:url];
        
        AFHTTPRequestOperation* operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        operation.responseSerializer = [AFJSONResponseSerializer serializer];
        
        [operation setCompletionBlockWithSuccess:
            ^(AFHTTPRequestOperation *operation, id responseObject)
        {
            NSLog(@"Success! %@", responseObject);
            [self parseDictionary:responseObject];
            [_searchResults sortUsingSelector:@selector(compareName:)];
            
            _isLoading = NO;
            [self.tableView reloadData];
        }
            failure:^(AFHTTPRequestOperation *operation, NSError *error)
        {
            if(operation.isCancelled)
            {
                return;
            }
            NSLog(@"Error! %@", error);
            [self showNetworkError];
            
            _isLoading = NO;
            [self.tableView reloadData];
        }];
        
        [_queue addOperation: operation];
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


- (NSURL*)urlWithSearchText:(NSString*)searchText category:(NSInteger) category
{
    NSString* categoryName;
    switch (category)
    {
        case 0:
            categoryName = @"";
            break;
        case 1:
            categoryName = @"musicTrack";
            break;
        case 2:
            categoryName = @"software";
            break;
        case 3:
            categoryName = @"ebook";
            break;
    }
    
    NSString *escapedSearchText = [searchText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *urlString = [NSString stringWithFormat:@"http://itunes.apple.com/search?term=%@&limit=200&entity=%@", escapedSearchText, categoryName];
    NSURL *url = [NSURL URLWithString:urlString];
    
    return url;
}

#pragma mark - These 2 methods will be replaced by AFNetworking
//- (NSString*)performStoreRequestWithUrl: (NSURL*)url
//{
//    NSError* error;
//    NSString *resultString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
//    
//    if (resultString == nil)
//    {
//        NSLog(@"Download Error: %@", error);
//        return nil;
//    }
//    
//    return resultString;
//}
//
//- (NSDictionary*)parseJson:(NSString*)jsonString
//{
//    NSData* data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
//    NSError* error;
//    id resultObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
//    
//    if (resultObject == nil)
//    {
//        NSLog(@"JSON error: %@", error);
//        return nil;
//    }
//    
//    if (![resultObject isKindOfClass:[NSDictionary class]])
//    {
//        NSLog(@"JSON Error: Expected Dictionary -- SearchViewController - parseJson:jsonString");
//        return nil;
//    }
//    
//    return resultObject;
//}

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
        
        SearchResult* searchResult;
        NSString* wrapperType = resultDict[@"wrapperType"];
        NSString* kind = resultDict[@"kind"];
        
        if([wrapperType isEqualToString:@"track"])
        {
            searchResult = [self parseTrack:resultDict];
        }
        else if ([wrapperType isEqualToString:@"audiobook"])
        {
            searchResult = [self parseAudioBook:resultDict];
        }
        else if ([wrapperType isEqualToString:@"software"])
        {
            searchResult = [self parseSoftware:resultDict];
        }
        else if ([kind isEqualToString:@"ebook"])
        {
            searchResult = [self parseEBook:resultDict];
        }
        
        if(searchResult != nil)
        {
            [_searchResults addObject:searchResult];
        }
    }
}

#pragma mark - parsing different types of media

- (SearchResult*)parseTrack:(NSDictionary*)dictionary
{
    SearchResult* searchResult = [[SearchResult alloc] init];
    
    searchResult.name = dictionary[@"trackName"];
    searchResult.artistName = dictionary[@"artistName"];
    searchResult.artworkUrl60 = dictionary[@"artworkUrl60"];
    searchResult.artworkUrl100 = dictionary[@"artworkUrl100"];
    searchResult.storeUrl = dictionary[@"trackViewUrl"];
    searchResult.kind = dictionary[@"kind"];
    searchResult.price = dictionary[@"trackPrice"];
    searchResult.currency = dictionary[@"currency"];
    searchResult.genre = dictionary[@"primaryGenreName"];
    return searchResult;
}

- (SearchResult *)parseAudioBook:(NSDictionary *)dictionary
{
    SearchResult *searchResult = [[SearchResult alloc] init];
    searchResult.name = dictionary[@"collectionName"];
    searchResult.artistName = dictionary[@"artistName"];
    searchResult.artworkUrl60 = dictionary[@"artworkUrl60"];
    searchResult.artworkUrl100 = dictionary[@"artworkUrl100"];
    searchResult.storeUrl = dictionary[@"collectionViewUrl"];
    searchResult.kind = @"audiobook";
    searchResult.price = dictionary[@"collectionPrice"];
    searchResult.currency = dictionary[@"currency"];
    searchResult.genre = dictionary[@"primaryGenreName"];
    return searchResult;
}
- (SearchResult *)parseSoftware:(NSDictionary *)dictionary
{
    SearchResult *searchResult = [[SearchResult alloc] init];
    searchResult.name = dictionary[@"trackName"];
    searchResult.artistName = dictionary[@"artistName"];
    searchResult.artworkUrl60 = dictionary[@"artworkUrl60"];
    searchResult.artworkUrl100 = dictionary[@"artworkUrl100"];
    searchResult.storeUrl = dictionary[@"trackViewUrl"];
    searchResult.kind = dictionary[@"kind"];
    searchResult.price = dictionary[@"price"];
    searchResult.currency = dictionary[@"currency"];
    searchResult.genre = dictionary[@"primaryGenreName"];
    return searchResult;
}
- (SearchResult *)parseEBook:(NSDictionary *)dictionary
{
    SearchResult *searchResult = [[SearchResult alloc] init];
    searchResult.name = dictionary[@"trackName"];
    searchResult.artistName = dictionary[@"artistName"];
    searchResult.artworkUrl60 = dictionary[@"artworkUrl60"];
    searchResult.artworkUrl100 = dictionary[@"artworkUrl100"];
    searchResult.storeUrl = dictionary[@"trackViewUrl"];
    searchResult.kind = dictionary[@"kind"];
    searchResult.price = dictionary[@"price"];
    searchResult.currency = dictionary[@"currency"];
    searchResult.genre = [(NSArray *)dictionary[@"genres"]
                          componentsJoinedByString:@", "];
    return searchResult;
}

#pragma mark - IBOutlet methods

- (IBAction)segmentChanged:(UISegmentedControl *)sender
{
    NSLog(@"segment changed : %ld", (long)sender.selectedSegmentIndex);
    if (_searchResults != nil)
    {
        [self performSearch];
    }
}

@end
