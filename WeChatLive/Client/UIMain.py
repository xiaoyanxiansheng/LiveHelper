from datetime import datetime
import random
from tkinter import Tk, messagebox, simpledialog
from SPCloud import GetExpiredTimeStamp, IsExpiredTimeStamp
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

        self.notice = None

        self.Data.cardInfo.expiredDatetime = GetExpiredTimeStamp()

        self.wellComeContenIndex = 0
        self.wellComeConten = {"123", "456", "789"}
        self.wellComeToggle = False
        self.wellComeReplyToggle = False
        self.wellComeTime = 0
        self.wellComeTimeInverval = 3

        self.changeNickNameTime = 0

        self.screenTime = 0
        self.screenTimeInverval = 3
        self.scrrenToggle = False

        self.likeToggle = False
        self.likeToggleTime = 0
        self.likeToggleTimeInverval = 3

        self.buyToggle = False
        self.buyTime = 0
        self.buyTimeInverval = 3

        self.helpToggle = False
        self.helpTime = 0
        self.helpTimeInverval = 3

        self.danmuToggle = False
        self.danmuTime = 0
        self.danmuTimeInverval = 2

        self.enterLiveTime = 0
        self.enterLiveTimeInverval = 5

        self.saveTime = 0
        self.saveTimeInverval = 5

        self.uiRoot = uiRoot
        self.uiRoot.signalTest.connect(self.signalTest)
        self.uiRoot.clickdOpenWeChat.connect(self.ClickOpenWeChat)
        self.uiRoot.clickSearchLiveByName.connect(self.ClickSearchLiveByName)
        self.uiRoot.clickSendUserMsg.connect(self.ClickSendUserMsg)
        self.uiRoot.clickChangeUserNameMsg.connect(self.ClickChangeUserNameMsg)
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
        self.uiRoot.clickNotice.connect(self.ClickNotice)
        self.uiRoot.clickScreenAdd.connect(self.ClickScreenAdd)
        self.uiRoot.clickScreenRemove.connect(self.ClickScreenRemove)
        self.uiRoot.clickHelpAdd.connect(self.ClickHelpAdd)
        self.uiRoot.clickHelpRemove.connect(self.ClickHelpRemove)

        self.startTimer()

        self.wxhelper.WXHelpDLL_CallRecvHandler(self.CallRecvHandlerCall)

        self.worker = Worker()
        self.worker.resultReady.connect(self.handle_result)

        self.RefreshTopInfo()
        self.RefreshUserLogin()
        self.RefreshLive()
        self.RefreshSearchLiveComboBox()
        self.RefreshWellCome()
        self.RefreshScreen()
        self.RefreshLikeBuy()
        self.RefreshHelp()
        self.RefreshDanmu()

    def startTimer(self):
        self.timer = threading.Timer(1.0, self.Update)
        self.timer.start()

    def SelectFile(self, type, filePath):
        if self.IsExpiredTimeStamp():
            return
            
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
            
            user = self.Data.GetUserById(clientId)

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
                liveName = user.instructionContent
                if liveName == "":
                    messagebox.showinfo("搜索失败", "直播间不存在或者未开播！！！")
                else:
                    result = messagebox.askyesno("进入直播间", "绑定并且进入直播间【{0}】？".format(liveName))
                    if result:
                        access = self.server.RequestBindEnterLive(liveName)
                        if not access:
                            messagebox.showinfo("绑定失败", "具体原因询问提供商!!!")
                        else:
                            self.RefreshSearchLiveComboBox()
                            self.server.WXEnterRoom(user.client, liveName)
                    else:
                        pass
            elif type == TYPE_enterRoom:
                self.RefreshLive()
            elif type == TYPE_ChangeUserNickName:
                if user.instructionContent != "":
                    user.nickname = user.instructionContent
                    self.RefreshUserLogin()
                    messagebox.showinfo("提示", "改名成功！！！")
                else:
                    messagebox.showinfo("警告", "改名失败！！！")
                
        except Exception as e:
            print(f"Error in handle_result: {e}")

    def signalTest(self):
        pass

    def IsExpiredTimeStamp(self):
        if IsExpiredTimeStamp():
            messagebox.showinfo("卡密过期", "卡密已过期，请找提供商！！！")
            return True
        return False

    def ClickOpenWeChat(self):
        if self.IsExpiredTimeStamp():
            return

        try:
            self.wxhelper.openWechatMutexTwo()
        except Exception as e:
            print(f"Error opening WeChat: {e}")

    def ClickSearchLiveByName(self, liveName):
        if self.IsExpiredTimeStamp():
            return
        
        try:
            userData = self.Data.GetRandomUser()
            if userData:
                self.server.WXSearchRoom(userData.client, liveName)
            else:
                messagebox.showinfo("提示", "请先登录微信！！！")
        except Exception as e:
            print(f"Error searching live by name: {e}")

    def ClickEnterLiveByName(self, liveName):
        if self.IsExpiredTimeStamp():
            return
        
        try:
            userData = self.Data.GetRandomUser()
            if userData:
                self.server.WXEnterRoom(userData.client, liveName)
            else:
                messagebox.showinfo("提示", "请先登录微信！！！")
        except Exception as e:
            print(f"Error searching live by name: {e}")

    def ClickSendUserMsg(self, index, content):
        if self.IsExpiredTimeStamp():
            return
        
        try:
            userData = self.Data.GetUsers()[index]
            if userData:
                self.server.WXSpeak(userData.client, content)
            else:
                messagebox.showinfo("提示", "请先登录微信！！！")
        except Exception as e:
            print(f"Error sending user message: {e}")

    def ClickChangeUserNameMsg(self , index):
        if self.IsExpiredTimeStamp():
            return
        
        try:
            userData = self.Data.GetUsers()[index]
            if userData:
                user_input = simpledialog.askstring("修改微信名称！注意一天不要修改超过10次", userData.nickname)
                if user_input:
                    userData.instruction = TYPE_ChangeUserNickName
                    userData.instructionContent = user_input
                    self.wxhelper.ChangeNickName(userData.client, user_input)
                else:
                    pass
            else:
                messagebox.showinfo("提示", "请先登录微信！！！")

        except Exception as e:
            print(f"Error sending user message: {e}")

    def Update(self):
        if IsExpiredTimeStamp():
            return
        
        try:
            #if(self.Data.IsEnterLive()):
            self.UpdateToggleLike()
            self.UpdateWellComne()
            self.UpdateBuy()
            self.UpdateDanmu()
            self.UpdateHelp()
            self.UpdateScreen()
            self.UpdateEnterLive()
            self.UpdateSave()
            self.startTimer()
        except Exception as e:
            print(f"Error in update: {e}")

    def RefreshWellCome(self):
        try:
            self.uiRoot.setWellComeModel(self.Data.wellComeData.contents)
            self.uiRoot.setWellComeModelIndex(0)
            self.uiRoot.setWellComeTime(self.wellComeTimeInverval)
        except Exception as e:
            print(f"Error refreshing welcome content: {e}")

    def WellComeReplayTimeRefresh(self):
        try:
            time = int(self.uiRoot.getWellComeTime())
            time = self.TimeIntervalTips(time)
            self.uiRoot.setWellComeTime(time)
            self.wellComeTimeInverval = time
        except Exception as e:
            print(f"Error refreshing welcome reply time: {e}")

    def WellComeReplayToggle(self, chekced):
        if self.IsExpiredTimeStamp():
            return
        
        try:
            self.wellComeReplyToggle = chekced
        except Exception as e:
            print(f"Error toggling welcome reply: {e}")

    def WellComeToggle(self, checked):
        if self.IsExpiredTimeStamp():
            return
        
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
        if self.IsExpiredTimeStamp():
            return
        
        try:
            self.scrrenToggle = checked
        except Exception as e:
            print(f"Error toggling screen: {e}")

    def ScreenTimeRefresh(self):
        try:
            time = int(self.uiRoot.getScreenTime())
            time = self.TimeIntervalTips(time)
            self.uiRoot.setScreenTime(time)
            self.screenTimeInverval = time
        except Exception as e:
            print(f"Error refreshing screen time: {e}")

    def UpdateScreen(self):
        try:
            userData = self.Data.GetRandomUser()
            if userData is None or not self.scrrenToggle:
                return
            
            self.screenTime += 1
            if self.screenTime < self.screenTimeInverval:
                return
            
            self.screenTime = 0
            screenData = self.Data.screenData
            contents = screenData.contents[screenData.selectIndex][1]
            self.server.WXContinuousSpeak(userData.client ,random.choice(contents))
        except Exception as e:
            print(f"Error updating screen: {e}")

    def ClickScreenSelectIndex(self, index):
        if self.IsExpiredTimeStamp():
            return
        
        try:
            self.Data.screenData.selectIndex = index
            self.RefreshScreen()
        except Exception as e:
            print(f"Error selecting screen index: {e}")

    def RefreshScreen(self):
        try:
            screenData = self.Data.screenData
            if(len(screenData.contents) > 0):
                self.uiRoot.setScreenSelectIndex(screenData.selectIndex)
                contents = screenData.contents[screenData.selectIndex]
                titles = [c[0] for c in screenData.contents]
                self.uiRoot.setScreenTitleText(titles)
                content = "\n".join(contents[1])
                self.uiRoot.setScreenContentText(content)
            else:
                self.uiRoot.setScreenTitleText([])
                self.uiRoot.setScreenContentText("空")

            self.uiRoot.setScreenTime(self.screenTimeInverval)
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
        if self.IsExpiredTimeStamp():
            return
        
        self.Data.SaveDataByType(TYPE_SCREEN)

    def ClickScreenAdd(self):
        self.Data.screenData.contents.append(["新方案",""])
        self.RefreshScreen()

    def ClickScreenRemove(self,index):
        if(len(self.Data.screenData.contents) == 0):
            return
        
        result = messagebox.askyesno("警告！！！", "是否删除")
        if result:
            self.Data.screenData.contents.pop(int(index))
            self.Data.screenData.selectIndex = 0
            self.RefreshScreen()
        else:
            pass

    def LikeTimeRefresh(self):
        try:
            time = int(self.uiRoot.getLikeTime())
            time = self.TimeIntervalTips(time)
            self.uiRoot.setLikeTime(time)
            self.likeToggleTimeInverval = time
        except Exception as e:
            print(f"Error refreshing like time: {e}")

    def LikeToggle(self, checked):
        if self.IsExpiredTimeStamp():
            return
        
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
            time = int(self.uiRoot.getBuyTime())
            time = self.TimeIntervalTips(time)
            self.uiRoot.setBuyTime(time)
            self.buyTimeInverval = time
        except Exception as e:
            print(f"Error refreshing buy time: {e}")

    def BuyToggle(self, checked):
        if self.IsExpiredTimeStamp():
            return
        
        try:
            self.buyToggle = checked
        except Exception as e:
            print(f"Error toggling buy: {e}")

    def UpdateBuy(self):
        try:
            userData = self.Data.GetRandomUser()
            if userData is None or not self.buyToggle:
                return
            
            if not self.buyToggle:
                return
            
            if self.buyTime < self.buyTimeInverval - 1:
                self.buyTime += 1
                return
            
            self.buyTime = 0
            self.server.WXPurchase(userData.client)
        except Exception as e:
            print(f"Error updating buy: {e}")

    def HelpToggle(self, checked):
        if self.IsExpiredTimeStamp():
            return
        
        try:
            self.helpToggle = checked
        except Exception as e:
            print(f"Error toggling help: {e}")

    def HelpTimeRefresh(self):
        try:
            time = int(self.uiRoot.getHelpTime())
            time = self.TimeIntervalTips(time)
            self.uiRoot.setHelpTime(time)
            self.helpTimeInverval = time
        except Exception as e:
            print(f"Error refreshing help time: {e}")

    def UpdateHelp(self):
        try:
            userData = self.Data.GetRandomUser()
            if userData is None or not self.helpToggle:
                return
            
            if self.helpTime < self.helpTimeInverval - 1:
                self.helpTime += 1
                return
            
            self.helpTime = 0
            helpData = self.Data.helpData
            contents = helpData.contents[helpData.selectIndex][1]
            self.server.WXSpeak(userData.client, random.choice(contents))
        except Exception as e:
            print(f"Error updating help: {e}")

    def ClickHelpSelectIndex(self, index):
        if self.IsExpiredTimeStamp():
            return
        
        try:
            self.Data.helpData.selectIndex = index
            self.RefreshHelp()
        except Exception as e:
            print(f"Error selecting help index: {e}")

    def RefreshHelp(self):
        try:
            helpData = self.Data.helpData
            if(len(helpData.contents) > 0):
                self.uiRoot.setHelpSelectIndex(helpData.selectIndex)
                contents = helpData.contents[helpData.selectIndex]
                titles = [c[0] for c in helpData.contents]
                self.uiRoot.setHelpTitleText(titles)
                content = "\n".join(contents[1])
                self.uiRoot.setHelpContentText(content)
                self.uiRoot.setHelpTime(self.helpTimeInverval)
            else:
                self.uiRoot.setHelpTitleText([])
                self.uiRoot.setHelpContentText("空")
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
        if self.IsExpiredTimeStamp():
            return
        
        self.Data.SaveDataByType(TYPE_HELP)

    def ClickHelpAdd(self):
        self.Data.helpData.contents.append(["新方案",""])
        self.RefreshHelp()

    def ClickHelpRemove(self, index):
        if(len(self.Data.helpData.contents) == 0):
            return
        
        result = messagebox.askyesno("警告！！！", "是否删除")
        if result:
            self.Data.helpData.contents.pop(int(index))
            self.Data.helpData.selectIndex = 0
            self.RefreshHelp()
        else:
            pass

    def DanmuToggle(self, checked):
        if self.IsExpiredTimeStamp():
            return
        
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
            self.uiRoot.setLiveInfo(live.nickname, live.iconUrl, live.onLineMember, live.lookCount, live.likeCount)
        except Exception as e:
            print(f"Error refreshing live info: {e}")

    def RefreshSearchLiveComboBox(self):
        self.uiRoot.setSearchLiveComboBox(self.server.bindLiveNames)

    def RefreshTopInfo(self):
        try:
            expired_datetime = datetime.utcfromtimestamp(self.Data.cardInfo.expiredDatetime)
            self.uiRoot.setExpiredDatetime(expired_datetime.strftime('%Y年%m月%d日 %H:%M:%S'))
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
        self.uiRoot.setLikeTime(self.likeToggleTimeInverval)
        self.uiRoot.setBuyTime(self.buyTimeInverval)

    def RefreshDanmu(self):
        try:
            self.uiRoot.setDanmu(self.Data.DanmuInfo.danmu)
        except Exception as e:
            print(f"Error refreshing danmu: {e}")
    
    def ClickNotice(self):
        try:
            if self.notice == None:
                current_dir = os.path.dirname(os.path.abspath(__file__))
                file_path = os.path.join(current_dir, 'NOTICE.txt')
                with open(file_path, 'r', encoding='utf-8') as file:
                    lines = file.readlines()
                    self.notice = ''.join(lines)
                    
            messagebox.showinfo("重要告知!!!", self.notice)

        except Exception as e:
            print(f"Error reading file {file_path}: {e}")

    def UpdateSave(self):
        try: 
            self.saveTime += 1
            if self.saveTime < self.saveTimeInverval:
                return
            self.saveTime = 0

            self.ClickSaveHelp()
            self.ClickSaveScreen()
        except Exception as e:
            print(f"Error updating danmu: {e}")

    def UpdateEnterLive(self):
        try:
            userData = self.Data.GetRandomUser()
            if userData is None:
                return
            
            if self.Data.liveInfo.nickname == "":
                return

            self.enterLiveTime += 1
            if self.enterLiveTime < self.enterLiveTimeInverval:
                return
            self.enterLiveTime = 0
            
            self.server.WXEnterRoom(userData.client, self.Data.liveInfo.nickname)
        except Exception as e:
            print(f"Error updating screen: {e}")


    def TimeIntervalTips(self, time):
        # if time < self.GetTimeInvervalMin():
        #     messagebox.showinfo("重要告知!!!", "登录微信数量不够！！！")
        #     time = self.GetTimeInvervalMin()
        
        return time

    def GetTimeInvervalMin(self):
        return GetTimeInterval(self.Data.GetUserCount())
        
