using System.Collections;
using TMPro;
using UnityEngine;
using UnityEngine.Networking;
using UnityEngine.UI;

public class UIManger : MonoBehaviour
{
    private Data _data;
    private Timer _timer;
    private MessageManager _messageManager;

    void Start()
    {
        InitUI();

        _timer = new Timer();
        _data = new Data();
        _messageManager = new MessageManager();

        RegisterMessage();


        RefreshLike();
    }

    // Update is called once per frame
    void Update()
    {
        _timer.FixedUpdate();
    }

    #region 头像信息
    /// <summary>
    /// 添加微信
    /// </summary>
    private void ClickAddWeChat()
    {
        
    }

    /// <summary>
    /// 更新头像信息
    /// </summary>
    private void UpdateHeadInfo()
    {
        int index = 0;
        var headInfos = _data.HeadInfos;
        foreach (var headInfo in headInfos.Values)
        {
            StartCoroutine(DownloadImage(HeadInfoObj.GetChild(index).Find("HeadIcon").GetComponent<Image>(), headInfo.IconUrl));
            HeadInfoObj.GetChild(index).Find("Name").GetComponent<TextMeshProUGUI>().text = headInfo.Name;
            HeadInfoObj.GetChild(index).gameObject.SetActive(true);
            index++;
        }
        for (int i = headInfos.Keys.Count; i < HeadInfoObj.childCount; i++)
        {
            HeadInfoObj.GetChild(i).gameObject.SetActive(false);
        }
    }
    /// <summary>
    /// 下载头像
    /// </summary>
    /// <param name="image"></param>
    /// <param name="url"></param>
    /// <returns></returns>
    IEnumerator DownloadImage(Image image,string url)
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
    
    private void MSG_LoginInfo_Update(MessageManager.Message m)
    {
        UpdateHeadInfo();
    }

    private void ClickHeadRefreah()
    {
        _data.RequestLoginInfo(30001);
    }
    #endregion

    #region 点赞
    private bool _isAutoLike = false;
    private int _autoLikeTimer = -1;

    private void RefreshLike()
    {
        RefreshLikeText();
    }
    
    private void RefreshLikeText()
    {
        LikeText.GetComponent<TextMeshProUGUI>().text = _isAutoLike ? "点赞中" : "已暂停";
    }
    
    /// <summary>
    /// 点赞
    /// </summary>
    private void ClickLikeButton()
    {
        Timer.Instance.RemoveTimer(_autoLikeTimer);
        if (_isAutoLike)
        {
            _autoLikeTimer = Timer.Instance.AddTimer(1, (delta) =>
            {
                _data.RequestLike(30001);
                return true;
            });
        }
    }
    #endregion


    #region UI

    private void RegisterMessage()
    {
        HeadRefreshButton.GetComponent<Button>().onClick.AddListener(ClickHeadRefreah);
        LikeButton.GetComponent<Button>().onClick.AddListener(ClickLikeButton);

        MessageManager.Instance.RegisterMessage(Protocol.MSG_LoginInfo_Update,MSG_LoginInfo_Update);
    }
    
    
    private Transform HeadInfoObj;
    private Transform HeadRefreshButton;

    private Transform LikeButton;
    private Transform LikeText;
    
    private void InitUI()
    {
        HeadInfoObj = GameObject.Find("Canvas/Content/Panel/Image").transform;
        HeadRefreshButton = HeadInfoObj.GetChild(HeadInfoObj.childCount - 1).Find("Button");
        
        LikeButton = GameObject.Find("Canvas/Content/Panel1/Like/LikeButton").transform;
        LikeText = LikeButton.Find("LikeText");
    }
    #endregion
}
