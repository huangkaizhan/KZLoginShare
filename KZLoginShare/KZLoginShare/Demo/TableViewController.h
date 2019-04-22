//
//  TableViewController.h
//  MamaShare
//
//  Created by huang kaizhan on 2019/1/18.
//  Copyright © 2019年 Shengcheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareTool_lib.h"

typedef enum{
    SDKTypeWeiChat,
    SDKTypeQQ,
    SDKTypeSina,
}SDKType;


@interface TableViewController : UITableViewController

/** <#zhushi#>*/
@property (nonatomic, assign) SDKType type;

@end
