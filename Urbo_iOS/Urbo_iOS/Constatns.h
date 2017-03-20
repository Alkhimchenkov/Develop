//
//  Constatns.h
//  ButtonOverTableView
//
//  Created by Андрей on 12.01.17.
//  Copyright © 2017 urbolabs.urbo. All rights reserved.
//

#ifndef Constatns_h
#define Constatns_h

#define COLOR_MAIN 0x323874
#define COLOR_MAIN_ADD 0x303f9f
#define COLOR_ACCENT 0xff607f
#define COLOR_MAIN_TEXT 0x212121
#define COLOR_MAIN_TEXT_ADD 0x757575
#define COLOR_FACEBOOK 0x3b5998
#define COLOR_FACEBOOK_ADD 0x425EA8
#define COLOR_GMAIL 0xD8453C
#define COLOR_GMAIL_ADD 0xCE423D




#define UIColorFromHEX(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

#define UIColorFromRGBA(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]



#endif /* Constatns_h */
