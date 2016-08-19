//
//  AccordianWeatherTableView.m
//  HackathonTravelPlanner
//
//  Created by Rishi Bhattacharjee on 19/08/16.
//  Copyright © 2016 IBM All rights reserved.
//

#import "AccordianWeatherTableView.h"

@interface AccordianWeatherTableView ()

@end

@implementation AccordianWeatherTableView

- (void)viewDidLoad {
    [super viewDidLoad];
    WeatherResponseParser* sharedObject = [WeatherResponseParser sharedManager];
    NSDictionary* weatherData = [sharedObject returnFinalParsedDictionary];
    dataArray = [NSMutableArray array];
    numberOfDays =[sharedObject returnNumberOfDays];
    if(numberOfDays ==0){
        [self prepareWeatherDataForDisplay:weatherData];
        for(int i=0; i<2; i++){
            AccordianTableViewHelper *prod = [[AccordianTableViewHelper alloc] init];
            if(i ==0){
            prod.name = [NSString stringWithFormat:@"%@ --%@",sharedObject.dateSelectedFromPicker,@"DayTime"];
            prod.parent = @"";
            prod.level = 0;
            prod.type  = OBJECT_TYPE_REGION;
            prod.canBeExpanded  = YES;
            }
            else{
                prod.name = [NSString stringWithFormat:@"%@ --%@",sharedObject.dateSelectedFromPicker,@"NightTime"] ;
                prod.parent = @"";
                prod.level = 0;
                prod.type  = OBJECT_TYPE_REGION;
                prod.canBeExpanded  = YES;
            }
            [dataArray addObject:prod];
            prod = nil;
        }
    }
}

-(void)prepareWeatherDataForDisplay:(NSDictionary*)weatherData{
    
    arrayNightEntryValues = [NSMutableArray arrayWithArray:[[[weatherData allValues] objectAtIndex:25] allValues]];
    [arrayNightEntryValues removeObjectAtIndex:20];
    [arrayNightEntryValues removeObjectAtIndex:21];
    [arrayNightEntryValues removeObjectAtIndex:23];
    [arrayNightEntryValues removeObjectAtIndex:24];
    arrayNightEntryKeys = [NSMutableArray arrayWithArray:[[[weatherData allValues] objectAtIndex:25] allKeys]];
    [arrayNightEntryKeys removeObjectAtIndex:20];
    [arrayNightEntryKeys removeObjectAtIndex:21];
    [arrayNightEntryKeys removeObjectAtIndex:23];
    [arrayNightEntryKeys removeObjectAtIndex:24];
    
    arrayMorningEntryValues = [NSMutableArray arrayWithArray:[weatherData allValues]];
    [arrayMorningEntryValues removeObjectAtIndex:3];
    [arrayMorningEntryValues removeObjectAtIndex:8];
    [arrayMorningEntryValues removeObjectAtIndex:9];
    [arrayMorningEntryValues removeObjectAtIndex:10];
    [arrayMorningEntryValues removeObjectAtIndex:13];
    [arrayMorningEntryValues removeObjectAtIndex:20];
    
    arrayMorningEntryKeys = [NSMutableArray arrayWithArray:[weatherData allKeys]];
    [arrayMorningEntryKeys removeObjectAtIndex:3];
    [arrayMorningEntryKeys removeObjectAtIndex:8];
    [arrayMorningEntryKeys removeObjectAtIndex:9];
    [arrayMorningEntryKeys removeObjectAtIndex:10];
    [arrayMorningEntryKeys removeObjectAtIndex:13];
    [arrayMorningEntryKeys removeObjectAtIndex:20];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
    AccordianTableViewHelper *prod = [dataArray objectAtIndex:indexPath.row];
    [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
    cell.textLabel.font = [UIFont fontWithName:@"ArialMT" size:21];
    cell.textLabel.text = prod.name;
    cell.detailTextLabel.text = prod.parent;
    cell.indentationLevel = prod.level;
    cell.indentationWidth = indendationWidth;
    // Show disclosure only if the cell can expand
    if(prod.canBeExpanded)
    {
        cell.accessoryView = [self viewForDisclosureForState:prod.isExpanded];
    }
    else
    {
        //cell.accessoryType = UITableViewCellAccessoryNone;
        cell.accessoryView = nil;
    }
    // Configure the cell...
    
    return cell;
}
-(UIView*) viewForDisclosureForState:(BOOL) isExpanded
{
    NSString *imageName;
    if(isExpanded)
    {
        imageName = @"ArrowD_blue.png";
    }
    else
    {
        imageName = @"ArrowR_blue.png";
    }
    UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    [imgView setFrame:CGRectMake(0, 6, 24, 24)];
    [myView addSubview:imgView];
    return myView;
}
// Utility class to create childrens for a selected parent class
-(void) fetchChildrenforParent:(AccordianTableViewHelper*) parentProduct withIndexPath:(NSIndexPath*)indexRow
{
    // If canBeExpanded then only we need to create child
    if(parentProduct.canBeExpanded)
    {
        // If Children are already added then no need to add again
        if([parentProduct.children count]>0)
            return;
        // The children property of the parent will be filled with this objects
        // If the parent is of type region, then fetch the location.
        if (parentProduct.type == OBJECT_TYPE_REGION) {
            if(numberOfDays ==0 && indexRow.row == 0){
                for(int i=1;i < 21; i++){
                    AccordianTableViewHelper *prod = [[AccordianTableViewHelper alloc] init];
                    prod.name = [NSString stringWithFormat:@"%@-- %@",[arrayMorningEntryKeys objectAtIndex:i],[arrayMorningEntryValues objectAtIndex:i]];
                    prod.level  = parentProduct.level +1;
                    // This is used for setting the indentation level so that it look like an accordion view
                    prod.type = OBJECT_TYPE_LOCATION;
                    prod.isExpanded = NO;
                    [parentProduct.children addObject:prod];
                    prod = nil;
                }
            }
            else {
                if(indexRow.row == 1){
                    for(int i=1;i < 32; i++){
                        AccordianTableViewHelper *prod = [[AccordianTableViewHelper alloc] init];
                        prod.name = [NSString stringWithFormat:@"%@-- %@",[arrayNightEntryKeys objectAtIndex:i],[arrayNightEntryValues objectAtIndex:i]];
                        prod.level  = parentProduct.level +1;
                        // This is used for setting the indentation level so that it look like an accordion view
                        prod.type = OBJECT_TYPE_LOCATION;
                        prod.isExpanded = NO;
                        [parentProduct.children addObject:prod];
                        prod = nil;
                    }

                }
            }
            
        }
        // If tapping on Location, fetch the users
        else{
            
            for(int i=0;i<10;i++)
            {
                AccordianTableViewHelper *prod = [[AccordianTableViewHelper alloc] init];
                prod.name = [NSString stringWithFormat:@"User %d",i];
                prod.level  = parentProduct.level +1;
                //prod.parent = [NSString stringWithFormat:@"Child %d of Level %d",i,prod.level];
                // This is used for setting the indentation level so that it look like an accordion view
                prod.type = OBJECT_TYPE_LOCATION;
                prod.isExpanded = NO;
                // Users need not expand
                prod.canBeExpanded = NO;
                [parentProduct.children addObject:prod];
            }
        }
        
    }
}


#pragma mark - Table view delegate
// Method to collapse the cell if it is already expanded
- (void)collapseCellsFromIndexOf:(AccordianTableViewHelper *)prod indexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    // Find the number of childrens opened under the parent recursively as there can be expanded children also
    int collapseCol = [self numberOfCellsToBeCollapsed:prod];
    
    // Find the range from the parent index and the length to be removed.
    NSRange collapseRange = NSMakeRange(indexPath.row+1, collapseCol);
    // Remove all the objects in that range from the main array so that number of rows are maintained properly
    [dataArray removeObjectsInRange:collapseRange];
    prod.isExpanded = NO;
    // Create index paths for the number of rows to be removed
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    for (int i = 0; i<collapseRange.length; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:collapseRange.location+i inSection:0]];
    }
    // Animate and delete
    [tableView deleteRowsAtIndexPaths:indexPaths
                     withRowAnimation:UITableViewRowAnimationLeft];
}

