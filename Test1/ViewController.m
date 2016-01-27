//
//  ViewController.m
//  Test1
//
//  Created by Vinodha Sundaramoorthy on 1/20/16.
//  Copyright © 2016 Vinodha Sundaramoorthy. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.resultArray = [NSMutableArray array];
    self.seacrhOptionArray = @[@"Acroynyms",@"Initialisms"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)searchAcronymns:(id)sender {
    //Start progress Indicator
    [self.wordText resignFirstResponder];
    
    

    //Validate the input string and show corresponding alerts
    if (![self.wordText.text length] >0) {
        [self showMessage:@"Please enter a search criteria." withTitle:@"Warning"];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *endPoint = @"http://www.nactem.ac.uk/software/acromine/dictionary.py";
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSInteger row = [self.searchOptionPickerView selectedRowInComponent:0];
    NSString *searchOptionString  = [self.seacrhOptionArray objectAtIndex:row];
   [parameters setValue:self.wordText.text forKey: [searchOptionString isEqualToString:@"Acroynyms"] ? @"sf":@"lf"];
    
    //Session
    AFURLSessionManager *ses = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    ses.responseSerializer = [AFHTTPResponseSerializer serializer];

    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:endPoint parameters:parameters error:nil];
    NSURLSessionDataTask *dataTask = [ses dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
            self.resultArray = [NSMutableArray array];
            [self showMessage:error.localizedDescription  withTitle:@"Error"];
        } else {
            
            NSError *error1;
            NSMutableDictionary * innerJson = [NSJSONSerialization
                                               JSONObjectWithData:responseObject options:kNilOptions error:&error1];
           
            NSLog(@"Result :%@",innerJson);
            self.resultArray = [innerJson count] >0 ? [innerJson valueForKey:@"lfs"][0] : [NSMutableArray array];
            
            if ([innerJson count] == 0) {
                [self showMessage:@"No matches found , please enter a different search text." withTitle:@"Warning"];
            }
         }
        [self.resultTableView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    [dataTask resume];
}

//Table view Delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)iTableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)iTableView numberOfRowsInSection:(NSInteger)iSection {
    return [self.resultArray count];
}

- (UITableViewCell *)tableView:(UITableView *)iTableView cellForRowAtIndexPath:(NSIndexPath *)iIndexPath {
    
    NSDictionary *cellValue = [self.resultArray objectAtIndex:[iIndexPath row]];
    UITableViewCell *testTableCellView = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    testTableCellView.textLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    testTableCellView.textLabel.text = [cellValue valueForKey:@"lf"];

    testTableCellView.detailTextLabel.text  = [NSString stringWithFormat:@"Frequency : %@                              Since :%@",[cellValue valueForKey:@"freq"],[cellValue valueForKey:@"since"]];
    testTableCellView.detailTextLabel.textColor = [UIColor blueColor];
    testTableCellView.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return testTableCellView;
}

- (void)tableView:(UITableView *)iTableView didSelectRowAtIndexPath:(NSIndexPath *)iIndexPath {
    NSLog(@"Hello");
}

//Text Feild Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.wordText resignFirstResponder];
    return YES;
}

//UIPickerview delegates

- (NSInteger)numberOfComponentsInPickerView: (UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return  self.seacrhOptionArray.count;
}

/*- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.seacrhOptionArray[row];
}*/

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* lbl = (UILabel*)view;
   
    // Customise Font
    if (lbl == nil) {
        //label size
        CGRect frame = CGRectMake(0.0, 0.0, 70, 30);
        lbl = [[UILabel alloc] initWithFrame:frame];
        [lbl setBackgroundColor:[UIColor clearColor]];
        //here you can play with fonts
        [lbl setFont:[UIFont fontWithName:@"Times New Roman" size:14.0]];
        
    }
    //picker view array is the datasource
    [lbl setText:[self.seacrhOptionArray objectAtIndex:row]];
    
    return lbl;
}

//Helper method of showing alert
-(void)showMessage:(NSString*)message withTitle:(NSString *)title
{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:title
                                  message:message
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
        //do something when click button
    }];
    [alert addAction:okAction];
    UIViewController *vc = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    [vc presentViewController:alert animated:YES completion:nil];
}

@end
