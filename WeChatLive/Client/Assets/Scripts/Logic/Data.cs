using System.Collections.Generic;

public class Data
{  
    /// <summary>
    /// 头像信息
    /// </summary>
    public class HeadInfo
    {
        public string IconUrl;
        public string Name;
    }
    public Dictionary<int, HeadInfo> HeadInfos = new Dictionary<int, HeadInfo>();

    /// <summary>
    /// 直播间信息
    /// </summary>
    public class LiveInfo
    {
        public string IconUrl;
        public string Name;
        public int OnlineMember;
        public int LookMember;
    }
    
    /// <summary>
    /// 欢迎信息
    /// </summary>
    public class WellComeInfo
    {
        public int DelayTime;
        public List<string> Values;
    }
    
    /// <summary>
    /// 关键字回复
    /// </summary>
    public class KeyItemInfo
    {
        public string Key;
        public string Reply;
    }
    public class KeyInfo
    {
        public int DelayTime;
        public List<KeyItemInfo> KeyItemInfos;
    }
    
    /// <summary>
    /// 互助发言
    /// </summary>
    public class HelpSayItemInfo
    {
        public string Key;
        public List<string> Value;
    }
    public class HelpSayInfo
    {
        public int DelayTime;
        public List<HelpSayItemInfo> HelpSayItemInfos;
    }
    
    /// <summary>
    /// 公屏
    /// </summary>
    public class ScreenItemInfo
    {
        public string Key;
        public List<string> Value;
    }
    public class ScreenInfo
    {
        public int DelayTime;
        public List<ScreenItemInfo> ScreenItemInfos;
    }

    /// <summary>
    /// 刷新个人登录信息
    /// </summary>
    /// <param name="port"></param>
    public void RequestLoginInfo(int port)
    {
        // if (HeadInfos.ContainsKey(port)) return;
        HeadInfos[port] = new HeadInfo();
        
        //  登录状态
        Protocol.Client2Server_LoginStatus(port, (success) =>
        {
            // 请求详细数据
            Protocol.Client2Server_GetSelfLoginInfo(port, (success,nickname, head_big) =>
            {
                if (success)
                {
                    HeadInfos[port].Name = nickname;
                    HeadInfos[port].IconUrl = head_big;
                    MessageManager.Instance.SendMessage(Protocol.MSG_LoginInfo_Update);
                }
                else
                {
                    HeadInfos.Remove(port);
                }
            });
        });
    }
    
    /// <summary>
    /// 点赞
    /// </summary>
    /// <param name="port"></param>
    public void RequestLike(int port)
    {
        Protocol.Client2Server_LikeFinderLive(port);
    }
}