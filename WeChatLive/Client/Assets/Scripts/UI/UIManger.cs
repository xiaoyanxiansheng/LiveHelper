using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.Networking;
using UnityEngine.UI;
using static TMPro.TMP_Dropdown;

public class UIManger : MonoBehaviour
{
    private Data _data;
    private Timer _timer;
    private MessageManager _messageManager;

    void Start()
    {
        _timer = new Timer();
        _data = new Data();
        _messageManager = new MessageManager();

        RegisterMessage();
        Refresh();
    }

    // Update is called once per frame
    void Update()
    {
        _timer.FixedUpdate();
    }

    private void Refresh()
    {
        RefreshLoginInfo();     // 刷新登录信息
        RefreshRoomInfo();      // 刷新直播间信息
        RefreshWellComeInfo();  // 刷新欢迎信息
        RefreshKeyInfo();       // 刷新关键字回复信息
        RefreshAutoInfo();      // 刷新自动功能信息
        RefreshHelpSayInfo();   // 刷新互助信息
        RefreshScreenInfo();    // 刷新飘屏信息
        RefreshMessageInfo();   // 刷新留言信息
    }

    #region 头像信息
    private Dictionary<string, string> _userSayDict = new Dictionary<string, string>();
    /// <summary>
    /// 更新头像信息
    /// </summary>
    private void RefreshLoginInfo()
    {
        Transform loginFather = GameObject.Find("Canvas/HeadInfo/Panel").transform;
        for (int i = 0; i < loginFather.childCount;i++)
        {
            Transform root = loginFather.GetChild(i);
            Transform loginTrans = root.Find("Login");
            Transform loginedTrans = root.Find("Logined");
            bool isLogined = i < _data.loginInfos.Count;
            loginTrans.gameObject.SetActive(!isLogined);
            loginedTrans.gameObject.SetActive(isLogined);
            if (isLogined)
            {
                StartCoroutine(DownloadImage(loginedTrans.Find("Icon").GetComponent<Image>(), _data.loginInfos[i].IconUrl));
                loginedTrans.Find("Name").GetComponent<TextMeshProUGUI>().text = _data.loginInfos[i].NickName;
            }
        }

        RefreshLoginSayInfo();
    }
    
    private void RefreshLoginSayInfo()
    {
        Transform loginFather = GameObject.Find("Canvas/HeadInfo/Panel").transform;
        for (int i = 0; i < loginFather.childCount; i++)
        {
            Transform root = loginFather.GetChild(i);
            FillDropDownInfo(_data.userSayInfos, root.Find("Dropdown"));
        }
    }

    private void MSG_LoginInfo_Update(MessageManager.Message m)
    {
        RefreshLoginInfo();
    }

    private void ClickHeadRefreah()
    {
        var loginInfo = _data.loginInfos[0];
        Protocol.Client2Server_LoginStatus(loginInfo.port, loginInfo);
    }

    private void ClickLoginSetting()
    {
        //_data.RequestLoginInfo(30001);  // TODO 临时
        ShowUserSayEditor(true);
    }

    private void ClickLoginSendMessage(int index , string message)
    {
        Data.LoginInfo loginInfo = _data.loginInfos[index];
        Protocol.Client2Server_FinderPostLiveMsg(loginInfo.port,loginInfo.UserName, message);
    }

    private void ShowUserSayEditor(bool isShow)
    {
        GameObject.Find("Canvas/Top/UserSayEditor").gameObject.SetActive(isShow);
        RefreshUserSayEditor();
    }

    private void RefreshUserSayEditor()
    {
        GameObject.Find("Canvas/Top/UserSayEditor/Input").GetComponent<TMP_InputField>().text = string.Join("\n", _data.userSayInfos);
    }

    private void ClickUserSayEditorOkButton()
    {
        _data.userSayInfos.Clear();
        string inputvalue = GameObject.Find("Canvas/Top/UserSayEditor/Input").GetComponent<TMP_InputField>().text;
        string[] says = inputvalue.Split(new[] { '\n' }, System.StringSplitOptions.None);
        _data.userSayInfos = new List<string>(says);
        RefreshLoginSayInfo();
    }

