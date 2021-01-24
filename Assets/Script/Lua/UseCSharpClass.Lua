import "UnityEngine"

function Use()
	local ob=GameObject.Find("UseCSharpClass")
	local cs=ob:GetComponent("UseCSharpClass")
	print("a=" .. cs.a)
end

Use()
