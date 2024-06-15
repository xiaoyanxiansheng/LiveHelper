using System.Collections.Generic;
using System;
using UnityEngine.Serialization;
using static Data;

public class Data
{
    #region 临时数据 方便访问
    
    /// <summary>
    /// 直播间缓存
    /// </summary>
    public static class LiveMsgInfo
    {
        public static string objectId;
        public static string objectNonceId;
        public static string finder_username;
        public static string live_id;
        public static string live_cookies;
        public static string req_url;
    }
    #endregion
    
    /// <summary>
    /// 头像信息
    /// </summary>
    [Serializable]
    public class LoginInfo
    {
        // Client
        public int port;

        // Server
        public string IconUrl;
        public string NickName;
        public string UserName;
    }
    public List<LoginInfo> loginInfos = new List<LoginInfo>() 
    {
        // 测试数据
        new LoginInfo() 
        {
            port = 3001,
            IconUrl = "https://cdn-icons-png.flaticon.com/256/1077/1077114.png",
            NickName = "测试名称"
        },
    };
    
    public class VirtualUserInfo
    {
        public string id;
        public string NickName;
        public string IconUrl;
    }
    public List<VirtualUserInfo> virtualUserInfos = new List<VirtualUserInfo>();
    /// <summary>
    /// TODO 需要一个合适的时间
    /// </summary>
    public void CreateVirtualUser()
    {
        // 随机创建
        for (int i = 0; i < virtualUserInfos.Count; i++)
        {
            Protocol.Client2Server_FinderliveSetSockPuppetattr(loginInfos[0].port,virtualUserInfos[i]);
            
        }
    }

    public class UserSayInfo
    {
        public string sayString;
    }
    public List<string> userSayInfos = new List<string>() 
    {
        "主播666","主播还有吗","什么时候下播"
    };

    /// <summary>
    /// 直播间房间信息
    /// </summary>
    [Serializable]
    public class RoomInfo
    {
        public string IconUrl;              // 头像
        public string ParticipantCount;     // 参数人数
        public string OnlineCount;          // 在线人数
        public string LikeCount;            // 点赞次数
    }
    public RoomInfo roomInfo = new RoomInfo()
    {
        // 测试数据
        IconUrl = "https://uxwing.com/wp-content/themes/uxwing/download/hand-gestures/good-icon.png",
        ParticipantCount = "0",
        OnlineCount = "888",
        LikeCount = "888",
    };
    // TODO测试数据

    /// <summary>
    /// 欢迎信息
    /// </summary>
    [Serializable]
    public class WellComeInfo
    {
        public float InvervalTime;
        public bool AutoToggle;
        public bool ReplayToggle;
        public List<string> Says;
    }
    public WellComeInfo wellComeInfo = new WellComeInfo()
    {
        InvervalTime = 3,
        AutoToggle = true,
        ReplayToggle = false,
        // 测试数据
        Says = new List<string>()
        {
            "我是主播，带你上高速", "跟着主播飞起来"
        }
    };

    /// <summary>
    /// 关键字回复
    /// </summary>
    [Serializable]
    public class KeyItemInfo
    {
        public string Key;
        public string Reply;
    }
    [Serializable]
    public class KeyInfo
    {
        public float InvervalTime;
        public bool ReplayToggle;
        public List<KeyItemInfo> KeyItemInfos;
    }

    public KeyInfo keyInfo = new KeyInfo()
    {
        InvervalTime = 3,
        ReplayToggle = false,
        KeyItemInfos = new List<KeyItemInfo>()
        {
            new KeyItemInfo(){Key="关键字回复1", Reply = "回复1"},
            new KeyItemInfo(){Key="关键字回复2", Reply = "回复2"},
            new KeyItemInfo(){Key="关键字回复3", Reply = "回复3"},
            new KeyItemInfo(){Key="关键字回复4", Reply = "回复4"},
            new KeyItemInfo(){Key="关键字回复5", Reply = "回复5"},
            new KeyItemInfo(){Key="关键字回复6", Reply = "回复6"},
            new KeyItemInfo(){Key="关键字回复7", Reply = "回复7"},
            new KeyItemInfo(){Key="关键字回复8", Reply = "回复8"},
            new KeyItemInfo(){Key="关键字回复9", Reply = "回复9"},
            new KeyItemInfo(){Key="关键字回复10", Reply = "回复10"},
        }
    };

