//
//  ObjCPonto.h
//  PoshReVo
//
//  Created by Robin Hill on 3/22/16.
//  Copyright © 2016 Robin Hill. All rights reserved.
//

#ifndef ObjCPonto_h
#define ObjCPonto_h

@import UIKit;

// UIAppearance+Swift.h
@interface UIView (UIViewAppearance_Swift)
// appearanceWhenContainedIn: is not available in Swift. This fixes that.
+ (instancetype)nia_appearanceWhenContainedIn:(Class<UIAppearanceContainer>)containerClass;
@end

#endif /* ObjCPonto_h */
