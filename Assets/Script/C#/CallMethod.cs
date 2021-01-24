using System;
using SLua;
using System.IO;
using UnityEngine;

public class CallMethod : MonoBehaviour
{
    private static LuaSvr luaSvr;
    private LuaFunction LuaAwake = null;
    private LuaFunction LuaStart = null;
    private LuaFunction LuaUpdate = null;

    private static byte[] LuaLoader(string filename,ref string dtr)
    {
        string path = Application.dataPath + "/Script/Lua/" + filename;
        return File.ReadAllBytes(path);
    }

    public void Awake()
    {
        luaSvr = new LuaSvr();
        LuaSvr.mainState.loaderDelegate += LuaLoader;
        luaSvr.init(null, () =>
        {
            luaSvr.start("CallMethod.Lua");
            LuaAwake=LuaSvr.mainState.getFunction("Awake");
            LuaStart = LuaSvr.mainState.getFunction("Start");
            LuaUpdate = LuaSvr.mainState.getFunction("Update");
        });
        if (LuaAwake != null)
            LuaAwake.call();
    }

    public void Start()
    {
        if (LuaStart != null)
            LuaStart.call();
    }

    public void Update()
    {
        if (LuaUpdate != null)
            LuaUpdate.call();
    }
}