    private void ClickUserSayEditorExitButton()
    {
        ShowUserSayEditor(false);
    }
    #endregion

    #region 直播间信息
    private void RefreshRoomInfo()
    {
        Transform roomFather = GameObject.Find("Canvas/RoomInfo").transform;
        StartCoroutine(DownloadImage(roomFather.Find("Icon").GetComponent<Image>(), _data.roomInfo.IconUrl));
        roomFather.Find("OnlineCount").GetComponent<TextMeshProUGUI>().text = _data.roomInfo.OnlineCount.ToString();
        roomFather.Find("LikeCount").GetComponent<TextMeshProUGUI>().text = _data.roomInfo.LikeCount.ToString();
        roomFather.Find("ParticipantCount").GetComponent<TextMeshProUGUI>().text = _data.roomInfo.ParticipantCount.ToString();
    }

    private void ClickRoomSearch(string message)
    {
        string nameInput = GameObject.Find("Canvas/RoomInfo/NameInput").GetComponent<TMP_InputField>().text;
        Data.LiveMsgInfo.objectId = GameObject.Find("Canvas/RoomInfo/NameInput1").GetComponent<TMP_InputField>().text;
        Data.LiveMsgInfo.objectNonceId = GameObject.Find("Canvas/RoomInfo/NameInput2").GetComponent<TMP_InputField>().text;

        Protocol.Client2Server_FinderGetCommentDetail(_data.loginInfos[0].port, _data.roomInfo);  // TODO
    }
    #endregion

    #region 欢迎信息
    private int _wellcomeReplayTimer;
    private void RefreshWellComeInfo()
    {
        Transform root = GameObject.Find("Canvas/WellComeInfo").transform;

        root.Find("TimeInput").GetComponent<TMP_InputField>().text = _data.wellComeInfo.InvervalTime.ToString();

        root.Find("ToggleToggle").GetComponent<Toggle>().isOn = _data.wellComeInfo.AutoToggle;
        root.Find("ReplayToggle").GetComponent<Toggle>().isOn = _data.wellComeInfo.ReplayToggle;

        var dropdown = root.Find("Dropdown").GetComponent<TMP_Dropdown>();
        FillDropDownInfo(_data.wellComeInfo.Says, dropdown.transform);

        Timer.Instance.RemoveTimer(_wellcomeReplayTimer);
        if (_data.wellComeInfo.ReplayToggle)
        {
            _wellcomeReplayTimer = Timer.Instance.AddTimer(_data.wellComeInfo.InvervalTime, (delta) =>
            {
                string select = dropdown.options[dropdown.value].text;
                // TODO
                Debug.Log("[欢迎语] " + select);
                if(_data.wellComeInfo.AutoToggle) dropdown.value = dropdown.value >= dropdown.options.Count - 1 ? 0 : dropdown.value + 1;
                return false;
            });
        }
    }

    private void ClickWellComeTimeReduce()
    {
        _data.wellComeInfo.InvervalTime -= 1;
        if (_data.wellComeInfo.InvervalTime < 1) _data.wellComeInfo.InvervalTime = 1;
        
        RefreshWellComeInfo();
    }

    private void ClickWellComeTimeAdd()
    {
        _data.wellComeInfo.InvervalTime += 1;
        RefreshWellComeInfo();
    }

    private void ClickWellComeToggleChange(bool isSelect)
    {
        _data.wellComeInfo.AutoToggle = isSelect;
    }

    private void ClickWellComeReplayChange(bool isSelect)
    {
        _data.wellComeInfo.ReplayToggle = isSelect;
        RefreshWellComeInfo();
    }
    private void ClickWellComenSetting()
    {
        ShowWellComeEditor(true);
    }

    private void ShowWellComeEditor(bool isShow)
    {
        GameObject.Find("Canvas/Top/WellComeEditor").gameObject.SetActive(isShow);
        RefreshWellComeEditor();
    }

