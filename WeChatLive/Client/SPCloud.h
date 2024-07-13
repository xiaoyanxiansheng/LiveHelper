#pragma once

#pragma comment(lib, "SPCloud.lib")

extern "C" {

	/* ����: �Ƽ����ʼ�� */
	/* ����: iTimeout; send/recv��ʱʱ��(����) */
	/* ����: iError; �Ƽ��������/״̬�� */
	/* ����: �Ƿ��ʼ���ɹ�; �������, �ɲο�iError  */
	bool  __stdcall SP_CloudInit(int iTimeout, OUT OPTIONAL int* iError);

	/* ����: �Ƽ����ʼ�� (����ģʽ) */
	/* ����: szSoftwareName; ����� */
	/* ����: szCard; ���Կ��� */
	/* ����: szIP; IP��ַ */
	/* ����: wPort; ������֤�˿ں� */
	/* ����: iTimeout; send/recv��ʱʱ��(����) */
	/* ����: iError; �Ƽ��������/״̬�� */
	/* ����: �Ƿ��ʼ���ɹ�; �������, �ɲο�iError  */
	bool  __stdcall SP_CloudInit_Debug(const char* szSoftwareName, const char* szCard, const char* szIP, int wPort, int iTimeout, OUT OPTIONAL int* iError);
	/* ����: ��SP_CloudInit_Debugһ��, ֻ�ǲ������"����ģʽ"������ʾ */
	bool  __stdcall SP_CloudInit_Debug2(const char* szSoftwareName, const char* szCard, const char* szIP, int wPort, int iTimeout, OUT OPTIONAL int* iError);

	/* ����: �Ƽ����ʼ�� */
	/* ����: szUser; �����˺� */
	/* ����: szPassword; �������� */
	/* ����: szIP; IP��ַ */
	/* ����: wPort; ������֤�˿ں� */
	/* ����: iTimeout; send/recv��ʱʱ��(����) */
	/* ����: iError; �Ƽ��������/״̬�� */
	/* ����: �Ƿ��ʼ���ɹ�; �������, �ɲο�iError  */
	bool  __stdcall SP_CloudInit_DebugUser(const char* szSoftwareName, const char* szUser, const char* szPassword, const char* szIP, int wPort, int iTimeout, OUT OPTIONAL int* iError);
	/* ����: ��SP_CloudInit_DebugUserһ��, ֻ�ǲ������"����ģʽ"������ʾ */
	bool  __stdcall SP_CloudInit_DebugUser2(const char* szSoftwareName, const char* szUser, const char* szPassword, const char* szIP, int wPort, int iTimeout, OUT OPTIONAL int* iError);

	/* ����: �Ƽ������� (ÿ�ε�������) */
	/* �ú�������trueʱ, pOutBuffer����Ϊ0, ����Ҫ�û��Լ��ͷ��ڴ� SP_Cloud_Free(pOutBuffer) */
	/* ����: dwCloudID; �Ƽ���ID; (�������0) */
	/* ����: pInBuffer; �Ƽ������ݰ�ָ�� */
	/* ����: dwInLength; �Ƽ������ݰ����� */
	/* ����: pOutBuffer; ���ص����ݰ����� */
	/* ����: dwOutLength; ���ص����ݰ����� */
	/* ����: iError; �Ƽ��������/״̬�� */
	/* ����: �Ƽ����Ƿ�ɹ�; �������, �ɲο�iError */
	bool  __stdcall SP_CloudComputing(IN int dwCloudID, IN OPTIONAL unsigned char* pInBuffer, IN OPTIONAL unsigned int dwInLength, OUT OPTIONAL unsigned char** pOutBuffer, OUT OPTIONAL unsigned int* dwOutLength, OUT OPTIONAL int* iError);

	/* ����: �Ƽ���, Ƶ����֤ (���鴴��һ���߳���Ƶ������, ����30�����һ��; ÿ�ε�������) */
	/* ����: iError; �Ƽ��������/״̬�� */
	/* ����: �Ƿ���֤�ɹ�; �������, �ɲο�iError  */
	bool  __stdcall SP_Cloud_Beat(OUT OPTIONAL int* iError);

	/* ����: �Ƽ���, ��ȡ��ǰ��½�������������� (ÿ�ε�������) */
	/* ����: szAgent[44] */
	/* ����: iError; �Ƽ��������/״̬�� */
	/* ����: �Ƿ��ȡ�ɹ�; �������, �ɲο�iError  */
	bool  __stdcall SP_Cloud_GetCardAgent(char szAgent[44], OUT OPTIONAL int* iError);

	/* ����: �Ƽ���, ��ȡ��ǰ��½���ܵĿ����� (ÿ�ε�������) */
	/* ����: szCardType[36] */
	/* ����: iError; �Ƽ��������/״̬�� */
	/* ����: �Ƿ��ȡ�ɹ�; �������, �ɲο�iError  */
	bool  __stdcall SP_Cloud_GetCardType(char szCardType[36], OUT OPTIONAL int* iError);

	/* ����: �Ƽ���, ��ȡ��ǰ��½���ܵ�¼ʱ��¼��IP��ַ (ÿ�ε�������) */
	/* ����: szIPAddress[44] */
	/* ����: iError; �Ƽ��������/״̬�� */
	/* ����: �Ƿ��ȡ�ɹ�; �������, �ɲο�iError  */
	bool  __stdcall SP_Cloud_GetIPAddress(char szIPAddress[44], OUT OPTIONAL int* iError);

	/* ����: �Ƽ���, ��ȡ��ǰ��½���ܵı�ע (ÿ�ε�������) */
	/* ����: szRemarks[132] */
	/* ����: iError; �Ƽ��������/״̬�� */
	/* ����: �Ƿ��ȡ�ɹ�; �������, �ɲο�iError  */
	bool  __stdcall SP_Cloud_GetRemarks(char szRemarks[132], OUT OPTIONAL int* iError);

	/* ����: �Ƽ���, ��ȡ��ǰ��½���ܵĴ���ʱ��� (ÿ�ε�������) */
	/* ����: iCreatedTimeStamp */
	/* ����: iError; �Ƽ��������/״̬�� */
	/* ����: �Ƿ��ȡ�ɹ�; �������, �ɲο�iError  */
	bool  __stdcall SP_Cloud_GetCreatedTimeStamp(__int64* iCreatedTimeStamp, OUT OPTIONAL int* iError);

	/* ����: �Ƽ���, ��ȡ��ǰ��½���ܵļ���ʱ��� (ÿ�ε�������) */
	/* ����: iActivatedTimeStamp */
	/* ����: iError; �Ƽ��������/״̬�� */
	/* ����: �Ƿ��ȡ�ɹ�; �������, �ɲο�iError  */
	bool  __stdcall SP_Cloud_GetActivatedTimeStamp(__int64* iActivatedTimeStamp, OUT OPTIONAL int* iError);

	/* ����: �Ƽ���, ��ȡ��ǰ��½���ܵĹ���ʱ��� (ÿ�ε�������) */
	/* ����: iExpiredTimeStamp */
	/* ����: iError; �Ƽ��������/״̬�� */
	/* ����: �Ƿ��ȡ�ɹ�; �������, �ɲο�iError  */
	bool  __stdcall SP_Cloud_GetExpiredTimeStamp(__int64* iExpiredTimeStamp, OUT OPTIONAL int* iError);

	/* ����: �Ƽ���, ��ȡ��ǰ��½���ܵ�����¼ʱ��� (ÿ�ε�������) */
	/* ����: iLastLoginTimeStamp */
	/* ����: iError; �Ƽ��������/״̬�� */
	/* ����: �Ƿ��ȡ�ɹ�; �������, �ɲο�iError  */
	bool  __stdcall SP_Cloud_GetLastLoginTimeStamp(__int64* iLastLoginTimeStamp, OUT OPTIONAL int* iError);

	/* ����: �Ƽ���, ��ȡ��ǰ��½���ܵ�ʣ����� (ÿ�ε�������) */
	/* ����: iFYI */
	/* ����: iError; �Ƽ��������/״̬�� */
	/* ����: �Ƿ��ȡ�ɹ�; �������, �ɲο�iError  */
	bool  __stdcall SP_Cloud_GetFYI(__int64* iFYI, OUT OPTIONAL int* iError);

	/* ����: �۳���ǰ���ܵ���; �����û�ʹ����ĳЩ���⹦����Ҫ����۷ѵĳ��� (ÿ�ε�������) */
	/* ������iFYICount����Ҫ�۳��ĵ�������*/
	/* ������iSurplusFYIOUT ʣ�µĵ���; ����ֵΪFALSEʱ, -2���۳�����Ϊ0����, -1ʣ��������㵼�¿۳�ʧ��; */
	/* ����: iError; �Ƽ��������/״̬�� */
	/* ����: �Ƿ��ȡ�ɹ�; �������, �ɲο�iError  */
	bool __stdcall SP_Cloud_DeductFYI(__int64 iFYICount, __int64* iSurplusFYI, OUT OPTIONAL int* iError);

	/* ����: �Ƽ���, ��ȡ��ǰ��½���ܵĶ࿪��������ֵ (ÿ�ε�������) */
	/* ����: iNum */
	/* ����: iError; �Ƽ��������/״̬�� */
	/* ����: �Ƿ��ȡ�ɹ�; �������, �ɲο�iError  */
	bool  __stdcall SP_Cloud_GetOpenMaxNum(int* iNum, OUT OPTIONAL int* iError);

	/* ����: �Ƽ���, ��ȡ��ǰ��½���ܵİ󶨻�������ֵ (ÿ�ε�������) */
	/* ����: iBind; �Ƿ���, 1/0 */
	/* ����: iError; �Ƽ��������/״̬�� */
	/* ����: �Ƿ��ȡ�ɹ�; �������, �ɲο�iError  */
	bool  __stdcall SP_Cloud_GetBind(int* iBind, OUT OPTIONAL int* iError);

	/* ����: �Ƽ���, ��ȡ��ǰ��½���ܵĻ������� (ÿ�ε�������) */
	/* ����: iBindTime; (��) */
	/* ����: iError; �Ƽ��������/״̬�� */
	/* ����: �Ƿ��ȡ�ɹ�; �������, �ɲο�iError  */
	bool  __stdcall SP_Cloud_GetBindTime(__int64* iBindTime, OUT OPTIONAL int* iError);

	/* ����: �Ƽ���, ��ȡ��ǰ��½���ܵĽ��۳�����ֵ (ÿ�ε�������) */
	/* ����: iDeductSec; (��) */
	/* ����: iError; �Ƽ��������/״̬�� */
	/* ����: �Ƿ��ȡ�ɹ�; �������, �ɲο�iError  */
	bool  __stdcall SP_Cloud_GetUnBindDeductTime(__int64* iDeductSec, OUT OPTIONAL int* iError);

	/* ����: �Ƽ���, ��ȡ��ǰ��½���ܵ�������������ֵ (ÿ�ε�������) */
	/* ����: iNum */
	/* ����: iError; �Ƽ��������/״̬�� */
	/* ����: �Ƿ��ȡ�ɹ�; �������, �ɲο�iError  */
	bool  __stdcall SP_Cloud_GetUnBindMaxNum(int* iNum, OUT OPTIONAL int* iError);

	/* ����: �Ƽ���, ��ȡ��ǰ��½���ܵ��ۼƽ����� (ÿ�ε�������) */
	/* ����: iCountTotal */
	/* ����: iError; �Ƽ��������/״̬�� */
	/* ����: �Ƿ��ȡ�ɹ�; �������, �ɲο�iError  */
	bool  __stdcall SP_Cloud_GetUnBindCountTotal(int* iCountTotal, OUT OPTIONAL int* iError);

	/* ����: �Ƽ���, ��ȡ��ǰ��½���ܵ��ۼƽ��۳���ʱ�� (ÿ�ε�������) */
	/* ����: iDeductTimeTotal; (��) */
	/* ����: iError; �Ƽ��������/״̬�� */
	/* ����: �Ƿ��ȡ�ɹ�; �������, �ɲο�iError  */
	bool  __stdcall SP_Cloud_GetUnBindDeductTimeTotal(__int64* iDeductTimeTotal, OUT OPTIONAL int* iError);

	/* ����: �Ƽ���, �Ƴ���ǰ�Ƽ��������֤��Ϣ (ÿ�ε�������) */
	/* ����: iError; �Ƽ��������/״̬�� */
	/* ����: �����Ƿ�ɹ�; �������, �ɲο�iError  */
	bool  __stdcall SP_Cloud_Offline(OUT OPTIONAL int* iError);

	/* ����: �Ƽ���, ��ȡ�������� (ÿ�ε�������) */
	/* ����: szNoteices */
	/* ����: �Ƿ���֤�ɹ�; �������, �ɲο�iError  */
	bool  __stdcall SP_Cloud_GetNotices(char szNoteices[65535], OUT OPTIONAL int* iError);

	/* ����: �Ƽ���, ��ȡ��ǰ��½�Ŀ��� (SP_CloudInit ��ʼ���ɹ������) */
	/* ����: szCard */
	void  __stdcall SP_Cloud_GetCard(char szCard[42]);

	/* ����: �Ƽ���, ��ȡ��ǰ��½���˺� (SP_CloudInit ��ʼ���ɹ������) */
	/* ����: szUser */
	void  __stdcall SP_Cloud_GetUser(char szUser[33]);

	/* ����: �Ƽ���, ���õ�ǰ��½�Ŀ��� (SP_CloudInit ��ʼ���ɹ������; ÿ�ε�������) */
	/* ����: iError; �Ƽ��������/״̬�� */
	void  __stdcall SP_Cloud_DisableCard(OUT OPTIONAL int* iError);

	/* ����: �Ƽ���, ��ȡ��ǰ�ͻ���ID (SP_CloudInit ��ʼ���ɹ������; ÿ�ε�������) */
	int  __stdcall SP_Cloud_GetCID();

	/* ����: �Ƽ���, ��ȡ��ǰ�������߿ͻ������� (SP_CloudInit ��ʼ���ɹ������; ÿ�ε�������) */
	/* ����: iError; �Ƽ��������/״̬�� */
	bool  __stdcall SP_Cloud_GetOnlineCount(int* iCount, OUT OPTIONAL int* iError);

	/* ����: �Ƽ���, �����Ƽ������ϵͳ�汾��ʶ (SP_CloudInit ��ʼ��֮ǰʹ��) */
	/* ����: szWinVer; �Զ������ϵͳ�汾��ʶ, ���Ϊ��, ��Ϊ�����߼���ȡ����ϵͳ�汾 */
	bool  __stdcall SP_Cloud_SetWinVer(const char* szWinVer);

	/* ����: �Ƽ���, ��ȡ������֤��¼ʱʹ�õĻ����� (������); ע��!!! ���ӿڽ���ʹ��SP_CloudInit�ұ������ɵ��������SP���ܺ���Ч!!! */
	/* ����: szPCSign[33] */
	/* ����: �Ƿ��ȡ�ɹ�; �������, szPCSign����������;  */
	bool  __stdcall SP_Cloud_GetPCSign(char szPCSign[33]);

	/* ����: �Ƽ���, ��ȡ��ǰ��½���������ڵĽ����� (ÿ�ε�������) */
	/* ����: iCount */
	/* ����: iError; �Ƽ��������/״̬�� */
	/* ����: �Ƿ��ȡ�ɹ�; �������, �ɲο�iError  */
	bool  __stdcall SP_Cloud_GetUnBindCount(int* iCount, OUT OPTIONAL int* iError);

	/* ����: �Ƽ���, ��ȡ����˰汾������Ϣ (ÿ�ε�������) */
	/* ����: int* bForce;		��ѡ; �Ƿ�ǿ�Ƹ���(1ǿ��, 0��ǿ��) */
	/* ����: int* dwVer;			��ѡ; �汾�� */
	/* ����: int* bDirectUrl;	��ѡ; �Ƿ�Ϊֱ��(1ֱ��, 0��ֱ��) */
	/* ����: char szUrl[2049];	��ѡ; ���ص�ַ */
	/* ����: char szRunExe[101];	��ѡ; ���غ����е�exe�� */
	/* ����: char szRunCmd[129];	��ѡ; ���غ�����exe�Ĳ��� */
	/* ����: int* iError;		��ѡ; �Ƽ��������/״̬�� */
	/* ����: �Ƿ��ȡ�ɹ�; �������, �ɲο�iError  */
	bool  __stdcall SP_Cloud_GetUpdateInfo(
		OUT OPTIONAL int* bForce,/*			�Ƿ�ǿ�Ƹ���(BOOL) */
		OUT OPTIONAL int* dwVer,/*			�汾�� */
		OUT OPTIONAL int* bDirectUrl,/*		�Ƿ�Ϊֱ��(BOOL) */
		OUT OPTIONAL char szUrl[2049],/*		���ص�ַ */
		OUT OPTIONAL char szRunExe[101],/*	���غ����е�exe�� */
		OUT OPTIONAL char szRunCmd[129],/*	���غ�����exe�Ĳ��� */
		OUT OPTIONAL int* iError);

	/* ����: �Ƽ���, ��ȡ��ǰ�ͻ���ID (���ܺ�, SP_CloudInit ��ʼ���ɹ������) */
	int __stdcall SP_Cloud_GetLocalVerNumber();

	/* ����: �Ƽ���, �˺ų�ֵ (ÿ�ε�������) */
	/* ����: szUser; ����ֵ���˺� */
	/* ����: szCards; ��ֵ��; �����ֵ������ʹ�û��з��ָ� */
	/* ����: iError; �Ƽ��������/״̬�� */
	/* ����: szError; �ɹ��ο��Ĵ�����Ϣ */
	/* ����: �Ƿ��ֵ�ɹ�; �������, �ɲο�iError  */
	bool  __stdcall SP_Cloud_UserRecharge(const char* szUser, const char* szCards, OUT OPTIONAL int* iError, OUT OPTIONAL char szError[128]);

	/* ����: �Ƽ���, ��ȡƵ����֤���������� (ÿ�ε�������, �ù�����Ҫ�ڷ���� [�����������] ����) */
	/* ����: iTotalCount; ���������� */
	/* ����: iError; �Ƽ��������/״̬�� */
	/* ����: �Ƿ��ȡ�ɹ�; �������, �ɲο�iError  */
	bool  __stdcall SP_Cloud_GetOnlineTotalCount(unsigned int* iTotalCount, OUT OPTIONAL int* iError);

	/* ����: �Ƽ���, ��ȡ���߿������� (ÿ�ε�������, �ù�����Ҫ�ڷ���� [�����������] ����) */
	/* ����: iTotalCount; ���������� */
	/* ����: iError; �Ƽ��������/״̬�� */
	/* ����: �Ƿ��ȡ�ɹ�; �������, �ɲο�iError  */
	/* ˵��: */
	/*		������100�Ŷ࿪����Ϊ10�Ŀ���, ���п��ܶ��ѵ�¼ռ���࿪���� */
	/*		��ʱ�����ӵ��100*10=1000���������� */
	/*		1000������������ʵ��������100�����߿���, ���õ�ǰ�ӿں�, iTotalCountֵ��Ϊ100 */
	bool  __stdcall SP_Cloud_GetOnlineCardsCount(unsigned int* iTotalCount, OUT OPTIONAL int* iError);

	/* ����: �Ƽ���, ��ȡָ������������������ (ÿ�ε�������) */
	/* ����: szCard; ����; ��дNULLΪ��ǰ��¼�Ƽ���Ŀ��� */
	/* ����: iTotalCount; ���������� */
	/* ����: iError; �Ƽ��������/״̬�� */
	/* ����: �Ƿ��ȡ�ɹ�; �������, �ɲο�iError  */
	/* ˵��: */
	/*		������1�Ŷ࿪����Ϊ10�Ŀ��� */
	/*		��ʱ�û�ʹ�����ſ��ܵ�¼��3���ͻ���, ���õ�ǰ�ӿں�, iTotalCountֵ��Ϊ3 */
	bool  __stdcall SP_Cloud_GetOnlineCountByCard(OPTIONAL const char* szCard, unsigned int* iTotalCount, OUT OPTIONAL int* iError);



	/* ������Ϊ�˼��ݶ��߳�ʹ�÷�װ�������ڴ溯��*/
	void* __stdcall SP_Cloud_Malloc(int iSize);

	/* ������Ϊ�˼��ݶ��߳�ʹ�÷�װ���ͷ��ڴ溯��*/
	void __stdcall SP_Cloud_Free(void* pBuff);
}
