//
//  UserDataModel.m
//  DESK
//
//  Created by xingweihuang on 15/5/29.
//  Copyright (c) 2015年 FX. All rights reserved.
//

#import "UserDataModel.h"

@implementation UserDataModel : NSObject
@synthesize UserId, Username,Avatar,Email,Position;

-(instancetype)init
{
    self = [super init];
    return self;
}

-(instancetype)initWithUserData:(int)aUID userName:(NSString*)aUName ava:(NSString*)ava  email:(NSString*)email position:(NSString*)position;
{
    self = [super init];
    if(self)
    {
        self.UserId = aUID;
        self.Username = aUName;
       self.Avatar = ava;
       self.Email = email;
       self.Position = position;
    }
    return self;
}
@end

//-----User Manager----//
static UserManager *pUserManagerInst = nil;

@implementation UserManager
@synthesize mainUser;

+(UserManager*)shareMainUser
{
    @synchronized(self)
    {
        if(pUserManagerInst == nil)
        {
            pUserManagerInst = [[UserManager alloc] init];
            
        }
    }
    return pUserManagerInst;
}

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        self.oauthStatus=[NSMutableDictionary dictionary];
    }
    return self;
}
@end