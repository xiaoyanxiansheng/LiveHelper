using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Text;
using Newtonsoft.Json.Linq;

public static class Protocol
{
    public const string MSG_LoginInfo_Update = "MSG_LoginInfo_Update";      // 登录信息更新
    public const string MSG_RoomJoin_Update = "MSG_RoomJoin_Update";        // 进入直播间
    public const string MSG_RoomInfo_Update = "MSG_RoomInfo_Update";        // 直播间信息更新
    public const string MSG_MessageInfo_Update = "MSG_MessageInfo_Update";  // 留言信息更新
    public const string MSG_Puppetattr_Update = "MSG_Puppetattr_Update";    // 创建虚拟身份     

    #region Client Server

    /// <summary>
    /// 请求登录状态
    /// </summary>
    /// <param name="port">端口</param>
    /// <param name="call">回调</param>
    public static void Client2Server_LoginStatus(int port ,Data.LoginInfo loginInfo)
    {
        string url = $"http://localhost:{port}/IsLoginStatus";
        HttpClient client = new HttpClient();
        try
        {
            HttpResponseMessage response = client.PostAsync(url, null).Result; // 阻塞等待异步请求
            response.EnsureSuccessStatusCode();
            string responseBody = response.Content.ReadAsStringAsync().Result; // 阻塞等待读取响应内容
            JObject jsonObject = JObject.Parse(responseBody);
            string onlineStatus = jsonObject["onlinestatus"]?.ToString();
            if (onlineStatus == "3")
            {
                Client2Server_GetSelfLoginInfo(port,loginInfo);
            }
        }
        catch (HttpRequestException e)
        {
            Console.WriteLine($"Request error: {e.Message}");
        }
    }

    /// <summary>
    /// 请求个人信息
    /// </summary>
    /// <param name="port"></param>
    /// <param name="call"></param>
    public static void Client2Server_GetSelfLoginInfo(int port,Data.LoginInfo loginInfo)
    {
        string url = $"http://localhost:{port}/GetSelfLoginInfo";
        HttpClient client = new HttpClient();
        try
        {
            HttpResponseMessage response = client.PostAsync(url, null).Result; // 阻塞等待异步请求
            response.EnsureSuccessStatusCode();
            string responseBody = response.Content.ReadAsStringAsync().Result; // 阻塞等待读取响应内容
            JObject jsonObject = JObject.Parse(responseBody);
            loginInfo.NickName = jsonObject["nickname"]?.ToString();
            loginInfo.IconUrl = jsonObject["head_big"]?.ToString();
            MessageManager.Instance.SendMessage(Protocol.MSG_LoginInfo_Update);
        }
        catch (HttpRequestException e)
        {
            Console.WriteLine($"Request error: {e.Message}");
        }
    }

