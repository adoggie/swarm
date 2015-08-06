#ifndef __SwarmErrors__
#define __SwarmErrors__

int SwarmErrors_SUCC = 0; // SUCC
int SwarmErrors_SUCC = 0; // 
int SwarmErrors_SessionExpired = 1001; // 未登录或会话过期
int SwarmErrors_TokenInvalid = 1001; // 未登录或会话过期
int SwarmErrors_InternalException = 1002; // 内部异常
int SwarmErrors_PasswdIncorret = 1003; // 密码错误
int SwarmErrors_UserNameDuplicated = 1004; // 用户名重复
int SwarmErrors_UserNameOrPasswordError = 1005; // 用户或密码错误
int SwarmErrors_PermissionDenied = 1006; // 权限禁止
int SwarmErrors_ParameterIllegal = 1007; // 参数非法
int SwarmErrors_ObjectNotExisted = 1008; // 对象不存在
int SwarmErrors_AppUnAuthorized = 5001; // app未授权
int SwarmErrors_DataInProcessing = 5002; // 请求处理中

#endif  //__SwarmErrors__