//
//  AddClassViewController.h
//  GPA Calculator
//
//  Created by Beecher Adams on 8/11/16.
//  Copyright © 2016 Beecher Adams. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPAClass.h"

@interface AddClassViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>
{
    NSArray *items;
}

@property (nonatomic, retain) IBOutlet UITextField *gradeTextField;
@property (nonatomic, retain) IBOutlet UITextField *nameTextField;
@property (nonatomic, retain) IBOutlet UITextField *unitsTextField;
@property (nonatomic, assign) int arrayNum;
@property (nonatomic, assign) BOOL editMode;
@property (nonatomic, retain) GPAClass *data;

- (IBAction)done:(id)sender;

@end
