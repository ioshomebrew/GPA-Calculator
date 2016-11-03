//
//  GPAClass.h
//  GPA Calculator
//
//  Created by Beecher Adams on 8/11/16.
//  Copyright © 2016 Beecher Adams. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GPAClass : NSObject

@property (nonatomic, retain) NSString *name;
@property (assign, nonatomic) float grade;
@property (nonatomic, assign) float units;
@property (nonatomic, assign) int numInArray;

@end
