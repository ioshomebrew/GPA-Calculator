//
//  GradeViewCell.h
//  GPA Calculator
//
//  Created by Beecher Adams on 9/16/16.
//  Copyright © 2016 Beecher Adams. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GradeViewCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UITextField *classTextField;
@property (nonatomic, retain) IBOutlet UITextField *unitsTextField;
@property (nonatomic, retain) IBOutlet UITextField *gradeTextField;

@end
