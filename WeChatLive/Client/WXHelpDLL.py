from ctypes import *
import ctypes
import os
import json
import sys
from tkinter import messagebox
from tornado.options import define
from Define import *

define("port", default=8000, help="run on the given port", type=int)

class WXHelper():
    def __init__(self):
        current_dir = os.path.dirname(os.path.abspath(__file__))
        dll_path = os.path.join(current_dir, 'WxHelp.dll')
        try:
            self.mylib = ctypes.windll.LoadLibrary(dll_path)
        except Exception as e:
            print(f"Error loading WxHelp.dll: {e}")
            sys.exit(1)
        
        self.client_accept_type = WINFUNCTYPE(None, ctypes.c_int)
        self.call_recv_handler_type = WINFUNCTYPE(None, ctypes.c_int32, ctypes.c_char_p, ctypes.c_int32)
        self.client_close_type = WINFUNCTYPE(None, ctypes.c_int)

        self.client_accept_callback = self.client_accept_type(self.clientAccept)
        self.call_recv_handler_callback = self.call_recv_handler_type(self.callRecvHandler)
        self.client_close_callback = self.client_close_type(self.clientClose)

        try:
            self.mylib.SetCB(self.client_accept_callback, self.call_recv_handler_callback, self.client_close_callback)
        except Exception as e:
            print(f"Error setting callbacks: {e}")
        
        print("微信服务启动拉！！")

    def InitData(self, data, server):
        self.clientData = data
        self.server = server

    def WXHelpDLL_CallRecvHandler(self, call):
        self.WXHelpDLL_CallRecvHandlerCall = call

    def sendMsg(self, clientId, msgData):
        try:
            self.mylib.sendHpSocketData(int(clientId), ctypes.c_char_p(msgData.encode()))
            print(f"{clientId}_{msgData}")
        except Exception as e:
            print(f"Error sending message: {e}")

    def clientAccept(self, clientId):
        try:
            print('客户端加入' + str(clientId))
            self.clientData.userDataCollect.AddUser(clientId, "", "")
            self.server.WXLogin(clientId)
            self.WXHelpDLL_CallRecvHandlerCall(clientId, TYPE_wxLogin)
        except Exception as e:
            print(f"Error in clientAccept: {e}")

    def openWechatMutexTwo(self):
        try:
            self.mylib.openWechatMutexTwo("")
        except Exception as e:
            print(f"Error opening WeChat mutex: {e}")

    def callRecvHandler(self, type_int_clientId, type_char_add_msg, type_int_length):
        try:
            strs = ctypes.string_at(type_char_add_msg)
            self.WXHelpDLL_CallRecvHandlerCall(type_int_clientId, str(strs.decode()))
        except Exception as e:
            print(f"Error in callRecvHandler: {e}")

    def clientClose(self, type_int_clientId):
        try:
            print('客户端' + str(type_int_clientId) + '断开')
            self.clientData.userDataCollect.DelUser(type_int_clientId)
            self.server.WXLogout(type_int_clientId)
            self.WXHelpDLL_CallRecvHandlerCall(type_int_clientId, TYPE_wxLogout)
        except Exception as e:
            print(f"Error in clientClose: {e}")

    def LiveSearch(self, clientId, query):
        try:
            json_str = f'{{"type":112577,"data":{{"query":"{query}","last_buff":"0","scene":0}}}}'
            # self.sendMsg(clientId, json_str)
            self.mylib.sendHpSocketData(int(clientId), ctypes.c_char_p(json_str.encode()))
        except Exception as e:
            print(f"Error in LiveSearch: {e}")

    def LiveSearch2(self, clientId, userName, lastBuff):
        try:
            json_str = f'{{"type":11266,"data":{{"username":"{userName}","last_buff":"{lastBuff}"}}}}'
            # self.sendMsg(clientId, json_str)
            self.mylib.sendHpSocketData(int(clientId), ctypes.c_char_p(json_str.encode()))
        except Exception as e:
            print(f"Error in LiveSearch2: {e}")

    def JoinLive(self, clientId, objectId, objectNoceId, liveId):
        try:
            json_str = f'{{"type":112598,"data":{{"object_id":"{objectId}","object_nonce_id":"{objectNoceId}","live_id":"{liveId}"}}}}'
            # self.sendMsg(clientId, json_str)
            self.mylib.sendHpSocketData(int(clientId), ctypes.c_char_p(json_str.encode()))
        except Exception as e:
            print(f"Error in JoinLive: {e}")

    def UserMsg(self, clientId, content):
        try:
            json_str = f'{{"type":113260,"data":{{"content":"{content}"}}}}'
            self.sendMsg(clientId, json_str)
        except Exception as e:
            print(f"Error in UserMsg: {e}")

    def Like(self, clientId, count):
        try:
            json_str = f'{{"type":112891,"data":{{"count":{count}}}}}'
            self.sendMsg(clientId, json_str)
        except Exception as e:
            print(f"Error in Like: {e}")

    def GetDanmu(self, clientId):
        try:
            json_str = '{"type":11259,"trace":1}'
            self.sendMsg(clientId, json_str)
        except Exception as e:
            print(f"Error in GetDanmu: {e}")

    def ChangeNickName(self, clientId, newNickName):
        try:
            json_str = f'{{"type":116255,"data":{{"nickname":"{newNickName}"}}}}'
            self.sendMsg(clientId, json_str)
        except Exception as e:
            print(f"Error in ChangeNickName: {e}")

    def Buy(self, clientId):
        try:
            json_str = '{"type":118260}'
            self.sendMsg(clientId, json_str)
        except Exception as e:
            print(f"Error in Buy: {e}")

    def OnlineMember(self, clientId, objectId, objectNoceId, liveId):
        try:
            json_str = f'{{"type":11268,"data":{{"object_id":"{objectId}","object_nonce_id":"{objectNoceId}","live_id":"{liveId}","last_buff":""}}}}'
            self.sendMsg(clientId, json_str)
        except Exception as e:
            print(f"Error in OnlineMember: {e}")

    def WXParseInstruction(self, dataCollect, clientId, jsondata):
        try:
            data = json.loads(jsondata)["data"]
            user = dataCollect.GetUserById(clientId)

            if "account" in data:
                user = dataCollect.GetUserById(clientId)
                user.avatar = data["avatar"]
                user.nickname = data["nickname"]
                user.instruction = TYPE_wxLogin

            if user is None:
                self.server.OperationCompleted(clientId)
                return

            rinstruction = user.instruction

            if user.instruction == TYPE_speak:
                if "liveCookies" in data:
                    self.UserMsg(user.client, user.instructionContent)
                    self.server.OperationCompleted(clientId)

            if user.instruction == TYPE_continuousSpeak:
                if "liveCookies" in data:
                    self.UserMsg(user.client, user.instructionContent)
                    self.server.OperationCompleted(clientId)

            if user.instruction == TYPE_purchase:
                if "liveCookies" in data:
                    self.Buy(user.client)
                    self.server.OperationCompleted(clientId)

            if user.instruction == TYPE_autoLikes:
                if "liveCookies" in data:
                    self.Like(user.client, 5)
                    self.server.OperationCompleted(clientId)

            if user.instruction == TYPE_Danmu:
                if "msgList" in data:
                    for i in range(len(data["msgList"])):
                        ms = data["msgList"][len(data["msgList"]) - i - 1]
                        if ms["content"] != "":
                            dataCollect.DanmuInfo.danmu = ms["nickname"] + ": " + ms["content"] + "<br>" + dataCollect.DanmuInfo.danmu
                            dataCollect.DanmuInfo.danmu = dataCollect.DanmuInfo.danmu[:1000]
                self.server.OperationCompleted(clientId)

            if user.instruction == TYPE_searchRoom:
                if ("infoList" in data) and (len(data["infoList"]) > 0):
                    rinstruction = ""
                    lastBuff = data["lastBuff"]
                    userName = data["infoList"][0]["contact"]["username"]
                    self.LiveSearch2(clientId, userName, "")
                elif ("object" in data) and (len(data['object']) > 0) and ("liveInfo" in data['object'][0]):
                    if "liveId" in data['object'][0]['liveInfo']:
                        user.instructionContent = data['object'][0]['nickname']
                        self.server.OperationCompleted(clientId)
                    else:
                        user.instructionContent = ""
                        self.server.OperationCompleted(clientId)

            if user.instruction == TYPE_enterRoom:
                if ("infoList" in data) and (len(data["infoList"]) > 0):
                    lastBuff = data["lastBuff"]
                    userName = data["infoList"][0]["contact"]["username"]
                    self.LiveSearch2(clientId, userName, "")
                elif ("object" in data) and (len(data['object']) > 0) and ("liveInfo" in data['object'][0]):
                    dataCollect.liveInfo.objectId = data["object"][0]["id"]
                    dataCollect.liveInfo.objectNonceId = data["object"][0]["objectNonceId"]
                    dataCollect.liveInfo.nickname = data["object"][0]["nickname"]
                    if "liveId" in data['object'][0]['liveInfo']:
                        dataCollect.liveInfo.liveId = data['object'][0]['liveInfo']['liveId']
                        dataCollect.liveInfo.iconUrl = data['contact']["headUrl"]
                        self.JoinLive(clientId, dataCollect.liveInfo.objectId, dataCollect.liveInfo.objectNonceId, dataCollect.liveInfo.liveId)
                    else:
                        self.server.OperationCompleted(clientId)
                        messagebox.showinfo("提示", "直播间未开播！！！")
                elif "liveCookies" in data:
                    dataCollect.liveInfo.likeCount = data["liveInfo"]["likeCnt"]
                    dataCollect.liveInfo.lookCount = data["liveInfo"]["participantCount"]
                    self.OnlineMember(clientId, dataCollect.liveInfo.objectId, dataCollect.liveInfo.objectNonceId, dataCollect.liveInfo.liveId)
                elif "onlineMemberCount" in data:
                    dataCollect.liveInfo.onLineMember = data["onlineMemberCount"]
                    self.server.OperationCompleted(clientId)

            return rinstruction
        except Exception as e:
            self.server.OperationCompleted(clientId)
            print(f"Error parsing instruction: {e}")
            return None
