import "UnityEngine"

if not UnityEngine.GameObject then
	error("Click Make/All to generate lua wrap file")
end

function Create()
	local prefab=Resources.Load("Prefab/MyCube")
	GameObject.Instantiate(prefab)
end

Create()
