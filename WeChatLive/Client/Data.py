import random
import sys
import os

from Define import *

class CardInfo():
    def __init__(self):
        self.expiredDatetime = "2024年8月26日"

class LiveInfo():
    def __init__(self):
        self.objectId = ""
        self.objectNonceId = ""
        self.liveId = ""

        self.iconUrl = ""
        self.name = ""
        self.onLineMember = 0
        self.lookCount = 0
        self.likeCount = 0

    def GetBaseLiveInfo(self):
        return {"objectId":self.objectId,"objectNonceId":self.objectNonceId,"liveId":self.liveId}

class UserData():
    def __init__(self):
        self.client = 0
        self.avatar = ""
        self.nickname = ""

        self.instruction = ""
        self.instructionContent = ""

class UserDataCollect():
    def __init__(self):
        self.userData = []
        self.contents = []

    def AddUser(self, clientId , avatar , nickName):
        rUser = None
        isIn = False
        for i in range(len(self.userData)):
            if self.userData[i].nickname == nickName:
                rUser = self.userData[i]
                self.userData[i].client = clientId
                self.userData[i].avatar = avatar
                isIn = True
                break
        if not isIn :
            userData = UserData()
            rUser = userData
            userData.client = clientId
            userData.avatar = avatar
            userData.nickname = nickName
            self.userData.append(userData)

        return rUser

    def DelUser(self, clientId):
        for i in range(len(self.userData)):
            if self.userData[i].client == clientId:
                del self.userData[i]
                break

    def GetUser(self, clientId):
        clientId = int(clientId)
        for i in range(len(self.userData)):
            if self.userData[i].client == clientId:
                return self.userData[i]
# --------------------- User End -----------------------

class DanmuInfo():
    def __init__(self):
        self.danmu = ""

nickNameCollect = ["大豆眼","小黄豆","黄天花","橘皮","黑色","黄色","可乐"]

class HelpData():
    def __init__(self):
        self.selectIndex = 0
        self.contents = []

class ScreenData():
    def __init__(self):
        self.selectIndex = 0
        self.contents = []

class WellComeData():
    def __init__(self):
        self.contents = []

def GetRandomNickName():
    return random.choice(nickNameCollect)

class Data():
    def __init__(self):
        self.cardInfo = CardInfo()
        self.userDataCollect = UserDataCollect()
        self.liveInfo = LiveInfo()
        self.DanmuInfo = DanmuInfo()
        self.helpData = HelpData()
        self.screenData = ScreenData()
        self.wellComeData = WellComeData()

        self.ReadData()

    def IsEnterLive(self):
        return self.liveInfo.objectId != "" and self.liveInfo.objectNonceId != "" and self.liveInfo.liveId != ""

    def AddUser(self, clientId , avatar , nickName):
        self.userDataCollect.AddUser(clientId , avatar , nickName)

    def DelUser(self, clientId):
        self.userDataCollect.DelUser(clientId)

    def GetRandomUser(self):
        if len(self.userDataCollect.userData) == 0:
            return None
        
        return random.choice(self.userDataCollect.userData)

    def GetUserById(self,clientId):
        return self.userDataCollect.GetUser(clientId)
    
    def GetUsers(self):
        return self.userDataCollect.userData

    def ReadData(self):
        basePath = self.get_base_path()
        self.userDataCollect.contents = self.read_file_line_by_line(os.path.join(basePath, TEXT_USER))
        self.wellComeData.contents = self.read_file_line_by_line(os.path.join(basePath, TEXT_WELLCOME))
        self.helpData.contents = self.parse_text_to_dict(os.path.join(basePath, TEXT_HELP))
        self.screenData.contents = self.parse_text_to_dict(os.path.join(basePath, TEXT_SCREEN))

    def ReadDataByType(self , type , filePath):
        if filePath.startswith('file:///'):
            filePath = filePath[8:]
        if(type == TYPE_HELP):
            self.helpData.contents = self.parse_text_to_dict(filePath)
        elif(type == TYPE_USER):
            self.userDataCollect.contents = (self.read_file_line_by_line(filePath))
        elif(type == TYPE_SCREEN):
            self.screenData.contents = self.parse_text_to_dict(filePath)
        elif(type == TYPE_WELLCOME):
            self.wellComeData.contents = self.read_file_line_by_line(filePath)

    def SaveDataByType(self, type):
        if(type == TYPE_HELP):
            filePath = os.path.join(self.get_base_path(), TEXT_HELP)
            self.save_dict_to_text(filePath,self.helpData.contents)
        elif(type == TYPE_USER):
            filePath = os.path.join(self.get_base_path(), TEXT_USER)
            self.save_line_to_text(filePath,self.userDataCollect.contents)
        elif(type == TYPE_SCREEN):
            filePath = os.path.join(self.get_base_path(), TEXT_SCREEN)
            self.save_dict_to_text(filePath,self.screenData.contents)
        elif(type == TYPE_WELLCOME):
            filePath = os.path.join(self.get_base_path(), TEXT_WELLCOME)
            self.save_line_to_text(filePath,self.wellComeData.contents)

    def parse_text_to_dict(self, file_path):
        try:
            with open(file_path, 'r', encoding='utf-8') as file:
                content = file.read()
            sections = content.split("-->")
            parsed_data = []
            for section in sections:
                if section.strip():
                    lines = section.strip().split("\n")
                    key = lines[0].strip()
                    values = lines[1:]
                    parsed_data.append([key,values])
            return parsed_data
        except Exception as e:
            print(f"Error parsing file {file_path}: {e}")
            return []
        
    def save_dict_to_text(self, file_path, parsed_data):
        try:
            with open(file_path, 'w', encoding='utf-8') as file:
                for key, values in parsed_data:
                    file.write(f"-->{key}\n")
                    for value in values:
                        file.write(f"{value}\n")
                file.flush()
        except Exception as e:
            print(f"Error writing to file {file_path}: {e}")

    def parse_single_value_text(self, file_path):
        parsed_data = {}
        current_key = None
        try:
            with open(file_path, 'r', encoding='utf-8') as file:
                for line in file:
                    line = line.strip()
                    if line.startswith("-->\n"):
                        current_key = line[3:].strip()
                    elif current_key:
                        parsed_data[current_key] = line
                        current_key = None
        except Exception as e:
            print(f"Error parsing file {file_path}: {e}")
    
        return parsed_data

    def read_file_line_by_line(self, file_path):
        lines = []
        try:
            with open(file_path, 'r', encoding='utf-8') as file:
                for line in file:
                    lines.append(line.strip())
        except Exception as e:
            print(f"Error reading file {file_path}: {e}")
        return lines

    def save_line_to_text(self, file_path, parsed_data):
        try:
            with open(file_path, 'w', encoding='utf-8') as file:
                for value in parsed_data:
                    file.write(f"{value}\n")
        except Exception as e:
            print(f"Error writing to file {file_path}: {e}")
    
    def get_base_path(self):
        if getattr(sys, 'frozen', False):
            return os.path.dirname(sys.executable)
        return os.path.dirname(os.path.abspath(__file__))
