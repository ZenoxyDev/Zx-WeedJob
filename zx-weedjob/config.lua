Config = {}

Config.NPCSpawnPoints = {
    {
        model = "s_m_y_dealer_01",
        coords = vector3(2224.47, 5604.9, 54.92),
    },
}

Config.CollectPoints = {
    {pos = vector3(2217.11, 5577.92, 53.83)},
    {pos = vector3(2222.6, 5577.44, 53.84)},
    {pos = vector3(2228.75, 5576.99, 53.88)},
}
Config.ProcessingPoints = {
    {pos = vector3(803.28, 2175.2, 53.07)},
}


function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())

    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)

    local factor = (string.len(text)) / 370

    SetDrawOrigin(x, y, z, 0)
    DrawRect(0.0, 0.0125, 0.0175 + factor, 0.03, 0, 0, 0, 100)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end