    private void RefreshWellComeEditor()
    {
        GameObject.Find("Canvas/Top/WellComeEditor/Input").GetComponent<TMP_InputField>().text = string.Join("\n", _data.wellComeInfo.Says);
    }

    private void ClickWellComeEditorOkButton()
    {
        _data.wellComeInfo.Says.Clear();
        string inputvalue = GameObject.Find("Canvas/Top/WellComeEditor/Input").GetComponent<TMP_InputField>().text;
        string[] says = inputvalue.Split(new[] { '\n' }, System.StringSplitOptions.None);
        _data.wellComeInfo.Says = new List<string>(says);
        RefreshLoginSayInfo();
    }

    private void ClickWellComeEditorExitButton()
    {
        ShowWellComeEditor(false);
    }
    #endregion

    #region 关键字回复信息
    private int _keyInfoTimer;
    private void RefreshKeyInfo()
    {
        Transform root = GameObject.Find("Canvas/KeyInfo").transform;

        root.Find("TimeInput").GetComponent<TMP_InputField>().text = _data.keyInfo.InvervalTime.ToString();
        root.Find("ReplayToggle").GetComponent<Toggle>().isOn = _data.keyInfo.ReplayToggle;

        Timer.Instance.RemoveTimer(_keyInfoTimer);
        if (_data.keyInfo.ReplayToggle)
        {
            _keyInfoTimer = Timer.Instance.AddTimer(_data.keyInfo.InvervalTime, (delta) =>
            {
                // TODO 需要接通具体怎么回复的逻辑
                Debug.Log("[关键字] 回复中");
                return false;
            });
        }

        RefreshContent();
    }

    private void RefreshContent()
    {
        Transform root = GameObject.Find("Canvas/KeyInfo/ScrollView/Viewport/Content").transform;
        for(int i = 0 ; i < root.childCount; i++)
        {
            Transform child = root.GetChild(i);
            if (i <= _data.keyInfo.KeyItemInfos.Count - 1) 
            {
                child.Find("KeyInput").GetComponent<TMP_InputField>().text = _data.keyInfo.KeyItemInfos[i].Key;
                child.Find("ReplayInput").GetComponent<TMP_InputField>().text = _data.keyInfo.KeyItemInfos[i].Reply;
            }
        }
    }

    private void ClickKeyTimeReduce()
    {
        _data.keyInfo.InvervalTime -= 1;
        if (_data.keyInfo.InvervalTime < 1) _data.keyInfo.InvervalTime = 1;
        RefreshKeyInfo();
    }

    private void ClickKeyTimeAdd()
    {
        _data.keyInfo.InvervalTime += 1;
        RefreshKeyInfo();
    }

    private void ClickKeyReplayChange(bool isSelect)
    {
        _data.keyInfo.ReplayToggle = isSelect;
        RefreshKeyInfo();
    }

    private void ClickKeyClear(int index)
    {
        _data.keyInfo.KeyItemInfos[index].Key = "";
        _data.keyInfo.KeyItemInfos[index].Reply = "";
        Transform root = GameObject.Find("Canvas/KeyInfo/ScrollView/Viewport/Content").transform;
        Transform child = root.GetChild(index);
        child.Find("KeyInput").GetComponent<TMP_InputField>().text = "";
        child.Find("ReplayInput").GetComponent<TMP_InputField>().text = "";
    }
    #endregion

    #region 自动功能信息
    private int _autoLikeTimer;
    private int _autoBuyTimer;
    private void RefreshAutoInfo()
    {
        RefreshAutoLikeInfo();
        RefreshAutoBuyInfo();
    }
    private void RefreshAutoLikeInfo()
    {
        var random = new System.Random();
        Timer.Instance.RemoveTimer(_autoLikeTimer);
        if (_data.autoInfo.LikeToggle)
        {
            _autoLikeTimer = Timer.Instance.AddTimer(_data.autoInfo.LikeIntervalTime, (delta) =>
            {
                // 随机通过成员去点赞
                int index = random.Next(0, _data.loginInfos.Count);
                int likeCount = random.Next(1, 10);// TODO 随机点赞
                Protocol.Client2Server_LikeFinderLive(_data.loginInfos[index].port, likeCount);
                return false;
            });
        }

        GameObject.Find("Canvas/AutoInfo/LikeInput").GetComponent<TMP_InputField>().text = _data.autoInfo.LikeIntervalTime.ToString();
    }

