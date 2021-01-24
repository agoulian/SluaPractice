using System;
using System.IO;
using SLua;
using UnityEngine;

public class CreatePrefab : MonoBehaviour
{
    private static LuaSvr luaSvr;

    private static byte[] LuaLoader(string filename,ref string str)
    {
        string path = Application.dataPath + "/Script/Lua/" + filename;
        return File.ReadAllBytes(path);
    }

    void Start()
    {
        luaSvr = new LuaSvr();
        LuaSvr.mainState.loaderDelegate += LuaLoader;
        luaSvr.init(null, () =>
        {
            luaSvr.start("CreatePrefab.Lua");
        });
    }
    
}