    /// <summary>
    /// 获取直播间主页信息
    /// </summary>
    /// <param name="port"></param>
    /// <param name="roomInfo"></param>
    /// <param name="call"></param>
    public static void Client2Server_FinderGetCommentDetail(int port ,Data.RoomInfo roomInfo)
    {
        string url = $"http://localhost:{port}/LikeFinderLive";
        string jsonData = string.Format(@"{{
            ""objectId"": ""{0}"",
            ""objectNonceId"": ""{1}"",
        }}", Data.LiveMsgInfo.objectId,Data.LiveMsgInfo.objectNonceId);
        HttpClient client = new HttpClient();
        try
        {
            HttpContent content = new StringContent(jsonData, Encoding.UTF8, "application/json");
            HttpResponseMessage response = client.PostAsync(url, content).Result; // 阻塞等待异步请求
            response.EnsureSuccessStatusCode();
            string responseBody = response.Content.ReadAsStringAsync().Result; // 阻塞等待读取响应内容
            JObject jsonObject = JObject.Parse(responseBody);
            roomInfo.ParticipantCount = jsonObject["object"]["live_info"]["participant_count"].ToString();
            Data.LiveMsgInfo.live_id = jsonObject["object"]["live_info"]["live_id"].ToString();
            // 继续请求 请求直播间信息
            Client2Server_FinderGetLiveInfo(port, roomInfo);
        }
        catch (HttpRequestException e)
        {
            Console.WriteLine($"Request error: {e.Message}");
        }
    }

    /// <summary>
    /// 请求直播间详情
    /// </summary>
    /// <param name="port"></param>
    /// <param name="roomInfo"></param>
    /// <param name="call"></param>
    public static void Client2Server_FinderGetLiveInfo(int port ,Data.RoomInfo roomInfo)
    {
        string url = $"http://localhost:{port}/LikeFinderLive";
        string jsonData = string.Format(@"{{
            ""live_id"": ""{0}""
        }}", Data.LiveMsgInfo.live_id);
        HttpClient client = new HttpClient();
        try
        {
            HttpContent content = new StringContent(jsonData, Encoding.UTF8, "application/json");
            HttpResponseMessage response = client.PostAsync(url, content).Result; // 阻塞等待异步请求
            response.EnsureSuccessStatusCode();
            string responseBody = response.Content.ReadAsStringAsync().Result; // 阻塞等待读取响应内容
            JObject jsonObject = JObject.Parse(responseBody);
            roomInfo.OnlineCount = jsonObject["live_info"]["online_cnt"].ToString();
            roomInfo.LikeCount = jsonObject["live_info"]["like_cnt"].ToString();
            MessageManager.Instance.SendMessage(Protocol.MSG_RoomInfo_Update);
        }
        catch (HttpRequestException e)
        {
            Console.WriteLine($"Request error: {e.Message}");
        }
    }

    /// <summary>
    /// 进入直播间
    /// </summary>
    /// <param name="port"></param>
    public static void Client2Server_JoinFinderLive(int port)
    {
        string url = $"http://localhost:{port}/JoinFinderLive";
        string jsonData = string.Format(@"{{
            ""live_id"": ""{0}"",
            ""objectId"": ""{1}"",
            ""objectNonceId"": ""{3}"",
            ""finder_username"": ""{4}"",
        }}", Data.LiveMsgInfo.live_id,Data.LiveMsgInfo.objectId,Data.LiveMsgInfo.objectNonceId,Data.LiveMsgInfo.finder_username);
        HttpClient client = new HttpClient();
        try
        {
            HttpContent content = new StringContent(jsonData, Encoding.UTF8, "application/json");
            HttpResponseMessage response = client.PostAsync(url, content).Result; // 阻塞等待异步请求
            response.EnsureSuccessStatusCode();
            string responseBody = response.Content.ReadAsStringAsync().Result; // 阻塞等待读取响应内容
            JObject jsonObject = JObject.Parse(responseBody);
            MessageManager.Instance.SendMessage(Protocol.MSG_RoomJoin_Update);
        }
        catch (HttpRequestException e)
        {
            Console.WriteLine($"Request error: {e.Message}");
        }
    }
    
    /// <summary>
    /// 直播间点赞
    /// </summary>
    /// <param name="port"></param>
    /// <param name="likeCount"></param>
    public static void Client2Server_LikeFinderLive(int port, int likeCount)
    {
        string url = $"http://localhost:{port}/LikeFinderLive";
        string jsonData = string.Format(@"{{
            ""live_id"": ""2078581932480529517"",
            ""objectId"": ""14184660766866479141"",
            ""like_count"": ""{0}""
        }}", likeCount);
        Client2Server_SendMsg(url,jsonData);
    }

    /// <summary>
    /// 直播间留言
    /// </summary>
    /// <param name="port"></param>
    /// <param name="finder_username"></param>
    /// <param name="content"></param>
    public static void Client2Server_FinderPostLiveMsg(int port, string finder_username, string content)
    {
        string url = $"http://localhost:{port}/LikeFinderLive";
        string jsonData = string.Format(@"{{
            ""live_id"": ""{0}"",
            ""objectId"": ""{1}"",
            ""req_url"": ""{2}"",
            ""live_cookies"": ""{3}"",
            ""finder_username"": ""{4}"",
            ""content"": ""{5}"",
        }}", Data.LiveMsgInfo.live_id,Data.LiveMsgInfo.objectId,Data.LiveMsgInfo.req_url,Data.LiveMsgInfo.live_cookies,finder_username,content);
        Client2Server_SendMsg(url,jsonData);
    }

    /// <summary>
    /// 直播间 创建虚拟身份
    /// </summary>
    public static void Client2Server_FinderliveSetSockPuppetattr(int port,Data.VirtualUserInfo virtualUserInfo)
    {
        string url = $"http://localhost:{port}/LikeFinderLive";
        string jsonData = string.Format(@"{{
            ""nick_name"": ""{0}""
            ""head_url"": ""{1}""
        }}", virtualUserInfo.NickName, virtualUserInfo.IconUrl);
        HttpClient client = new HttpClient();
        try
        {
            HttpContent content = new StringContent(jsonData, Encoding.UTF8, "application/json");
            HttpResponseMessage response = client.PostAsync(url, content).Result; // 阻塞等待异步请求
            response.EnsureSuccessStatusCode();
            string responseBody = response.Content.ReadAsStringAsync().Result; // 阻塞等待读取响应内容
            JObject jsonObject = JObject.Parse(responseBody);
            virtualUserInfo.id = jsonObject["id"].ToString();
            MessageManager.Instance.SendMessage(Protocol.MSG_Puppetattr_Update);
        }
        catch (HttpRequestException e)
        {
            
        }
    }

    // 切换身份自动进入直播间
    public static void Client2Server_FinderliveSwitchIDentity(int port, int live_id , int objectId, int id , int role)
    {
        string url = $"http://localhost:{port}/FinderliveSwitchIDentity";
        string jsonData = string.Format(@"{{
            ""live_id"": ""{0}""
            ""objectId"": ""{1}""
            ""id"": ""{2}""
            ""role"": ""{3}""
        }}", live_id, objectId, id, role);
        HttpClient client = new HttpClient();
        try
        {
            HttpContent content = new StringContent(jsonData, Encoding.UTF8, "application/json");
            HttpResponseMessage response = client.PostAsync(url, content).Result; // 阻塞等待异步请求
            response.EnsureSuccessStatusCode();
            string responseBody = response.Content.ReadAsStringAsync().Result; // 阻塞等待读取响应内容
            JObject jsonObject = JObject.Parse(responseBody);
            string Ret = jsonObject["baseResponse"]["Ret"].ToString();
            if (Ret == "0")
            {
                // 进入直播间
                
            }
        }
        catch (HttpRequestException e)
        {
            
        }
    }
    /// <summary>
    /// 实时弹幕
    /// </summary>
    /// <param name="port"></param>
    /// <param name="call"></param>
    public static void Client2Server_FinderGetLiveMsg(int port, Data.MessageInfo messageInfo)
    {
        string url = $"http://localhost:{port}/LikeFinderLive";
        string jsonData = string.Format(@"{{
            ""live_id"": ""{0}"",
            ""objectId"": ""{1}"",
            ""objectNonceId"": ""{2}"",
            ""req_url"": ""{3}"",
            ""live_cookies"": ""{4}"",
        }}", Data.LiveMsgInfo.live_id,Data.LiveMsgInfo.objectId,Data.LiveMsgInfo.objectNonceId,Data.LiveMsgInfo.req_url,Data.LiveMsgInfo.live_cookies);
        HttpClient client = new HttpClient();
        try
        {
            HttpContent content = new StringContent(jsonData, Encoding.UTF8, "application/json");
            HttpResponseMessage response = client.PostAsync(url, content).Result; // 阻塞等待异步请求
            response.EnsureSuccessStatusCode();
            string responseBody = response.Content.ReadAsStringAsync().Result; // 阻塞等待读取响应内容
            JObject jsonObject = JObject.Parse(responseBody);
            JArray msgArray = (JArray)jsonObject["msg_list"];
            List<Data.MessageInfoItem> datas = new List<Data.MessageInfoItem>();
            foreach (JObject msg in msgArray)
            {
                Data.MessageInfoItem data = new Data.MessageInfoItem();
                data.NickName = msg["nickname"].ToString();
                data.Content = msg["content"].ToString();
                datas.Add(data);
            }

            messageInfo.messages = datas;
            MessageManager.Instance.SendMessage(Protocol.MSG_MessageInfo_Update);
        }
        catch (HttpRequestException e)
        {
            Console.WriteLine($"Request error: {e.Message}");
        }
    }
    
    /// <summary>
    /// 无返回请求函数
    /// </summary>
    /// <param name="url"></param>
    /// <param name="jsonData"></param>
    private static void Client2Server_SendMsg(string url, string jsonData)
    {
        HttpClient client = new HttpClient();
        try
        {
            HttpContent content = new StringContent(jsonData, Encoding.UTF8, "application/json");
            HttpResponseMessage response = client.PostAsync(url, content).Result; // 阻塞等待异步请求
            // response.EnsureSuccessStatusCode();
            // string responseBody = response.Content.ReadAsStringAsync().Result; // 阻塞等待读取响应内容
        }
        catch (HttpRequestException e)
        {
            Console.WriteLine($"Request error: {e.Message}");
        }
    }
    
    #endregion
    
    #region Client Client

    #endregion
}