    private void RefreshAutoBuyInfo()
    {
        Timer.Instance.RemoveTimer(_autoBuyTimer);
        if (_data.autoInfo.BuyToggle)
        {
            _autoBuyTimer = Timer.Instance.AddTimer(_data.autoInfo.BuyIntervalTime, (delta) =>
            {
                // TODO 这里需要发送请求
                Debug.Log("购买");
                return false;
            });
        }

        GameObject.Find("Canvas/AutoInfo/BuyInput").GetComponent<TMP_InputField>().text = _data.autoInfo.BuyIntervalTime.ToString();
    }

    private void ClickLikeTimeReduce()
    {
        _data.autoInfo.LikeIntervalTime -= 1;
        if (_data.autoInfo.LikeIntervalTime < 1) _data.autoInfo.LikeIntervalTime = 1;
        RefreshAutoLikeInfo();
    }
    private void ClickLikeTimeAdd()
    {
        _data.autoInfo.LikeIntervalTime += 1;
        RefreshAutoLikeInfo();
    }
    private void ClickLikeToggle(bool isSelect)
    {
        _data.autoInfo.LikeToggle = isSelect;
        RefreshAutoLikeInfo();
    }
    private void ClickBuyTimeReduce()
    {
        _data.autoInfo.BuyIntervalTime -= 1;
        if (_data.autoInfo.BuyIntervalTime < 1) _data.autoInfo.BuyIntervalTime = 1;
        RefreshAutoBuyInfo();
    }
    private void ClickBuyTimeAdd()
    {
        _data.autoInfo.BuyIntervalTime += 1;
        
        RefreshAutoBuyInfo();
    }
    private void ClickBuyToggle(bool isSelect)
    {
        _data.autoInfo.BuyToggle = isSelect;
        RefreshAutoBuyInfo();
    }
    #endregion

    #region 互助信息
    private int _helpSayTimer;
    private int _helpTitleIndex = 0;
    private void RefreshHelpSayInfo()
    {
        Transform root = GameObject.Find("Canvas/HelpInfo").transform;
        Transform rootTitle = root.Find("TittleScrollView/Viewport/Content").transform;
        for(int i = 0; i < rootTitle.childCount; i++)
        {
            if(i <= _data.helpSayInfo.HelpSayItemInfos.Count - 1)
            {
                rootTitle.GetChild(i).Find("Button/Text").GetComponent<TextMeshProUGUI>().text = _data.helpSayInfo.HelpSayItemInfos[i].Key;
            }
        }

        root.Find("ContentScrollView/Viewport/Input").GetComponent<TMP_InputField>().text = string.Join("\n", _data.helpSayInfo.HelpSayItemInfos[_helpTitleIndex].Value);

        root.Find("TimeInput").GetComponent<TMP_InputField>().text = _data.helpSayInfo.IntervalTime.ToString();

        Timer.Instance.RemoveTimer(_helpSayTimer);
        if (_data.helpSayInfo.ReplayToggle)
        {
            _helpSayTimer = Timer.Instance.AddTimer(_data.helpSayInfo.IntervalTime, (delta) =>
            {
                // TODO 这里需要发送请求
                Debug.Log("互助发言");
                return false;
            });
        }
    }

    private void ClickHelpTimeReduce()
    {
        _data.helpSayInfo.IntervalTime -= 1;
        if (_data.autoInfo.BuyIntervalTime < 1) _data.helpSayInfo.IntervalTime = 1;
        RefreshHelpSayInfo();
    }

    private void ClickHelpTimeAdd()
    {
        _data.helpSayInfo.IntervalTime += 1;
        RefreshHelpSayInfo();
    }

