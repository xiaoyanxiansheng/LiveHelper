# pyinstaller -w --add-data "GUI;GUI" --add-data "NetVerify.datkey;." --add-data "Notice.txt;." --add-data "WXHelp.dll;." --add-data "WxMaster.dll;." --add-data "WxSlave.dll;." --add-data "SPCloud.dll;." --icon=icon.ico main.py
# NK7F8D28A3A65C4BCE8A810B6B94D97656

TYPE_wxLogin = "wxLogin"
TYPE_wxLogout = "wxLogout"
TYPE_speak = "speak"
TYPE_continuousSpeak = "continuousSpeak"
TYPE_purchase = "purchase"
TYPE_autoLikes = "autoLikes"
TYPE_searchRoom = "searchRoom"
TYPE_enterRoom = "enterLiveRoom"
TYPE_operationCompleted = "operationCompleted"
TYPE_Danmu = "getBarrage"

TYPE_ERROR_SERVER = "TYPE_ERROR_SERVER"
TYPE_ERROR_CLIENT = "TYPE_ERROR_CLIENT"

TEXT_NOTICE = "Notice.txt"
TEXT_HELP = "互助发言.txt"
TEXT_USER = "快捷发言方案.txt"
TEXT_WELLCOME = "欢迎发言方案.txt"
TEXT_SCREEN = "飘屏发言.txt"

TYPE_HELP = "help"
TYPE_USER = "user"
TYPE_SCREEN = "screen"
TYPE_WELLCOME = "wellcome"

WX_COUNT_INVERVAL_3_5 = 5
WX_COUNT_INVERVAL_4_4 = 4
WX_COUNT_INVERVAL_5_3 = 3
def GetTimeInterval(count):
    if(count <= 3):
        return WX_COUNT_INVERVAL_3_5
    elif(count == 4):
        return WX_COUNT_INVERVAL_4_4
    elif(count >= 5):
        return WX_COUNT_INVERVAL_5_3