//
//  ViewController.m
//  GPA Calculator
//
//  Created by Beecher Adams on 8/10/16.
//  Copyright © 2016 Beecher Adams. All rights reserved.
//

#import "ViewController.h"
#import "GradeViewCell.h"
#import "GPAClass.h"
#import "AddClassViewController.h"
#include <stdio.h>

@interface ViewController ()

@end

@implementation ViewController

static NSString *const kBannerAdUnitID = @"ca-app-pub-5972525945446192/4387940061";
static NSString *const kInterstitialAdUnitID = @"ca-app-pub-5972525945446192/2135112865";

@synthesize classes;
@synthesize tableView;
@synthesize toolbar;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.classes = [[NSMutableArray alloc] initWithCapacity:10];
    self.navigationItem.title = @"GPA Calculator";
    
    // ad unit
    GADRequest *request = [GADRequest request];
    request.testDevices = @[ kGADSimulatorID];
    self.bannerView.adUnitID = kBannerAdUnitID;
    self.bannerView.adSize = kGADAdSizeBanner;
    self.bannerView.rootViewController = self;
    [self.bannerView loadRequest:request];
    
    // [START firebase_interstitial_example]
    self.interstitial = [self createAndLoadInterstitial];
    
    // load grade data
    [self loadData];
    
    // add toolbar items
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, 150, 20)];
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textColor = [UIColor blackColor];
    lblTitle.textAlignment = NSTextAlignmentLeft;
    lblTitle.text = @"My GPA (0.0)";
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *typeField = [[UIBarButtonItem alloc] initWithCustomView:lblTitle];
    UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add:)];
    NSArray *items = [[NSArray alloc] initWithObjects:add, flexible, typeField, flexible, nil];
    [self.toolbar setItems:items];
    
    // notification for gpa data recieved
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addClass:)
                                                 name:@"Gpa"
                                               object:nil];
}

- (GADInterstitial *)createAndLoadInterstitial {
    GADInterstitial *interstitial = [[GADInterstitial alloc]
                                     initWithAdUnitID:kInterstitialAdUnitID];
    interstitial.delegate = self;
    [interstitial loadRequest:[GADRequest request]];
    return interstitial;
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)interstitial {
    self.interstitial = [self createAndLoadInterstitial];
}

- (IBAction)didTapInterstitialButton:(id)sender {
    if ([self.interstitial isReady]) {
        [self.interstitial presentFromRootViewController:self];
    }
}

#pragma mark - Interstitial delegate

- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error {
    // Retrying failed interstitial loads is a rudimentary way of handling these errors.
    // For more fine-grained error handling, take a look at the values in GADErrorCode.
    self.interstitial = [self createAndLoadInterstitial];
}

