import random
from tkinter import Tk, messagebox
from SPCloud import GetExpiredTimeStamp
from Server import *
from WXHelpDLL import*
from PyQt5.QtCore import pyqtSignal, QObject
import threading

class Worker(QObject):
    resultReady = pyqtSignal(int, str)

    def Sync(self, clientId, msgData):
        self.resultReady.emit(clientId, msgData)

class UIMain():
    def __init__(self, uiRoot, data, server, wxhelper):
        self.Data = data
        self.server = server
        self.wxhelper = wxhelper

        self.Data.cardInfo.expiredDatetime = GetExpiredTimeStamp()

        self.wellComeContenIndex = 0
        self.wellComeConten = {"123", "456", "789"}
        self.wellComeToggle = False
        self.wellComeReplyToggle = False
        self.wellComeTime = 0
        self.wellComeTimeInverval = 2

        self.changeNickNameTime = 0

        self.screenTime = 0
        self.screenTimeInverval = 2
        self.scrrenToggle = False

        self.likeToggle = False
        self.likeToggleTime = 0
        self.likeToggleTimeInverval = 2

        self.buyToggle = False
        self.buyTime = 0
        self.buyTimeInverval = 2

        self.helpToggle = False
        self.helpTime = 0
        self.helpTimeInverval = 2

        self.danmuToggle = False
        self.danmuTime = 0
        self.danmuTimeInverval = 2

        self.uiRoot = uiRoot
        self.uiRoot.signalTest.connect(self.signalTest)
        self.uiRoot.clickdOpenWeChat.connect(self.ClickOpenWeChat)
        self.uiRoot.clickSearchLiveByName.connect(self.ClickSearchLiveByName)
        self.uiRoot.clickSendUserMsg.connect(self.ClickSendUserMsg)
        self.uiRoot.likeToggle.connect(self.LikeToggle)
        self.uiRoot.likeTimeRefresh.connect(self.LikeTimeRefresh)
        self.uiRoot.buyToggle.connect(self.BuyToggle)
        self.uiRoot.buyTimeRefresh.connect(self.BuyTimeRefresh)
        self.uiRoot.wellComeToggle.connect(self.WellComeToggle)
        self.uiRoot.wellComeReplayToggle.connect(self.WellComeReplayToggle)
        self.uiRoot.wellComeReplayTimeRefresh.connect(self.WellComeReplayTimeRefresh)
        self.uiRoot.screenToggle.connect(self.ScreenToggle)
        self.uiRoot.screenTimeRefresh.connect(self.ScreenTimeRefresh)
        self.uiRoot.helpToggle.connect(self.HelpToggle)
        self.uiRoot.helpTimeRefresh.connect(self.HelpTimeRefresh)
        self.uiRoot.danmuToggle.connect(self.DanmuToggle)
        self.uiRoot.clickHelpSelectIndex.connect(self.ClickHelpSelectIndex)
        self.uiRoot.clickScreenSelectIndex.connect(self.ClickScreenSelectIndex)
        self.uiRoot.helpContentChange.connect(self.HelpContentChange)
        self.uiRoot.helpTitleChange.connect(self.HelpTitleChange)
        self.uiRoot.screenContentChange.connect(self.ScreenContentChange)
        self.uiRoot.screenTitleChange.connect(self.ScreenTitleChange)
        self.uiRoot.selectFile.connect(self.SelectFile)
        self.uiRoot.clickEnterLiveByName.connect(self.ClickEnterLiveByName)
        self.uiRoot.clickSaveHelp.connect(self.ClickSaveHelp)
        self.uiRoot.clickSaveScreen.connect(self.ClickSaveScreen)

        self.startTimer()

        self.wxhelper.WXHelpDLL_CallRecvHandler(self.CallRecvHandlerCall)

        self.worker = Worker()
        self.worker.resultReady.connect(self.handle_result)

        self.RefreshTopInfo()
        self.RefreshUserLogin()
        self.RefreshLive()
        self.RefreshWellCome()
        self.RefreshScreen()
        self.RefreshLikeBuy()
        self.RefreshHelp()
        self.RefreshDanmu()

    def startTimer(self):
        self.timer = threading.Timer(1.0, self.Update)
        self.timer.start()

    def SelectFile(self, type, filePath):
        try:
            self.Data.ReadDataByType(type, filePath)
            self.RefreshHelp()
            self.RefreshUserLogin()
            self.RefreshScreen()
            self.RefreshWellCome()
        except Exception as e:
            print(f"Error selecting file: {e}")

    def CallRecvHandlerCall(self, clientId, msgData):
        try:
            self.worker.Sync(clientId, msgData)
        except Exception as e:
            print(f"Error in CallRecvHandlerCall: {e}")

    def handle_result(self, clientId, msgData):
        try:
            if msgData == TYPE_wxLogin or msgData == TYPE_wxLogout:
                self.RefreshUserLogin()
                return
            
            type = self.wxhelper.WXParseInstruction(self.Data, clientId, msgData)
            if type == TYPE_wxLogin:
                self.RefreshUserLogin()
            elif type == TYPE_wxLogout:
                self.RefreshUserLogin()
            elif type == TYPE_Danmu:
                self.RefreshDanmu()
            elif type == TYPE_autoLikes:
                pass
            elif type == TYPE_continuousSpeak:
                pass
            elif type == TYPE_purchase:
                pass
            elif type == TYPE_speak:
                pass
            elif type == TYPE_searchRoom:
                self.RefreshLive()
        except Exception as e:
            print(f"Error in handle_result: {e}")

    def signalTest(self):
        pass

    def ClickOpenWeChat(self):
        try:
            self.wxhelper.openWechatMutexTwo()
        except Exception as e:
            print(f"Error opening WeChat: {e}")

    def ClickSearchLiveByName(self, liveName):
        liveName = liveName.strip()
        if (not liveName in self.server.bindLiveNames) and liveName != "" :
            # TODO 需要增加服务器接口 搜索到直播间后绑定
            self.BindLiveName(liveName)

    def BindLiveName(self , liveName):
        result = messagebox.askyesno("直播间绑定", "搜到到直播间【{0}】，是否绑定？".format(liveName))
        if result:
            self.server.BindBindLiveName(liveName)
            self.RefreshSearchLiveComboBox()
        else:
            pass

    def ClickEnterLiveByName(self, liveName):
        try:
            userData = self.Data.GetRandomUser()
            if userData:
                self.server.WXSearchRoom(userData.client, liveName)
        except Exception as e:
            print(f"Error searching live by name: {e}")

    def ClickSendUserMsg(self, index, content):
        try:
            userData = self.Data.GetUsers()[index]
            if userData:
                self.server.WXSpeak(userData.client, content)
        except Exception as e:
            print(f"Error sending user message: {e}")

    def Update(self):
        try:
            #if(self.Data.IsEnterLive()):
            self.UpdateToggleLike()
            self.UpdateWellComne()
            self.UpdateScreen()
            self.UpdateBuy()
            self.UpdateDanmu()
            self.UpdateHelp()
            self.startTimer()
        except Exception as e:
            print(f"Error in update: {e}")

    def RefreshWellCome(self):
        try:
            self.uiRoot.setWellComeModel(self.Data.wellComeData.contents)
            self.uiRoot.setWellComeModelIndex(0)
        except Exception as e:
            print(f"Error refreshing welcome content: {e}")

    def WellComeReplayTimeRefresh(self):
        try:
            self.wellComeTimeInverval = int(self.uiRoot.getWellComeTime())
        except Exception as e:
            print(f"Error refreshing welcome reply time: {e}")

    def WellComeReplayToggle(self, chekced):
        try:
            self.wellComeReplyToggle = chekced
        except Exception as e:
            print(f"Error toggling welcome reply: {e}")

    def WellComeToggle(self, checked):
        try:
            self.wellComeToggle = checked
        except Exception as e:
            print(f"Error toggling welcome: {e}")

    def UpdateWellComne(self):
        try:
            userData = self.Data.GetRandomUser()
            if userData is None or not self.wellComeReplyToggle:
                return
            
            if self.wellComeTime < self.wellComeTimeInverval:
                self.wellComeTime += 1
                return
            
            self.wellComeTime = 0
            self.wellComeContenIndex = (self.wellComeContenIndex + 1) % len(self.wellComeConten)
            self.uiRoot.setWellComeContentIndex(self.wellComeContenIndex)
            self.server.WXSpeak(userData.client, self.uiRoot.getWellComeContent())
        except Exception as e:
            print(f"Error updating welcome: {e}")

    def ScreenToggle(self, checked):
        try:
            self.scrrenToggle = checked
        except Exception as e:
            print(f"Error toggling screen: {e}")

    def ScreenTimeRefresh(self):
        try:
            self.screenTimeInverval = int(self.uiRoot.getScreenTime())
        except Exception as e:
            print(f"Error refreshing screen time: {e}")

    def UpdateScreen(self):
        try:
            if not self.scrrenToggle:
                return
            
            if self.screenTime < self.screenTimeInverval:
                self.screenTime += 1
                return
            
            self.screenTime = 0
            screenData = self.Data.screenData
            contents = screenData.contents[screenData.selectIndex][1]
            self.server.WXContinuousSpeak(contents[0])
        except Exception as e:
            print(f"Error updating screen: {e}")

    def ClickScreenSelectIndex(self, index):
        try:
            self.Data.screenData.selectIndex = index
            self.RefreshScreen()
        except Exception as e:
            print(f"Error selecting screen index: {e}")

    def RefreshScreen(self):
        try:
            screenData = self.Data.screenData
            self.uiRoot.setScreenSelectIndex(screenData.selectIndex)
            contents = screenData.contents[screenData.selectIndex]
            titles = [c[0] for c in screenData.contents]
            self.uiRoot.setScreenTitleText(titles)
            content = "\n".join(contents[1])
            self.uiRoot.setScreenContentText(content)
        except Exception as e:
            print(f"Error refreshing screen content: {e}")

    def ScreenContentChange(self, index, content):
        try:
            self.Data.screenData.contents[index][1] = content.split("\n")
        except Exception as e:
            print(f"Error changing screen content: {e}")

    def ScreenTitleChange(self, index, content):
        try:
            self.Data.screenData.contents[index][0] = content
        except Exception as e:
            print(f"Error changing screen title: {e}")
    
    def ClickSaveScreen(self):
        self.Data.SaveDataByType(TYPE_SCREEN)

    def LikeTimeRefresh(self):
        try:
            self.likeToggleTimeInverval = int(self.uiRoot.getLikeTime())
        except Exception as e:
            print(f"Error refreshing like time: {e}")

    def LikeToggle(self, checked):
        try:
            self.likeToggle = checked
        except Exception as e:
            print(f"Error toggling like: {e}")

    def UpdateToggleLike(self):
        try:
            userData = self.Data.GetRandomUser()
            if userData is None or not self.likeToggle:
                return
            
            if self.likeToggleTime < self.likeToggleTimeInverval - 1:
                self.likeToggleTime += 1
                return
            
            self.likeToggleTime = 0
            self.server.WXAutoLikes(userData.client)
        except Exception as e:
            print(f"Error updating like: {e}")

    def BuyTimeRefresh(self):
        try:
            self.buyTimeInverval = int(self.uiRoot.getBuyTime())
        except Exception as e:
            print(f"Error refreshing buy time: {e}")

    def BuyToggle(self, checked):
        try:
            self.buyToggle = checked
        except Exception as e:
            print(f"Error toggling buy: {e}")

    def UpdateBuy(self):
        try:
            if not self.buyToggle:
                return
            
            if self.buyTime < self.buyTimeInverval - 1:
                self.buyTime += 1
                return
            
            self.buyTime = 0
            self.server.WXPurchase()
        except Exception as e:
            print(f"Error updating buy: {e}")

    def HelpToggle(self, checked):
        try:
            self.helpToggle = checked
        except Exception as e:
            print(f"Error toggling help: {e}")

    def HelpTimeRefresh(self):
        try:
            self.helpTimeInverval = int(self.uiRoot.getHelpTime())
        except Exception as e:
            print(f"Error refreshing help time: {e}")

    def UpdateHelp(self):
        try:
            if not self.helpToggle:
                return
            
            if self.helpTime < self.helpTimeInverval - 1:
                self.helpTime += 1
                return
            
            self.helpTime = 0
            userData = self.Data.GetRandomUser()
            helpData = self.Data.helpData
            contents = helpData.contents[helpData.selectIndex][1]
            self.server.WXSpeak(userData.client, random.choice(contents))
        except Exception as e:
            print(f"Error updating help: {e}")

    def ClickHelpSelectIndex(self, index):
        try:
            self.Data.helpData.selectIndex = index
            self.RefreshHelp()
        except Exception as e:
            print(f"Error selecting help index: {e}")

    def RefreshHelp(self):
        try:
            helpData = self.Data.helpData
            self.uiRoot.setHelpSelectIndex(helpData.selectIndex)
            contents = helpData.contents[helpData.selectIndex]
            titles = [c[0] for c in helpData.contents]
            self.uiRoot.setHelpTitleText(titles)
            content = "\n".join(contents[1])
            self.uiRoot.setHelpContentText(content)
        except Exception as e:
            print(f"Error refreshing help content: {e}")

    def HelpContentChange(self, index, content):
        try:
            self.Data.helpData.contents[index][1] = content.split("\n")
        except Exception as e:
            print(f"Error changing help content: {e}")

    def HelpTitleChange(self, index, content):
        try:
            self.Data.helpData.contents[index][0] = content
        except Exception as e:
            print(f"Error changing help title: {e}")
    
    def ClickSaveHelp(self):
        self.Data.SaveDataByType(TYPE_HELP)

    def DanmuToggle(self, checked):
        try:
            self.danmuToggle = checked
        except Exception as e:
            print(f"Error toggling danmu: {e}")

    def UpdateDanmu(self):
        try:
            userData = self.Data.GetRandomUser()
            if userData is None or not self.danmuToggle:
                return
            
            if self.danmuTime < self.danmuTimeInverval - 1:
                self.danmuTime += 1
                return
            
            self.danmuTime = 0
            self.server.WXDanmu(userData.client)
        except Exception as e:
            print(f"Error updating danmu: {e}")

    def RefreshLive(self):
        try:
            live = self.Data.liveInfo
            self.uiRoot.setLiveInfo(live.name, live.iconUrl, live.onLineMember, live.lookCount, live.likeCount)
            self.RefreshSearchLiveComboBox()
        except Exception as e:
            print(f"Error refreshing live info: {e}")

    def RefreshSearchLiveComboBox(self):
        self.uiRoot.setSearchLiveComboBox(self.server.bindLiveNames)

    def RefreshTopInfo(self):
        try:
            self.uiRoot.setExpiredDatetime(self.Data.cardInfo.expiredDatetime)
        except Exception as e:
            print(f"Error refreshing top info: {e}")

    def RefreshUserLogin(self):
        try:
            loginInfos = []
            users = self.Data.GetUsers()
            for i in range(len(users)):
                user = {"nickname": users[i].nickname, "avatar": (users[i].avatar)}
                loginInfos.append(user)

            self.uiRoot.refreshLogin(loginInfos)
            self.uiRoot.refreshLoginMsg(self.Data.userDataCollect.contents)
        except Exception as e:
            print(f"Error refreshing user login: {e}")

    def RefreshLikeBuy(self):
        pass

    def RefreshDanmu(self):
        try:
            self.uiRoot.setDanmu(self.Data.DanmuInfo.danmu)
        except Exception as e:
            print(f"Error refreshing danmu: {e}")
