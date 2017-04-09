//
//  Created by Mimohello GmbH on 16.02.17.
//  Copyright (c) 2017 Mimohello GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController

@property (strong, nonatomic) NSString *property;
@property (nonatomic, strong) NSString *email;
@property BOOL switchColor;
- (void)setupTableView;
@end
