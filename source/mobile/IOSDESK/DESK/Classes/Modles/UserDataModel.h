//
//  UserDataModel.h
//  DESK
//
//  Created by xingweihuang on 15/5/29.
//  Copyright (c) 2015年 FX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDataModel : NSObject
@property(nonatomic, assign) int  UserId;
@property(nonatomic, strong) NSString* Username;
@property(nonatomic, strong) NSString* Avatar;
@property(nonatomic, strong) NSString* Email;
@property(nonatomic, strong) NSString* Position;

-(instancetype)initWithUserData:(int)aUID userName:(NSString*)aUName ava:(NSString*)avatar  email:(NSString*)email  position:(NSString*)position;
@end
//-----User Manager----//
@interface UserManager : NSObject
@property(strong, atomic) UserDataModel* mainUser;
@property (strong,atomic)NSString *  session_token;
@property (strong,atomic)NSMutableDictionary * oauthStatus;
+(UserManager*)shareMainUser;

@end