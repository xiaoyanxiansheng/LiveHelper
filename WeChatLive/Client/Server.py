# Server.py

import json
import websocket
import threading
import time
from Define import *

class Server:
    def __init__(self, lic):
        self.useServer = True
        self.lic = lic
        self.bindLiveNames = ["陆家角服饰","四川酒创-宝总"] # TODO 从服务器拿
        if self.useServer:
            websocket.enableTrace(True)
            # url = "ws://110.40.38.21:8199/ws/" + lic
            url = "ws://121.40.96.47:8199/ws/" + lic
            print("Initializing WebSocket connection " + url)
            self.ws = websocket.WebSocketApp(
                url,
                on_open=self.on_open,
                on_message=self.on_message,
                on_error=self.on_error,
                on_close=self.on_close
            )

            self.wst = threading.Thread(target=self.run_forever)
            self.wst.daemon = True
            self.wst.start()

            print("链接服务器成功 " + url)

    def run_forever(self):
        try:
            self.ws.run_forever()
        except KeyboardInterrupt:
            self.ws.close()
            print("WebSocket connection closed")
        except Exception as e:
            print(f"Unexpected error: {e}")

    def InitData(self, data, wxHelper):
        self.clientData = data
        self.wxHelper = wxHelper

    def on_message(self, ws, message):
        try:
            self.ReceivedMessage(message)
        except Exception as e:
            print(f"Error processing message: {e}")

    def on_error(self, ws, error):
        print(f"WebSocket error: {error}")

    def on_close(self, ws, close_status_code, close_msg):
        print(f"WebSocket closed with code: {close_status_code}, message: {close_msg}")

    def on_open(self, ws):
        print("WebSocket connection opened")

    def WXID(self, wxId):
        return "{}##{}".format(self.lic, wxId)

    def WXLogin(self, wxId):
        if self.useServer:
            self.ws.send(f'{{"type":"{TYPE_wxLogin}","message":"","wx_id":"{self.WXID(wxId)}"}}')

    def WXLogout(self, wxId):
        if self.useServer:
            self.ws.send(f'{{"type":"{TYPE_wxLogout}","message":"","wx_id":"{self.WXID(wxId)}"}}')

    def WXSpeak(self, wxId, content):
        try:
            liveData = self.clientData.liveInfo.GetBaseLiveInfo()
            liveData["content"] = content
            liveData = json.dumps(liveData).replace('"', '\\"')
            data = f'{{"type":"{TYPE_speak}","message":"{liveData}","wx_id":"{self.WXID(wxId)}"}}'
            self.SendDataServerOrClient(data)
        except Exception as e:
            print(f"Error in WXSpeak: {e}")

    def WXContinuousSpeak(self, content):
        try:
            liveData = self.clientData.liveInfo.GetBaseLiveInfo()
            liveData["content"] = content
            liveData = json.dumps(liveData).replace('"', '\\"')
            data = f'{{"type":"{TYPE_continuousSpeak}","message":"{liveData}","wx_id":"0"}}'
            self.SendDataServerOrClient(data)
        except Exception as e:
            print(f"Error in WXContinuousSpeak: {e}")

    def WXPurchase(self):
        try:
            liveData = self.clientData.liveInfo.GetBaseLiveInfo()
            liveData = json.dumps(liveData).replace('"', '\\"')
            data = f'{{"type":"{TYPE_purchase}","message":"{liveData}","wx_id":"0"}}'
            self.SendDataServerOrClient(data)
        except Exception as e:
            print(f"Error in WXPurchase: {e}")

    def WXAutoLikes(self, wxId):
        try:
            liveData = self.clientData.liveInfo.GetBaseLiveInfo()
            liveData = json.dumps(liveData).replace('"', '\\"')
            data = f'{{"type":"{TYPE_autoLikes}","message":"{liveData}","wx_id":"{self.WXID(wxId)}"}}'
            self.SendDataServerOrClient(data)
        except Exception as e:
            print(f"Error in WXAutoLikes: {e}")

    def WXDanmu(self, wxId):
        try:
            liveData = self.clientData.liveInfo.GetBaseLiveInfo()
            liveData = json.dumps(liveData).replace('"', '\\"')
            data = f'{{"type":"{TYPE_Danmu}","message":"{liveData}","wx_id":"{self.WXID(wxId)}"}}'
            self.SendDataServerOrClient(data)
        except Exception as e:
            print(f"Error in WXDanmu: {e}")

    def WXSearchRoom(self, wxId, content):
        try:
            liveData = self.clientData.liveInfo.GetBaseLiveInfo()
            liveData["content"] = content
            liveData = json.dumps(liveData).replace('"', '\\"')
            data = f'{{"type":"{TYPE_searchRoom}","message":"{liveData}","wx_id":"{self.WXID(wxId)}"}}'
            self.SendDataServerOrClient(data)
        except Exception as e:
            print(f"Error in WXSearchRoom: {e}")

    def OperationCompleted(self, wxId):
        try:
            data = f'{{"type":"{TYPE_operationCompleted}","message":"","wx_id":"{self.WXID(wxId)}"}}'
            self.SendDataServerOrClient(data)
        except Exception as e:
            print(f"Error in OperationCompleted: {e}")

    def GetBindLiveNames(self):
        return self.bindLiveNames

    def BindBindLiveName(self, liveName):
        self.bindLiveNames.append(liveName) # TODO 需要走服务器流程

    def SendDataServerOrClient(self, data):
        try:
            print("[Server] Send " + data)
            if self.useServer:
                self.ws.send(data)
            else:
                self.ReceivedMessage(data)
        except Exception as e:
            print(f"Error sending data: {e}")

    def ReceivedMessage(self, message):
        try:
            print("[Server] Received " + message)

            data = json.loads(message)
            type = data["type"]

            if type == "error":
                return

            if type == TYPE_operationCompleted:
                return

            client = int(data["wx_id"].split('##')[-1])
            content = {}
            if data["message"] != "":
                content = json.loads(data["message"])

            if type == TYPE_wxLogin:
                pass
            elif type == TYPE_wxLogout:
                pass

            user = self.clientData.userDataCollect.GetUser(client)
            if user is None:
                return

            user.instruction = type

            if type in [TYPE_speak, TYPE_continuousSpeak]:
                user.instructionContent = content["content"]
                self.wxHelper.JoinLive(client, content["objectId"], content["objectNonceId"], content["liveId"])
            elif type == TYPE_purchase:
                self.wxHelper.JoinLive(client, content["objectId"], content["objectNonceId"], content["liveId"])
            elif type == TYPE_autoLikes:
                self.wxHelper.JoinLive(client, content["objectId"], content["objectNonceId"], content["liveId"])
            elif type == TYPE_searchRoom:
                self.wxHelper.instruction = TYPE_searchRoom
                self.wxHelper.LiveSearch(client, content["content"])
            elif type == TYPE_Danmu:
                self.wxHelper.GetDanmu(client)
        except Exception as e:
            self.OperationCompleted(client)
            print(f"Error processing received message: {e}")

if __name__ == "__main__":
    try:
        server = Server("123456789")
    except Exception as e:
        print(f"Error initializing server: {e}")
