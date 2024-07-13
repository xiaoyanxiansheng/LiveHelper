#pragma once

#pragma comment(lib, "SPCloud.lib")

extern "C" {

	/* 描述: 云计算初始化 */
	/* 参数: iTimeout; send/recv超时时间(毫秒) */
	/* 参数: iError; 云计算错误码/状态码 */
	/* 返回: 是否初始化成功; 如果出错, 可参考iError  */
	bool  __stdcall SP_CloudInit(int iTimeout, OUT OPTIONAL int* iError);

	/* 描述: 云计算初始化 (调试模式) */
	/* 参数: szSoftwareName; 软件名 */
	/* 参数: szCard; 测试卡密 */
	/* 参数: szIP; IP地址 */
	/* 参数: wPort; 网络验证端口号 */
	/* 参数: iTimeout; send/recv超时时间(毫秒) */
	/* 参数: iError; 云计算错误码/状态码 */
	/* 返回: 是否初始化成功; 如果出错, 可参考iError  */
	bool  __stdcall SP_CloudInit_Debug(const char* szSoftwareName, const char* szCard, const char* szIP, int wPort, int iTimeout, OUT OPTIONAL int* iError);
	/* 描述: 和SP_CloudInit_Debug一样, 只是不会出现"调试模式"弹窗提示 */
	bool  __stdcall SP_CloudInit_Debug2(const char* szSoftwareName, const char* szCard, const char* szIP, int wPort, int iTimeout, OUT OPTIONAL int* iError);

	/* 描述: 云计算初始化 */
	/* 参数: szUser; 测试账号 */
	/* 参数: szPassword; 测试密码 */
	/* 参数: szIP; IP地址 */
	/* 参数: wPort; 网络验证端口号 */
	/* 参数: iTimeout; send/recv超时时间(毫秒) */
	/* 参数: iError; 云计算错误码/状态码 */
	/* 返回: 是否初始化成功; 如果出错, 可参考iError  */
	bool  __stdcall SP_CloudInit_DebugUser(const char* szSoftwareName, const char* szUser, const char* szPassword, const char* szIP, int wPort, int iTimeout, OUT OPTIONAL int* iError);
	/* 描述: 和SP_CloudInit_DebugUser一样, 只是不会出现"调试模式"弹窗提示 */
	bool  __stdcall SP_CloudInit_DebugUser2(const char* szSoftwareName, const char* szUser, const char* szPassword, const char* szIP, int wPort, int iTimeout, OUT OPTIONAL int* iError);

	/* 描述: 云计算请求 (每次调用联网) */
	/* 该函数返回true时, pOutBuffer若不为0, 则需要用户自己释放内存 SP_Cloud_Free(pOutBuffer) */
	/* 参数: dwCloudID; 云计算ID; (必须大于0) */
	/* 参数: pInBuffer; 云计算数据包指针 */
	/* 参数: dwInLength; 云计算数据包长度 */
	/* 参数: pOutBuffer; 返回的数据包数据 */
	/* 参数: dwOutLength; 返回的数据包长度 */
	/* 参数: iError; 云计算错误码/状态码 */
	/* 返回: 云计算是否成功; 如果出错, 可参考iError */
	bool  __stdcall SP_CloudComputing(IN int dwCloudID, IN OPTIONAL unsigned char* pInBuffer, IN OPTIONAL unsigned int dwInLength, OUT OPTIONAL unsigned char** pOutBuffer, OUT OPTIONAL unsigned int* dwOutLength, OUT OPTIONAL int* iError);

	/* 描述: 云计算, 频率验证 (建议创建一条线程来频繁调用, 比如30秒调用一次; 每次调用联网) */
	/* 参数: iError; 云计算错误码/状态码 */
	/* 返回: 是否验证成功; 如果出错, 可参考iError  */
	bool  __stdcall SP_Cloud_Beat(OUT OPTIONAL int* iError);

	/* 描述: 云计算, 获取当前登陆卡密所属代理名 (每次调用联网) */
	/* 参数: szAgent[44] */
	/* 参数: iError; 云计算错误码/状态码 */
	/* 返回: 是否获取成功; 如果出错, 可参考iError  */
	bool  __stdcall SP_Cloud_GetCardAgent(char szAgent[44], OUT OPTIONAL int* iError);

	/* 描述: 云计算, 获取当前登陆卡密的卡类型 (每次调用联网) */
	/* 参数: szCardType[36] */
	/* 参数: iError; 云计算错误码/状态码 */
	/* 返回: 是否获取成功; 如果出错, 可参考iError  */
	bool  __stdcall SP_Cloud_GetCardType(char szCardType[36], OUT OPTIONAL int* iError);

	/* 描述: 云计算, 获取当前登陆卡密登录时记录的IP地址 (每次调用联网) */
	/* 参数: szIPAddress[44] */
	/* 参数: iError; 云计算错误码/状态码 */
	/* 返回: 是否获取成功; 如果出错, 可参考iError  */
	bool  __stdcall SP_Cloud_GetIPAddress(char szIPAddress[44], OUT OPTIONAL int* iError);

	/* 描述: 云计算, 获取当前登陆卡密的备注 (每次调用联网) */
	/* 参数: szRemarks[132] */
	/* 参数: iError; 云计算错误码/状态码 */
	/* 返回: 是否获取成功; 如果出错, 可参考iError  */
	bool  __stdcall SP_Cloud_GetRemarks(char szRemarks[132], OUT OPTIONAL int* iError);

	/* 描述: 云计算, 获取当前登陆卡密的创建时间戳 (每次调用联网) */
	/* 参数: iCreatedTimeStamp */
	/* 参数: iError; 云计算错误码/状态码 */
	/* 返回: 是否获取成功; 如果出错, 可参考iError  */
	bool  __stdcall SP_Cloud_GetCreatedTimeStamp(__int64* iCreatedTimeStamp, OUT OPTIONAL int* iError);

	/* 描述: 云计算, 获取当前登陆卡密的激活时间戳 (每次调用联网) */
	/* 参数: iActivatedTimeStamp */
	/* 参数: iError; 云计算错误码/状态码 */
	/* 返回: 是否获取成功; 如果出错, 可参考iError  */
	bool  __stdcall SP_Cloud_GetActivatedTimeStamp(__int64* iActivatedTimeStamp, OUT OPTIONAL int* iError);

	/* 描述: 云计算, 获取当前登陆卡密的过期时间戳 (每次调用联网) */
	/* 参数: iExpiredTimeStamp */
	/* 参数: iError; 云计算错误码/状态码 */
	/* 返回: 是否获取成功; 如果出错, 可参考iError  */
	bool  __stdcall SP_Cloud_GetExpiredTimeStamp(__int64* iExpiredTimeStamp, OUT OPTIONAL int* iError);

	/* 描述: 云计算, 获取当前登陆卡密的最后登录时间戳 (每次调用联网) */
	/* 参数: iLastLoginTimeStamp */
	/* 参数: iError; 云计算错误码/状态码 */
	/* 返回: 是否获取成功; 如果出错, 可参考iError  */
	bool  __stdcall SP_Cloud_GetLastLoginTimeStamp(__int64* iLastLoginTimeStamp, OUT OPTIONAL int* iError);

	/* 描述: 云计算, 获取当前登陆卡密的剩余点数 (每次调用联网) */
	/* 参数: iFYI */
	/* 参数: iError; 云计算错误码/状态码 */
	/* 返回: 是否获取成功; 如果出错, 可参考iError  */
	bool  __stdcall SP_Cloud_GetFYI(__int64* iFYI, OUT OPTIONAL int* iError);

	/* 描述: 扣除当前卡密点数; 用于用户使用了某些特殊功能需要额外扣费的场景 (每次调用联网) */
	/* 参数：iFYICount：需要扣除的点数数量*/
	/* 参数：iSurplusFYIOUT 剩下的点数; 返回值为FALSE时, -2欲扣除点数为0或负数, -1剩余点数不足导致扣除失败; */
	/* 参数: iError; 云计算错误码/状态码 */
	/* 返回: 是否获取成功; 如果出错, 可参考iError  */
	bool __stdcall SP_Cloud_DeductFYI(__int64 iFYICount, __int64* iSurplusFYI, OUT OPTIONAL int* iError);

	/* 描述: 云计算, 获取当前登陆卡密的多开数量属性值 (每次调用联网) */
	/* 参数: iNum */
	/* 参数: iError; 云计算错误码/状态码 */
	/* 返回: 是否获取成功; 如果出错, 可参考iError  */
	bool  __stdcall SP_Cloud_GetOpenMaxNum(int* iNum, OUT OPTIONAL int* iError);

	/* 描述: 云计算, 获取当前登陆卡密的绑定机器属性值 (每次调用联网) */
	/* 参数: iBind; 是否绑机, 1/0 */
	/* 参数: iError; 云计算错误码/状态码 */
	/* 返回: 是否获取成功; 如果出错, 可参考iError  */
	bool  __stdcall SP_Cloud_GetBind(int* iBind, OUT OPTIONAL int* iError);

	/* 描述: 云计算, 获取当前登陆卡密的换绑周期 (每次调用联网) */
	/* 参数: iBindTime; (秒) */
	/* 参数: iError; 云计算错误码/状态码 */
	/* 返回: 是否获取成功; 如果出错, 可参考iError  */
	bool  __stdcall SP_Cloud_GetBindTime(__int64* iBindTime, OUT OPTIONAL int* iError);

	/* 描述: 云计算, 获取当前登陆卡密的解绑扣除属性值 (每次调用联网) */
	/* 参数: iDeductSec; (秒) */
	/* 参数: iError; 云计算错误码/状态码 */
	/* 返回: 是否获取成功; 如果出错, 可参考iError  */
	bool  __stdcall SP_Cloud_GetUnBindDeductTime(__int64* iDeductSec, OUT OPTIONAL int* iError);

	/* 描述: 云计算, 获取当前登陆卡密的最多解绑次数属性值 (每次调用联网) */
	/* 参数: iNum */
	/* 参数: iError; 云计算错误码/状态码 */
	/* 返回: 是否获取成功; 如果出错, 可参考iError  */
	bool  __stdcall SP_Cloud_GetUnBindMaxNum(int* iNum, OUT OPTIONAL int* iError);

	/* 描述: 云计算, 获取当前登陆卡密的累计解绑次数 (每次调用联网) */
	/* 参数: iCountTotal */
	/* 参数: iError; 云计算错误码/状态码 */
	/* 返回: 是否获取成功; 如果出错, 可参考iError  */
	bool  __stdcall SP_Cloud_GetUnBindCountTotal(int* iCountTotal, OUT OPTIONAL int* iError);

	/* 描述: 云计算, 获取当前登陆卡密的累计解绑扣除的时间 (每次调用联网) */
	/* 参数: iDeductTimeTotal; (秒) */
	/* 参数: iError; 云计算错误码/状态码 */
	/* 返回: 是否获取成功; 如果出错, 可参考iError  */
	bool  __stdcall SP_Cloud_GetUnBindDeductTimeTotal(__int64* iDeductTimeTotal, OUT OPTIONAL int* iError);

	/* 描述: 云计算, 移除当前云计算身份认证信息 (每次调用联网) */
	/* 参数: iError; 云计算错误码/状态码 */
	/* 返回: 下线是否成功; 如果出错, 可参考iError  */
	bool  __stdcall SP_Cloud_Offline(OUT OPTIONAL int* iError);

	/* 描述: 云计算, 获取公告内容 (每次调用联网) */
	/* 参数: szNoteices */
	/* 返回: 是否验证成功; 如果出错, 可参考iError  */
	bool  __stdcall SP_Cloud_GetNotices(char szNoteices[65535], OUT OPTIONAL int* iError);

	/* 描述: 云计算, 获取当前登陆的卡密 (SP_CloudInit 初始化成功后可用) */
	/* 参数: szCard */
	void  __stdcall SP_Cloud_GetCard(char szCard[42]);

	/* 描述: 云计算, 获取当前登陆的账号 (SP_CloudInit 初始化成功后可用) */
	/* 参数: szUser */
	void  __stdcall SP_Cloud_GetUser(char szUser[33]);

	/* 描述: 云计算, 禁用当前登陆的卡密 (SP_CloudInit 初始化成功后可用; 每次调用联网) */
	/* 参数: iError; 云计算错误码/状态码 */
	void  __stdcall SP_Cloud_DisableCard(OUT OPTIONAL int* iError);

	/* 描述: 云计算, 获取当前客户端ID (SP_CloudInit 初始化成功后可用; 每次调用联网) */
	int  __stdcall SP_Cloud_GetCID();

	/* 描述: 云计算, 获取当前卡密在线客户端数量 (SP_CloudInit 初始化成功后可用; 每次调用联网) */
	/* 参数: iError; 云计算错误码/状态码 */
	bool  __stdcall SP_Cloud_GetOnlineCount(int* iCount, OUT OPTIONAL int* iError);

	/* 描述: 云计算, 设置云计算操作系统版本标识 (SP_CloudInit 初始化之前使用) */
	/* 参数: szWinVer; 自定义操作系统版本标识, 如果为空, 则为内置逻辑获取操作系统版本 */
	bool  __stdcall SP_Cloud_SetWinVer(const char* szWinVer);

	/* 描述: 云计算, 获取网络验证登录时使用的机器码 (不联网); 注意!!! 本接口仅在使用SP_CloudInit且编译生成的软件经过SP加密后生效!!! */
	/* 参数: szPCSign[33] */
	/* 返回: 是否获取成功; 如果出错, szPCSign数据无意义;  */
	bool  __stdcall SP_Cloud_GetPCSign(char szPCSign[33]);

	/* 描述: 云计算, 获取当前登陆卡密周期内的解绑次数 (每次调用联网) */
	/* 参数: iCount */
	/* 参数: iError; 云计算错误码/状态码 */
	/* 返回: 是否获取成功; 如果出错, 可参考iError  */
	bool  __stdcall SP_Cloud_GetUnBindCount(int* iCount, OUT OPTIONAL int* iError);

	/* 描述: 云计算, 获取服务端版本配置信息 (每次调用联网) */
	/* 参数: int* bForce;		可选; 是否强制更新(1强制, 0不强制) */
	/* 参数: int* dwVer;			可选; 版本号 */
	/* 参数: int* bDirectUrl;	可选; 是否为直链(1直连, 0非直链) */
	/* 参数: char szUrl[2049];	可选; 下载地址 */
	/* 参数: char szRunExe[101];	可选; 下载后运行的exe名 */
	/* 参数: char szRunCmd[129];	可选; 下载后运行exe的参数 */
	/* 参数: int* iError;		可选; 云计算错误码/状态码 */
	/* 返回: 是否获取成功; 如果出错, 可参考iError  */
	bool  __stdcall SP_Cloud_GetUpdateInfo(
		OUT OPTIONAL int* bForce,/*			是否强制更新(BOOL) */
		OUT OPTIONAL int* dwVer,/*			版本号 */
		OUT OPTIONAL int* bDirectUrl,/*		是否为直链(BOOL) */
		OUT OPTIONAL char szUrl[2049],/*		下载地址 */
		OUT OPTIONAL char szRunExe[101],/*	下载后运行的exe名 */
		OUT OPTIONAL char szRunCmd[129],/*	下载后运行exe的参数 */
		OUT OPTIONAL int* iError);

	/* 描述: 云计算, 获取当前客户端ID (加密后, SP_CloudInit 初始化成功后可用) */
	int __stdcall SP_Cloud_GetLocalVerNumber();

	/* 描述: 云计算, 账号充值 (每次调用联网) */
	/* 参数: szUser; 被充值的账号 */
	/* 参数: szCards; 充值卡; 多个充值卡可以使用换行符分割 */
	/* 参数: iError; 云计算错误码/状态码 */
	/* 参数: szError; 可供参考的错误信息 */
	/* 返回: 是否充值成功; 如果出错, 可参考iError  */
	bool  __stdcall SP_Cloud_UserRecharge(const char* szUser, const char* szCards, OUT OPTIONAL int* iError, OUT OPTIONAL char szError[128]);

	/* 描述: 云计算, 获取频率验证总在线数量 (每次调用联网, 该功能需要在服务端 [独立软件管理] 开启) */
	/* 参数: iTotalCount; 总在线数量 */
	/* 参数: iError; 云计算错误码/状态码 */
	/* 返回: 是否获取成功; 如果出错, 可参考iError  */
	bool  __stdcall SP_Cloud_GetOnlineTotalCount(unsigned int* iTotalCount, OUT OPTIONAL int* iError);

	/* 描述: 云计算, 获取在线卡密数量 (每次调用联网, 该功能需要在服务端 [独立软件管理] 开启) */
	/* 参数: iTotalCount; 总在线数量 */
	/* 参数: iError; 云计算错误码/状态码 */
	/* 返回: 是否获取成功; 如果出错, 可参考iError  */
	/* 说明: */
	/*		比如有100张多开数量为10的卡密, 所有卡密都已登录占满多开数量 */
	/*		此时服务端拥有100*10=1000条在线链接 */
	/*		1000条在线链接中实际上是有100张在线卡密, 调用当前接口后, iTotalCount值则为100 */
	bool  __stdcall SP_Cloud_GetOnlineCardsCount(unsigned int* iTotalCount, OUT OPTIONAL int* iError);

	/* 描述: 云计算, 获取指定卡密在线链接数量 (每次调用联网) */
	/* 参数: szCard; 卡密; 填写NULL为当前登录云计算的卡密 */
	/* 参数: iTotalCount; 总在线数量 */
	/* 参数: iError; 云计算错误码/状态码 */
	/* 返回: 是否获取成功; 如果出错, 可参考iError  */
	/* 说明: */
	/*		比如有1张多开数量为10的卡密 */
	/*		此时用户使用这张卡密登录了3个客户端, 调用当前接口后, iTotalCount值则为3 */
	bool  __stdcall SP_Cloud_GetOnlineCountByCard(OPTIONAL const char* szCard, unsigned int* iTotalCount, OUT OPTIONAL int* iError);



	/* 描述：为了兼容多线程使用封装的申请内存函数*/
	void* __stdcall SP_Cloud_Malloc(int iSize);

	/* 描述：为了兼容多线程使用封装的释放内存函数*/
	void __stdcall SP_Cloud_Free(void* pBuff);
}
