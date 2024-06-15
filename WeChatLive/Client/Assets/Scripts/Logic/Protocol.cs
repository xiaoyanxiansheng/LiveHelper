using System;
using System.Net.Http;
using Newtonsoft.Json.Linq;

public static class Protocol
{
    public const string MSG_LoginInfo_Update = "MSG_LoginInfo_Update"; // 登录信息更新


    #region Client Server

    /// <summary>
    /// 请求登录状态
    /// </summary>
    /// <param name="port">端口</param>
    /// <param name="call">回调</param>
    public static void Client2Server_LoginStatus(int port , Action<bool> call)
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
            call(onlineStatus == "3");
        }
        catch (HttpRequestException e)
        {
            call(false);
            Console.WriteLine($"Request error: {e.Message}");
        }
    }

    /// <summary>
    /// 请求个人信息
    /// </summary>
    /// <param name="port"></param>
    /// <param name="call"></param>
    public static void Client2Server_GetSelfLoginInfo(int port, Action<bool, string,string> call)
    {
        string url = $"http://localhost:{port}/GetSelfLoginInfo";
        HttpClient client = new HttpClient();
        try
        {
            HttpResponseMessage response = client.PostAsync(url, null).Result; // 阻塞等待异步请求
            response.EnsureSuccessStatusCode();
            string responseBody = response.Content.ReadAsStringAsync().Result; // 阻塞等待读取响应内容
            JObject jsonObject = JObject.Parse(responseBody);
            string nickname = jsonObject["nickname"]?.ToString();
            string head_big = jsonObject["head_big"]?.ToString();
            call(true, nickname,head_big);
        }
        catch (HttpRequestException e)
        {
            call(false, "", "");
            Console.WriteLine($"Request error: {e.Message}");
        }
    }

    public static void Client2Server_LikeFinderLive(int port)
    {
        string url = $"http://localhost:{port}/LikeFinderLive";
        string jsonData = @"{
            ""live_id"": ""2078581932480529517"",
            ""objectId"": ""14184660766866479141"",
            ""like_count"": ""10"",
            }";
        HttpClient client = new HttpClient();
        try
        {
            byte[] bodyRaw = System.Text.Encoding.UTF8.GetBytes(jsonData);
            HttpResponseMessage response = client.PostAsync(url, null).Result; // 阻塞等待异步请求
            response.EnsureSuccessStatusCode();
            string responseBody = response.Content.ReadAsStringAsync().Result; // 阻塞等待读取响应内容
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