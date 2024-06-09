using System.Collections.Generic;
using UnityEngine;
using System;

public class GUIParams : MonoBehaviour
{
    [Serializable]
    public class Param
    {
        public string Name;
        public GameObject GameObject;
    }

    [SerializeField]
    public List<Param> Params;
}