    private void ClickHelpToggle(bool isSelect)
    {
        _data.helpSayInfo.ReplayToggle = isSelect;
        RefreshHelpSayInfo();
    }

    private void ClickHelpTitleButton(int index)
    {
        _helpTitleIndex = index;
        RefreshHelpSayInfo();
    }
    #endregion

    #region 飘屏信息
    private int _screenSayTimer;
    private int _screenTitleIndex = 0;
    private void RefreshScreenInfo()
    {
        Transform root = GameObject.Find("Canvas/ScreenInfo").transform;
        Transform rootTitle = root.Find("ScrollView/Viewport/Content").transform;
        for (int i = 0; i < rootTitle.childCount; i++)
        {
            if (i <= _data.screenInfo.ScreenItemInfos.Count - 1)
            {
                rootTitle.GetChild(i).Find("Button/Text").GetComponent<TextMeshProUGUI>().text = _data.screenInfo.ScreenItemInfos[i].Key;
            }
        }

        root.Find("ContenInput").GetComponent<TMP_InputField>().text = _data.screenInfo.ScreenItemInfos[_screenTitleIndex].Value;

        root.Find("TimeInput").GetComponent<TMP_InputField>().text = _data.screenInfo.IntervalTime.ToString();

        Timer.Instance.RemoveTimer(_screenSayTimer);
        if (_data.screenInfo.ReplayToggle)
        {
            _screenSayTimer = Timer.Instance.AddTimer(_data.screenInfo.IntervalTime, (delta) =>
            {
                // TODO 这里需要发送请求
                Debug.Log("飘屏" + root.Find("ContenInput").GetComponent<TMP_InputField>().text);
                return false;
            });
        }
    }

    private void ClickScreenTimeReduce()
    {
        _data.screenInfo.IntervalTime -= 1;
        if (_data.autoInfo.BuyIntervalTime < 1) _data.screenInfo.IntervalTime = 1;
        RefreshScreenInfo();
    }

    private void ClickScreenTimeAdd()
    {
        _data.screenInfo.IntervalTime += 1;
        RefreshScreenInfo();
    }

    private void ClickScreenToggle(bool isSelect)
    {
        _data.screenInfo.ReplayToggle = isSelect;
        RefreshScreenInfo();
    }

    private void ClickScreenTitleButton(int index)
    {
        _screenTitleIndex = index;
        RefreshScreenInfo();
    }

    private void MSG_Puppetattr_Update()
    {
        RefreshScreenInfo();
    }
    #endregion

    #region 留言信息
    private int _messageTimer;
    private void RefreshMessageInfo()
    {
        Timer.Instance.RemoveTimer(_messageTimer);
        if (_data.messageInfo.AutoToggle)
        {
            _messageTimer = Timer.Instance.AddTimer(1, (delta) =>
            {
                // TODO 这里需要发送请求
                Debug.Log("留言");
                var user = _data.loginInfos[0];
                Protocol.Client2Server_FinderGetLiveMsg(user.port, _data.messageInfo);
                return false;
            });
        }

        RefreshMessageContentInfo();
    }

    private void RefreshMessageContentInfo()
    {
        GameObject.Find("Canvas/MessageInfo/Content/Text").GetComponent<TextMeshProUGUI>().text = string.Join("\n", _data.messageInfo.messages);
    }

    private void ClickMessageChange(bool isSelect)
    {
        _data.messageInfo.AutoToggle = isSelect;
        RefreshMessageInfo();
    }

    private void MSG_MessageInfo_Update(MessageManager.Message m)
    {
        RefreshMessageContentInfo();
    }
    #endregion

    #region UI