- (IBAction)add:(id)sender
{
    AddClassViewController *viewController = (AddClassViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"add"];
    
    // pass array num
    viewController.editMode = FALSE;
    viewController.arrayNum = (int)[self.classes count];
    
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)computeGPA {
    // recalculate gpa
    float gpa = 0.0;
    float totalGPA = 0.0;
    float totalUnits = 0.0;
    for(int i = 0; i < [self.classes count]; i++)
    {
        GPAClass *gpaObj = [self.classes objectAtIndex:i];
        totalGPA += (gpaObj.units * gpaObj.grade);
        totalUnits += gpaObj.units;
    }
    if([self.classes count] >= 1)
    {
         gpa = totalGPA / totalUnits;
    }
    
    // update uitoolbar text
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, 150, 20)];
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textColor = [UIColor blackColor];
    lblTitle.textAlignment = NSTextAlignmentLeft;
    lblTitle.text = [[NSString alloc] initWithFormat:@"My GPA (%.2f)", gpa];
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *typeField = [[UIBarButtonItem alloc] initWithCustomView:lblTitle];
    UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add:)];
    NSArray *items = [[NSArray alloc] initWithObjects:add, flexible, typeField, flexible, nil];
    [self.toolbar setItems:items];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.classes count];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // pass down gpa data
    AddClassViewController *viewController = (AddClassViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"add"];
    //AddClassViewController *viewController = add.viewControllers[0];
    
    // pass array num and data
    viewController.arrayNum = (int)indexPath.row;
    viewController.data = [self.classes objectAtIndex:indexPath.row];
    viewController.editMode = TRUE;
    
    [self presentViewController:viewController animated:YES completion:nil];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //remove the deleted object from your data source.
        //If your data source is an NSMutableArray, do this
        [self.classes removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData]; // tell table to refresh now
        
        // save data
        [self saveData];
        
        // refresh gpa
        [self computeGPA];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    GradeViewCell *cell = (GradeViewCell*)[self.tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if(cell == nil)
    {
        cell = [[GradeViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    // setup cell
    GPAClass *gpaObj = [self.classes objectAtIndex:indexPath.row];
    [cell.classTextField setText:gpaObj.name];
    [cell.unitsTextField setText:[[NSString alloc] initWithFormat:@"%.1f", gpaObj.units]];
    [cell.gradeTextField setText:[self gradeFloatToString:gpaObj.grade]];
    
    [self computeGPA];
    
    return cell;
}

- (NSString *)gradeFloatToString:(float)grade
{
    if(grade == 4.33f)
    {
        return @"A+ (4.33)";
    }
    else if(grade == 4.00f)
    {
        return @"A (4.0)";
    }
    else if(grade == 3.70f)
    {
        return @"A- (3.7)";
    }
    else if(grade == 3.3f)
    {
        return @"B+ (3.3)";
    }
    else if(grade == 3.0f)
    {
        return @"B (3.0)";
    }
    else if(grade == 2.7f)
    {
        return @"B- (2.7)";
    }
    else if(grade == 2.3f)
    {
        return @"C+ (2.3)";
    }
    else if(grade == 2.0f)
    {
        return @"C (2.0)";
    }
    else if(grade == 1.7f)
    {
        return @"C- (1.7)";
    }
    else if(grade == 1.3f)
    {
        return @"D+ (1.3)";
    }
    else if(grade == 1.0f)
    {
        return @"D (1.0)";
    }
    else if(grade == 0.7f)
    {
        return @"D- (0.7)";
    }
    else if(grade == 0.0f)
    {
        return @"F";
    }
    
    return @"";
}

- (void)addClass:(NSNotification *)data
{
    GPAClass *gpaObj = data.object;
    NSLog(@"Grade is %.2f", gpaObj.grade);
    
    // add to array
    if(gpaObj.numInArray == [self.classes count])
    {
        [self.classes addObject:gpaObj];
    }
    else
    {
        [self.classes replaceObjectAtIndex:gpaObj.numInArray withObject:gpaObj];
    }

    // recompute gpa
    [self computeGPA];
    
    // save data
    [self saveData];
    
    [self.tableView reloadData];
}

- (void)loadData
{
    // set file path
    NSString *path;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Classes.txt"];
    
    // read file
    FILE *file = fopen(path.UTF8String, "r");
    if(file != NULL)
    {
        GPAClass *obj = [[GPAClass alloc] init];
        // check for NULL
        while(!feof(file))
        {
            NSString *line = [self readLineAsNSString:file];
            // do stuff with line; line is autoreleased, so you should NOT release it (unless you also retain it beforehand)
            
            // if num in array
            if([line containsString:@"Num In Array: "])
            {
                NSRange range = NSMakeRange(14, [line length]-14);
                NSString *numStr = [line substringWithRange:range];
                int numinArray = [numStr intValue];
                NSLog(@"Numinarray is: %i", numinArray);
                obj.numInArray = numinArray;
            }
            
            // if class name
            if([line containsString:@"Name: "])
            {
                // set class name
                NSRange range = NSMakeRange(6, [line length]-6);
                NSString *name = [line substringWithRange:range];
                NSLog(@"Name is: %@", name);
                obj.name = name;
            }
            // if units
            if([line containsString:@"Units: "])
            {
                // set unit number
                NSRange range = NSMakeRange(7, [line length]-7);
                NSString *unitsStr = [line substringWithRange:range];
                float units = [unitsStr floatValue];
                NSLog(@"Units is: %.2f", units);
                obj.units = units;
            }
            // if gpa
            if([line containsString:@"GPA: "])
            {
                // set gpa
                NSRange range = NSMakeRange(5, [line length]-5);
                NSString *gpaString = [line substringWithRange:range];
                float gpa = [gpaString floatValue];
                NSLog(@"GPA is: %.2f", gpa);
                obj.grade = gpa;
            }
            
            // if obj is complete
            if([line containsString:@"End"])
            {
                NSLog(@"Obj is complete");
                [self.classes addObject:obj];
                obj = [[GPAClass alloc] init];
            }
        }
        fclose(file);
    }
    
    // reload data
    [self.tableView reloadData];
}

- (NSString *) readLineAsNSString:(FILE *) file
{
    char buffer[4096];
    
    // tune this capacity to your liking -- larger buffer sizes will be faster, but
    // use more memory
    NSMutableString *result = [NSMutableString stringWithCapacity:256];
    
    // Read up to 4095 non-newline characters, then read and discard the newline
    int charsRead;
    do
    {
        if(fscanf(file, "%4095[^\n]%n%*c", buffer, &charsRead) == 1)
            [result appendFormat:@"%s", buffer];
        else
            break;
    } while(charsRead == 4095);
    
    return result;
}

- (void)saveData
{
    // set file path
    NSFileHandle *database;
    NSMutableData *data;
    NSString *path;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Classes.txt"];
    
    // create file
    [[NSFileManager defaultManager] createFileAtPath:path
                                            contents:nil
                                          attributes:nil];
    NSLog(@"Path is %@", path);
    
    // load file
    database = [NSFileHandle fileHandleForUpdatingAtPath: path];
    if (database == nil)
        NSLog(@"Failed to open file");
    
    // start writing data
    for(int i = 0; i < [self.classes count]; i++)
    {
        // get gpa data
        GPAClass *class = [self.classes objectAtIndex:i];
        
        // write array number
        NSString *string = [[NSString alloc] initWithFormat:@"Num In Array: %i\n", i];
        data = [NSMutableData dataWithBytes:string.UTF8String length:strlen(string.UTF8String)];
        [database writeData: data];
        
        // write class name
        string = [[NSString alloc] initWithFormat:@"Name: %@\n", class.name];
        data = [NSMutableData dataWithBytes:string.UTF8String length:strlen(string.UTF8String)];
        [database writeData: data];
        
        // write units
        string = [[NSString alloc] initWithFormat:@"Units: %.2f\n", class.units];
        data = [NSMutableData dataWithBytes:string.UTF8String length:strlen(string.UTF8String)];
        [database writeData: data];
        
        // write gpa
        string = [[NSString alloc] initWithFormat:@"GPA: %.2f\n", class.grade];
        data = [NSMutableData dataWithBytes:string.UTF8String length:strlen(string.UTF8String)];
        [database writeData: data];
        
        // write new line and end
        string = @"End\n";
        data = [NSMutableData dataWithBytes:string.UTF8String length:strlen(string.UTF8String)];
        [database writeData: data];
    }
    
    // save data
    [database closeFile];
}

@end