// Method to collapse the cell if it is already expanded
- (void)expandCellsFromIndexOf:(AccordianTableViewHelper *)prod tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    // Create dummy children
    [self fetchChildrenforParent:prod withIndexPath:indexPath];
    // Expand only if children are available
    if([prod.children count]>0)
    {
        prod.isExpanded = YES;
        int i =0;
        // Insert all the child to the main array just after the parent
        for (AccordianTableViewHelper *prod1 in prod.children) {
            [dataArray insertObject:prod1 atIndex:indexPath.row+i+1];
            i++;
        }
        // Find the range for insertion
        NSRange expandedRange = NSMakeRange(indexPath.row, i);
        NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
        // Create index paths for the range
        for (int i = 0; i<expandedRange.length; i++) {
            [indexPaths addObject:[NSIndexPath indexPathForRow:expandedRange.location+i+1 inSection:0]];
        }
        // Insert the rows
        [tableView insertRowsAtIndexPaths:indexPaths
                         withRowAnimation:UITableViewRowAnimationLeft];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AccordianTableViewHelper *prod = [dataArray objectAtIndex:indexPath.row];
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    if(prod.canBeExpanded)
    {
        
        if(prod.isExpanded)
        {
            
            [self collapseCellsFromIndexOf:prod indexPath:indexPath tableView:tableView];
            selectedCell.accessoryView = [self viewForDisclosureForState:NO];
        }
        else{
            NSLog(@"Can be expanded");
            [self expandCellsFromIndexOf:prod tableView:tableView indexPath:indexPath];
            
            selectedCell.accessoryView = [self viewForDisclosureForState:YES];
            
        }
        
    }
    
}

// Find the number of cells to be collapsed
-(int) numberOfCellsToBeCollapsed:(AccordianTableViewHelper*) products
{
    int total = 0;
    if(products.isExpanded)
    {
        // Set the expanded status to no
        products.isExpanded = NO;
        NSMutableArray *child = products.children;
        total = child.count;
        // traverse through all the children of the parent and get the count.
        for(AccordianTableViewHelper *prod in child)
        {
            total += [self numberOfCellsToBeCollapsed:prod];
        }
    }
    return total;
}

@end
