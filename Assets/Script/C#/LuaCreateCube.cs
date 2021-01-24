using System;
using SLua;
using System.IO;
using UnityEngine;

public class LuaCreateCube : MonoBehaviour
{
    private static LuaSvr luaSvr;

    public void Start()
    {
        luaSvr = new LuaSvr();
        LuaSvr.mainState.loaderDelegate += LuaLoader;
        luaSvr.init(null, () =>
        {
            luaSvr.start("CreateCube.Lua");
        });
    }

    private static byte[] LuaLoader(string filename, ref string str)
    {
        string path = Application.dataPath + "/Script/Lua/" + filename;
        return File.ReadAllBytes(path);
    }
}
