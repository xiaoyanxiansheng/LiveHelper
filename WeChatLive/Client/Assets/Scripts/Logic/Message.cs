using System.Collections.Generic;

public class MessageManager
{

    public class Message
    {
        public Message(string name)
        {
            this.name = name;
        }
        public string name;
        public MessageDelegate messageCall;
        public object[] ps;
    }

    public delegate void MessageDelegate(Message m);

    private Dictionary<string, List<Message>> _mesageMap = new Dictionary<string, List<Message>>();

    private static MessageManager _instance;
    public static MessageManager Instance
    {
        get {
                if (_instance == null)
                {
                    _instance = new MessageManager();
                }
                return _instance;
            }
    }

    public void SendMessage(string msgName , params object[] ps)
    {
        Message m = BeginMessage(msgName);
        m.ps = ps;
        SendMessage(m);
    }

    public void SendMessage(Message msg)
    {
        DispatchMessage(msg);
    }

    public void RegisterMessage(string msgName , MessageDelegate messageCall)
    {
        Message m = BeginMessage(msgName);
        m.messageCall = messageCall;

        if (!_mesageMap.ContainsKey(m.name))
        {
            _mesageMap[m.name] = new List<Message>();
        }

        if (!_mesageMap[m.name].Contains(m))
        {
            _mesageMap[m.name].Add(m);
        }
    }

    public void RegisterMessage(Message m)
    {
        if (!_mesageMap.ContainsKey(m.name))
        {
            _mesageMap[m.name] = new List<Message>();
        }

        if (!_mesageMap[m.name].Contains(m))
        {
            _mesageMap[m.name].Add(m);
        }
    }

    public void RemoveMessage(Message m)
    {
        if (!_mesageMap.ContainsKey(m.name)) return;

        if (!_mesageMap[m.name].Contains(m)) return;

        _mesageMap[m.name].Remove(m);
    }

    public Message BeginMessage(string msgName)
    {
        Message data = new Message(msgName);
        return data;
    }
    

    private void DispatchMessage(Message msg)
    {
        if (!_mesageMap.ContainsKey(msg.name)) return;

        for(int i = 0; i< _mesageMap[msg.name].Count; i++)
        {
            Message m = _mesageMap[msg.name][i];
            m.messageCall.Invoke(msg);
        }
    }
}