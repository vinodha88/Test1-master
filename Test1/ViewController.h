//
//  ViewController.h
//  Test1
//
//  Created by Vinodha Sundaramoorthy on 1/20/16.
//  Copyright © 2016 Vinodha Sundaramoorthy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDataSource,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic,strong) IBOutlet UITextField *wordText;
@property (nonatomic,strong) IBOutlet UITableView *resultTableView;
@property (nonatomic,strong) IBOutlet UIPickerView *searchOptionPickerView;

@property (nonatomic,strong) NSMutableArray *resultArray;
@property (nonatomic,strong) NSArray *seacrhOptionArray;

//Methods
-(IBAction)searchAcronymns:(id)sender;

@end

