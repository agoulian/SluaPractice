using System.IO;
using SLua;
using UnityEngine;

public class SLuaPackage : MonoBehaviour
{
    private static LuaSvr luaSvr;
    public static int a = 10;
    private static byte[] LuaLoader(string filename, ref string str)
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
            luaSvr.start("MyPackage.Lua");
        });
    }

}
