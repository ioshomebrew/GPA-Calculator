//
//  AddClassViewController.m
//  GPA Calculator
//
//  Created by Beecher Adams on 8/11/16.
//  Copyright © 2016 Beecher Adams. All rights reserved.
//

#import "AddClassViewController.h"
#import "GPAClass.h"

@interface AddClassViewController ()

@end

@implementation AddClassViewController

@synthesize gradeTextField;
@synthesize data;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"Add Class";
    UIBarButtonItem *close = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(done:)];
    self.navigationItem.rightBarButtonItem = close;
    
    // init picker
    items = [[NSArray alloc] initWithObjects:@"A+ (4.33)", @"A (4.0)", @"A- (3.70)", @"B+ (3.30)", @"B (3.0)", @"B- (2.70)", @"C+ (2.30)", @"C (2.0)", @"C- (1.70)", @"D+ (1.30)", @"D (1.0)", @"D- (0.70)", @"F", nil];
    UIPickerView *picker = [[UIPickerView alloc] init];
    picker.delegate = self;
    picker.dataSource = self;
    
    // show pickerkeyboard
    self.gradeTextField.inputView = picker;
    
    // add done button
    UIToolbar *keyboardDoneButtonView = [[UIToolbar alloc] init];
    [keyboardDoneButtonView sizeToFit];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleBordered target:self
                                                                  action:@selector(doneClicked:)];
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:doneButton, nil]];
    [keyboardDoneButtonView sizeToFit];
    self.gradeTextField.inputAccessoryView = keyboardDoneButtonView;
    self.nameTextField.inputAccessoryView = keyboardDoneButtonView;
    self.unitsTextField.inputAccessoryView = keyboardDoneButtonView;
    
    // check if object is being editited
    if(self.editMode)
    {
        // then load recieved object
        self.gradeTextField.text = [self gradeFloatToText:self.data.grade];
        self.nameTextField.text = self.data.name;
        self.unitsTextField.text = [[NSString alloc] initWithFormat:@"%.2f", self.data.units];
    }
}

- (int) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (int) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [items count];
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return items[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.gradeTextField.text = items[row];
}

- (float) gradeTextToFloat:(NSString*)text
{
    NSLog(@"Test is: %@", text);
    if([items[0] isEqualToString:text])
    {
        return 4.33f;
    }
    else if([items[1] isEqualToString:text])
    {
        return 4.0f;
    }
    else if ([items[2] isEqualToString:text])
    {
        return 3.7f;
    }
    else if([items[3] isEqualToString:text])
    {
        return 3.3f;
    }
    else if([items[4] isEqualToString:text])
    {
        return 3.0f;
    }
    else if([items[5] isEqualToString:text])
    {
        return 2.7f;
    }
    else if([items[6] isEqualToString:text])
    {
        return 2.3f;
    }
    else if ([items[7] isEqualToString:text])
    {
        return 2.0f;
    }
    else if([items[8] isEqualToString:text])
    {
        return 1.7f;
    }
    else if([items[9] isEqualToString:text])
    {
        return 1.3f;
    }
    else if([items[10] isEqualToString:text])
    {
        return 1.0f;
    }
    else if([items[11] isEqualToString:text])
    {
        return 0.7f;
    }
    else if([items[12] isEqualToString:text])
    {
        return 0.0f;
    }
    
    return 0.0f;
}

- (NSString *) gradeFloatToText:(float)value
{
    if(value == 4.33f)
    {
        return items[0];
    }
    else if(value == 4.0f)
    {
        return items[1];
    }
    else if (value == 3.7f)
    {
        return items[2];
    }
    else if(value == 3.3f)
    {
        return items[3];
    }
    else if(value == 3.0f)
    {
        return items[4];
    }
    else if(value == 2.7f)
    {
        return items[5];
    }
    else if(value == 2.3f)
    {
        return items[6];
    }
    else if (value == 2.0f)
    {
        return items[7];
    }
    else if(value == 1.7f)
    {
        return items[8];
    }
    else if(value == 1.3f)
    {
        return items[9];
    }
    else if(value == 1.0f)
    {
        return items[10];
    }
    else if(value == 0.7f)
    {
        return items[11];
    }
    else if(value == 0.0f)
    {
        return items[12];
    }
    
    return @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// done for view
- (IBAction)done:(id)sender
{
    if([self.nameTextField.text  isEqual: @""] || [self.gradeTextField.text  isEqual: @""] || [self.unitsTextField.text  isEqual: @""])
    {
        
    }
    else
    {
        // send data back
        GPAClass *gpaObj = [[GPAClass alloc] init];
        gpaObj.name = self.nameTextField.text;
        gpaObj.units = self.unitsTextField.text.floatValue;
        gpaObj.grade = [self gradeTextToFloat:self.gradeTextField.text];
        gpaObj.numInArray = self.arrayNum;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Gpa" object:gpaObj];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

// done for keyboard
- (IBAction)doneClicked:(id)sender
{
    [self.nameTextField resignFirstResponder];
    [self.unitsTextField resignFirstResponder];
    [self.gradeTextField resignFirstResponder];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
