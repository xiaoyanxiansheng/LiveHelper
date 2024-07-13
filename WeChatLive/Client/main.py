import signal
import sys
import Logout
import os
from PyQt5.QtWidgets import QApplication, QSystemTrayIcon, QMenu, QAction, QMainWindow
from PyQt5.QtGui import QIcon
from PyQt5.QtQml import QQmlApplicationEngine
from PyQt5.QtCore import Qt

from Data import Data
from SPCloud import CloudOffline, InitializeCloud
from Server import Server
from UIMain import UIMain
from WXHelpDLL import WXHelper

class MainWindow(QMainWindow):
    def __init__(self):
        super(MainWindow, self).__init__()

    def restore(self):
        self.showNormal()
        self.activateWindow()

def quit_application():
    try:
        CloudOffline()
        print("Quitting application...")
        app.quit()
        os.kill(os.getpid(), signal.SIGTERM)
    except Exception as e:
        print(f"Error quitting application: {e}")

def read_first_line_of_file(file_name):
    file_path = os.path.abspath("./" + file_name)
    try:
        with open(file_path, 'r', encoding='utf-8') as file:
            first_line = file.readline().strip()
            return first_line
    except Exception as e:
        print(f"读取文件时发生错误: {e}")
        return ""

def InitData():
    global data
    data = Data()

def InitUI(engine, data, server, wxHelper):
    try:
        if hasattr(sys, '_MEIPASS'):
            current_dir = sys._MEIPASS
        else:
            current_dir = os.path.dirname(os.path.abspath(__file__))
        qml_file = os.path.join(current_dir, "GUI", "content", "Main.qml")
        engine.load(qml_file)
        objects = engine.rootObjects()
        if objects:
            UIMain(objects[0], data, server, wxHelper)
            objects[0].quitApplication.connect(quit_application)
    except Exception as e:
        print(f"Error initializing UI: {e}")

def main():
    global app
    app = QApplication(sys.argv)

    # 确保应用程序在所有窗口关闭时不会退出
    app.setQuitOnLastWindowClosed(False)

    # 设置应用程序的图标
    icon_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "icon.png")
    app.setWindowIcon(QIcon(icon_path))

    # 初始化系统托盘图标
    tray_icon = QSystemTrayIcon(QIcon(icon_path), parent=app)
    tray_icon.setToolTip("直播助手")
    
    # 创建托盘菜单
    tray_menu = QMenu()
    restore_action = QAction("Restore", app)
    quit_action = QAction("Quit", app)
    tray_menu.addAction(restore_action)
    tray_menu.addAction(quit_action)
    
    # 初始化主窗口
    main_window = MainWindow()

    # 连接信号和槽
    restore_action.triggered.connect(main_window.restore)
    quit_action.triggered.connect(quit_application)
    
    tray_icon.setContextMenu(tray_menu)
    tray_icon.show()

    engine = QQmlApplicationEngine()

    try:
        if hasattr(sys, '_MEIPASS'):
            qml_file = os.path.join(sys._MEIPASS, "GUI", "content", "Main.qml")
        else:
            qml_file = os.path.join(os.path.dirname(os.path.abspath(__file__)), "GUI", "content", "Main.qml")

        engine.load(qml_file)

        # 获取QML中的主窗口
        root_objects = engine.rootObjects()
        if root_objects:
            qml_window = root_objects[0]

            # 移除默认的系统标题栏并设置无边框
            qml_window.setFlags(Qt.FramelessWindowHint | Qt.Window)

            # 实现自定义最小化到系统托盘逻辑
            def handle_minimize():
                qml_window.hide()
                tray_icon.showMessage(
                    "直播助手",
                    "应用程序已最小化到系统托盘。要还原，请单击托盘图标。",
                    QSystemTrayIcon.Information,
                    2000
                )

            def handle_restore():
                qml_window.showNormal()
                qml_window.raise_()
                qml_window.requestActivate()

            # 连接自定义最小化和还原逻辑
            qml_window.windowStateChanged.connect(
                lambda state: handle_minimize() if state == Qt.WindowMinimized else None
            )
            restore_action.triggered.connect(handle_restore)
    except Exception as e:
        print(f"Error loading QML file: {e}")

    try:
        lic = read_first_line_of_file("main.sp.exe.lic")  # 卡密
        if lic.endswith('#'):
            lic = lic[:-1]

        # 初始化云计算
        InitializeCloud(lic)

        # 初始化数据
        data = Data()

        # 初始化服务器
        server = Server(lic)

        # 初始化WXHelp
        wxHelper = WXHelper()

        server.InitData(data, wxHelper)
        wxHelper.InitData(data, server)

        objects = engine.rootObjects()
        if objects:
            UIMain(objects[0], data, server, wxHelper)
            objects[0].quitApplication.connect(quit_application)
    except Exception as e:
        print(f"Error during initialization: {e}")

    try:
        sys.exit(app.exec_())
    except Exception as e:
        print(f"Error during app execution: {e}")

if __name__ == "__main__":
    try:
        main()
    except Exception as e:
        print(f"Exception occurred: {e}")
    finally:
        try:
            # 确保在退出时执行清理操作
            CloudOffline()
        except Exception as e:
            print(f"Error during cleanup: {e}")
