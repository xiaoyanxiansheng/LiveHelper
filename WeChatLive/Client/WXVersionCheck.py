import psutil
import win32api # type: ignore
import os
import platform

# 设定规定的微信版本
REQUIRED_WECHAT_VERSION = "3.9.10.20"  # 替换为你的规定版本

def get_running_wechat_version():
    for proc in psutil.process_iter(['pid', 'name']):
        if 'WeChat.exe' in proc.info['name']:
            try:
                # 获取微信可执行文件的路径
                process = psutil.Process(proc.info['pid'])
                wechat_path = process.exe()
                
                # 获取文件版本信息
                info = win32api.GetFileVersionInfo(wechat_path, '\\')
                ms = info['FileVersionMS']
                ls = info['FileVersionLS']
                version = f"{ms >> 16}.{ms & 0xFFFF}.{ls >> 16}.{ls & 0xFFFF}"
                return version
            except (psutil.AccessDenied, psutil.NoSuchProcess):
                pass
    return None

def check_and_install_wechat():
    current_version = get_running_wechat_version()
    return current_version is None or current_version != REQUIRED_WECHAT_VERSION

def install_wechat():
    wechat_installer_path = os.path.join(os.path.dirname(__file__), f"WeChatSetup_{REQUIRED_WECHAT_VERSION}.exe")  # 替换为实际的微信安装程序名称
    if platform.system() == "Windows":
        os.system(f'start {wechat_installer_path}')
    else:
        print("Unsupported OS for this script.")
        # 你需要根据实际情况处理其他操作系统的安装流程

if __name__ == "__main__":
    check_and_install_wechat()
