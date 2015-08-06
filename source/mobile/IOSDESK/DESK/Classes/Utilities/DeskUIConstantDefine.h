//
//  DeskUIConstantDefine.h
//  RongCloud
//

//

#ifndef RongCloud_UIConstantDefinition_h
#define RongCloud_UIConstantDefinition_h

//-----------UI-Macro Definination---------//
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]


#define IMAGENAEM(Value) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:NSLocalizedString(Value, nil) ofType:nil]]

#define IMAGE_BY_NAMED(value) [UIImage imageNamed:NSLocalizedString((value), nil)]



#define SCREEN_WIDTH ([[UIScreen mainScreen]bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen]bounds].size.height)
#define VIEW_SCREEN_HEIGHT (IOS_7?[[UIScreen mainScreen]bounds].size.height-64:[[UIScreen mainScreen]bounds].size.height-44)

#endif//RongCloud_UIConstantDefinition_h