    /// <summary>
    /// 互助发言
    /// </summary>
    [Serializable]
    public class HelpSayItemInfo
    {
        public string Key;
        public List<string> Value;
    }
    [Serializable]
    public class HelpSayInfo
    {
        public int IntervalTime;
        public bool ReplayToggle;
        public List<HelpSayItemInfo> HelpSayItemInfos;
    }
    public HelpSayInfo helpSayInfo = new HelpSayInfo()
    {
        IntervalTime = 3,
        ReplayToggle = false,
        HelpSayItemInfos = new List<HelpSayItemInfo>()
        {
            new HelpSayItemInfo(){Key = "方案1" , Value = new List<string>() {"主播你好呀11","主播你好呀2","主播你好呀3"}},
            new HelpSayItemInfo(){Key = "方案2" , Value = new List<string>() {"主播你好呀12","主播你好呀2","主播你好呀3"}},
            new HelpSayItemInfo(){Key = "方案3" , Value = new List<string>() {"主播你好呀13","主播你好呀2","主播你好呀3"}},
            new HelpSayItemInfo(){Key = "方案4" , Value = new List<string>() {"主播你好呀14","主播你好呀2","主播你好呀3"}},
            new HelpSayItemInfo(){Key = "方案5" , Value = new List<string>() {"主播你好呀15","主播你好呀2","主播你好呀3"}},
            new HelpSayItemInfo(){Key = "方案6" , Value = new List<string>() {"主播你好呀16","主播你好呀2","主播你好呀3"}},
            new HelpSayItemInfo(){Key = "方案7" , Value = new List<string>() {"主播你好呀17","主播你好呀2","主播你好呀3"}},
            new HelpSayItemInfo(){Key = "方案8" , Value = new List<string>() {"主播你好呀18","主播你好呀2","主播你好呀3"}},
            new HelpSayItemInfo(){Key = "方案9" , Value = new List<string>() {"主播你好呀19","主播你好呀2","主播你好呀3"}},
            new HelpSayItemInfo(){Key = "方案10" , Value = new List<string>() {"主播你好呀20","主播你好呀2","主播你好呀3"}},
            new HelpSayItemInfo(){Key = "方案11" , Value = new List<string>() {"主播你好呀20","主播你好呀2","主播你好呀3"}},
        }
    };

    /// <summary>
    /// 公屏
    /// </summary>
    [Serializable]
    public class ScreenItemInfo
    {
        public string Key;
        public string Value;
    }

    /// <summary>
    /// 飘屏信息
    /// </summary>
    [Serializable]
    public class ScreenInfo
    {
        public int IntervalTime;
        public bool ReplayToggle;
        public List<ScreenItemInfo> ScreenItemInfos;
    }
    public ScreenInfo screenInfo = new ScreenInfo()
    {
        IntervalTime = 3,
        ReplayToggle = false,
        ScreenItemInfos = new List<ScreenItemInfo>()
        {
            new ScreenItemInfo(){Key = "公屏1" , Value = "111"},
            new ScreenItemInfo(){Key = "公屏2" , Value = "222"},
            new ScreenItemInfo(){Key = "公屏3" , Value = "333"},
            new ScreenItemInfo(){Key = "公屏4" , Value = "444"},
            new ScreenItemInfo(){Key = "公屏5" , Value = "555"},
            new ScreenItemInfo(){Key = "公屏6" , Value = "666"},
            new ScreenItemInfo(){Key = "公屏7" , Value = "777"},
            new ScreenItemInfo(){Key = "公屏8" , Value = "888"},
            new ScreenItemInfo(){Key = "公屏9" , Value = "999"},
            new ScreenItemInfo(){Key = "公屏10" , Value = "000"},
        }
    };

    /// <summary>
    /// 留言信息
    /// </summary>
    public class MessageInfoItem
    {
        public string NickName;
        public string Content;
    }
    [Serializable]
    public class MessageInfo
    {
        public bool AutoToggle;
        public List<MessageInfoItem> messages;
    }
    public MessageInfo messageInfo = new MessageInfo()
    {
        AutoToggle = false,
        messages = new List<MessageInfoItem>()
        {
            new MessageInfoItem(){NickName = "小王" , Content = "珠宝加油"},
            new MessageInfoItem(){NickName = "小王1" , Content = "珠宝加油1"},
            new MessageInfoItem(){NickName = "小王2" , Content = "珠宝加油2"},
            new MessageInfoItem(){NickName = "小王3" , Content = "珠宝加油3"},
        }
    };

    [Serializable]
    public class AutoInfo 
    {
        public float LikeIntervalTime;
        public bool LikeToggle;
        public float BuyIntervalTime;
        public bool BuyToggle;
    }
    public AutoInfo autoInfo = new AutoInfo()
    {
        LikeIntervalTime = 3,
        LikeToggle = false,
        BuyIntervalTime = 3,
        BuyToggle = false,
    };
}