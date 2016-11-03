//
//  ViewController.h
//  GPA Calculator
//
//  Created by Beecher Adams on 8/10/16.
//  Copyright © 2016 Beecher Adams. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <stdio.h>
@import GoogleMobileAds;

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, GADInterstitialDelegate>

@property (nonatomic, retain) NSMutableArray *classes;
@property(nonatomic, weak) IBOutlet GADBannerView *bannerView;
@property(nonatomic, strong) GADInterstitial *interstitial;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;

@end