    private void RegisterMessage()
    {
        MessageManager.Instance.RegisterMessage(Protocol.MSG_LoginInfo_Update,MSG_LoginInfo_Update);
        MessageManager.Instance.RegisterMessage(Protocol.MSG_MessageInfo_Update,MSG_MessageInfo_Update);
        MessageManager.Instance.RegisterMessage(Protocol.MSG_Puppetattr_Update,MSG_Puppetattr_Update);

        // Login
        Transform loginFather = GameObject.Find("Canvas/HeadInfo/Panel").transform;
        loginFather.parent.Find("SettingButton").GetComponent<Button>().onClick.AddListener(ClickLoginSetting);
        for (int i = 0 ; i < loginFather.childCount; i++)
        {
            int index = i;
            loginFather.GetChild(index).Find("Logined/SendButton").GetComponent<Button>().onClick.AddListener(() =>
            {
                int selectI = loginFather.GetChild(index).Find("Dropdown").GetComponent<TMP_Dropdown>().value;
                string sendMessge = loginFather.GetChild(index).Find("Dropdown").GetComponent<TMP_Dropdown>().options[selectI].text;
                ClickLoginSendMessage(index, sendMessge);
            });
        }

        // Room
        Transform roomFather = GameObject.Find("Canvas/RoomInfo").transform;
        string roomInputSearch = roomFather.Find("NameInput").GetComponent<TMP_InputField>().text;
        roomFather.Find("Button").GetComponent<Button>().onClick.AddListener(() =>
        {
            ClickRoomSearch(roomInputSearch);
        });

        //// 欢迎
        Transform wellComeFather = GameObject.Find("Canvas/WellComeInfo").transform;
        wellComeFather.Find("SettingButton").GetComponent<Button>().onClick.AddListener(ClickWellComenSetting);
        wellComeFather.Find("ReduceButton").GetComponent<Button>().onClick.AddListener(ClickWellComeTimeReduce);
        wellComeFather.Find("AddButton").GetComponent<Button>().onClick.AddListener(ClickWellComeTimeAdd);
        wellComeFather.Find("ToggleToggle").GetComponent<Toggle>().onValueChanged.AddListener(ClickWellComeToggleChange);
        wellComeFather.Find("ReplayToggle").GetComponent<Toggle>().onValueChanged.AddListener(ClickWellComeReplayChange);

        // 关键字
        Transform keyInfoRoot = GameObject.Find("Canvas/KeyInfo").transform;
        keyInfoRoot.Find("ReduceButton").GetComponent<Button>().onClick.AddListener(ClickKeyTimeReduce);
        keyInfoRoot.Find("AddButton").GetComponent<Button>().onClick.AddListener(ClickKeyTimeAdd);
        keyInfoRoot.Find("ReplayToggle").GetComponent<Toggle>().onValueChanged.AddListener(ClickKeyReplayChange);
        Transform keyContent = GameObject.Find("Canvas/KeyInfo/ScrollView/Viewport/Content").transform;
        for (int i = 0; i < keyInfoRoot.childCount; i++)
        {
            int index = i;
            keyContent.GetChild(index).Find("DeleteButton").GetComponent<Button>().onClick.AddListener(() => 
            {
                ClickKeyClear(index);
            });
            keyContent.GetChild(index).Find("KeyInput").GetComponent<TMP_InputField>().onValueChanged.AddListener((value) => 
            {
                _data.keyInfo.KeyItemInfos[index].Key = value;
            });
            keyContent.GetChild(index).Find("ReplayInput").GetComponent<TMP_InputField>().onValueChanged.AddListener((value) =>
            {
                _data.keyInfo.KeyItemInfos[index].Reply = value;
            });
        }

        // 自动功能
        Transform autoFather = GameObject.Find("Canvas/AutoInfo").transform;
        autoFather.Find("LikeReduceButton").GetComponent<Button>().onClick.AddListener(ClickLikeTimeReduce);
        autoFather.Find("LikeAddButton").GetComponent<Button>().onClick.AddListener(ClickLikeTimeAdd);
        autoFather.Find("BuyReduceButton").GetComponent<Button>().onClick.AddListener(ClickBuyTimeReduce);
        autoFather.Find("BuyAddButton").GetComponent<Button>().onClick.AddListener(ClickBuyTimeAdd);
        autoFather.Find("LikeToggle").GetComponent<Toggle>().onValueChanged.AddListener(ClickLikeToggle);
        autoFather.Find("BuyToggle").GetComponent<Toggle>().onValueChanged.AddListener(ClickBuyToggle);

        // 互助发言
        Transform helpRoot = GameObject.Find("Canvas/HelpInfo").transform;
        helpRoot.Find("ReduceButton").GetComponent<Button>().onClick.AddListener(ClickHelpTimeReduce);
        helpRoot.Find("AddButton").GetComponent<Button>().onClick.AddListener(ClickHelpTimeAdd);
        helpRoot.Find("ReplayToggle").GetComponent<Toggle>().onValueChanged.AddListener(ClickHelpToggle);
        for(int i = 0; i < helpRoot.Find("TittleScrollView/Viewport/Content").childCount; i++)
        {
            int index = i;
            Transform root = helpRoot.Find("TittleScrollView/Viewport/Content").GetChild(index);
            root.Find("Button").GetComponent<Button>().onClick.AddListener(() => 
            {
                ClickHelpTitleButton(index);
            });
        }

        //// 弹幕
        GameObject.Find("Canvas/MessageInfo/OpenToggle").GetComponent<Toggle>().onValueChanged.AddListener(ClickMessageChange);

        // 飘屏
        Transform screenRoot = GameObject.Find("Canvas/ScreenInfo").transform;
        screenRoot.Find("ReduceButton").GetComponent<Button>().onClick.AddListener(ClickScreenTimeReduce);
        screenRoot.Find("AddButton").GetComponent<Button>().onClick.AddListener(ClickScreenTimeAdd);
        screenRoot.Find("ReplayToggle").GetComponent<Toggle>().onValueChanged.AddListener(ClickScreenToggle);
        for (int i = 0; i < screenRoot.Find("ScrollView/Viewport/Content").childCount; i++)
        {
            int index = i;
            Transform root = screenRoot.Find("ScrollView/Viewport/Content").GetChild(index);
            root.Find("Button").GetComponent<Button>().onClick.AddListener(() =>
            {
                ClickScreenTitleButton(index);
            });
        }

        // TOP
        GameObject.Find("Canvas/Top/UserSayEditor/OKButton").GetComponent<Button>().onClick.AddListener(ClickUserSayEditorOkButton);
        GameObject.Find("Canvas/Top/UserSayEditor/ExitButton").GetComponent<Button>().onClick.AddListener(ClickUserSayEditorExitButton);
        GameObject.Find("Canvas/Top/WellComeEditor/OKButton").GetComponent<Button>().onClick.AddListener(ClickWellComeEditorOkButton);
        GameObject.Find("Canvas/Top/WellComeEditor/ExitButton").GetComponent<Button>().onClick.AddListener(ClickWellComeEditorExitButton);
    }

    #endregion

    #region Common

    private void FillDropDownInfo(List<string> infos , Transform dropdown)
    {
        List<OptionData> options = new List<OptionData>();
        for (int i = 0; i < infos.Count; i++)
        {
            options.Add(new OptionData(infos[i]));
        }
        dropdown.GetComponent<TMP_Dropdown>().ClearOptions();
        dropdown.GetComponent<TMP_Dropdown>().AddOptions(options);
    }

    /// <summary>
    /// 下载头像
    /// </summary>
    /// <param name="image"></param>
    /// <param name="url"></param>
    /// <returns></returns>
    IEnumerator DownloadImage(Image image, string url)
    {
        using (UnityWebRequest request = UnityWebRequestTexture.GetTexture(url))
        {
            yield return request.SendWebRequest();

            if (request.result != UnityWebRequest.Result.Success)
            {
                Debug.LogError(request.error);
            }
            else
            {
                Texture2D texture = ((DownloadHandlerTexture)request.downloadHandler).texture;
                Sprite sprite = Sprite.Create(texture, new Rect(0, 0, texture.width, texture.height), new Vector2(0.5f, 0.5f));
                image.sprite = sprite;
            }
        }
    }
    #endregion
}