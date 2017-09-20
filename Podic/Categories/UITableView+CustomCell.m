//
//  UITableView+CustomCell.m
//  Podic
//
//  Created by Andrew Lee on 20/09/2017.
//  Copyright © 2017 Andrew Lee. All rights reserved.
//

#import <objc/message.h>
#import "UITableView+CustomCell.h"

@implementation UITableView (CustomCell)

- (void)setCustomCellClasses:(NSArray <Class> *)customCellClasses {
    objc_setAssociatedObject(self, @selector(customCellClasses), customCellClasses, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self registerNibCustomCellClasses:customCellClasses];
}

- (NSArray *)customCellClasses {
    return objc_getAssociatedObject(self, @selector(customCellClasses));
}

- (void)registerNibCustomCellClasses:(NSArray <Class> *)customCellClasses {
    
    for(Class class in customCellClasses) {
        
        NSString *className = NSStringFromClass(class);
        [self registerNib:[UINib nibWithNibName:className bundle:nil] forCellReuseIdentifier:className];
    }
}

@end
