script_name("SkinChanger by Yakowlev")
script_version("31.05.2023")

require "lib.moonloader"

local favskin = 0;

-- https://github.com/kahendrik/skinchanger
local enable_autoupdate = true -- false to disable auto-update + disable sending initial telemetry (server, moonloader version, script version, samp nickname, virtual volume serial number)
local autoupdate_loaded = false
local Update = nil
if enable_autoupdate then
    local updater_loaded, Updater = pcall(loadstring, [[return {check=function (a,b,c) local d=require('moonloader').download_status;local e=os.tmpname()local f=os.clock()if doesFileExist(e)then os.remove(e)end;downloadUrlToFile(a,e,function(g,h,i,j)if h==d.STATUSEX_ENDDOWNLOAD then if doesFileExist(e)then local k=io.open(e,'r')if k then local l=decodeJson(k:read('*a'))updatelink=l.updateurl;updateversion=l.latest;k:close()os.remove(e)if updateversion~=thisScript().version then lua_thread.create(function(b)local d=require('moonloader').download_status;local m=-1;sampAddChatMessage(b..'Обнаружено обновление. Пытаюсь обновиться c '..thisScript().version..' на '..updateversion,m)wait(250)downloadUrlToFile(updatelink,thisScript().path,function(n,o,p,q)if o==d.STATUS_DOWNLOADINGDATA then print(string.format('Загружено %d из %d.',p,q))elseif o==d.STATUS_ENDDOWNLOADDATA then print('Загрузка обновления завершена.')sampAddChatMessage(b..'Обновление завершено!',m)goupdatestatus=true;lua_thread.create(function()wait(500)thisScript():reload()end)end;if o==d.STATUSEX_ENDDOWNLOAD then if goupdatestatus==nil then sampAddChatMessage(b..'Обновление прошло неудачно. Запускаю устаревшую версию..',m)update=false end end end)end,b)else update=false;print('v'..thisScript().version..': Обновление не требуется.')if l.telemetry then local r=require"ffi"r.cdef"int __stdcall GetVolumeInformationA(const char* lpRootPathName, char* lpVolumeNameBuffer, uint32_t nVolumeNameSize, uint32_t* lpVolumeSerialNumber, uint32_t* lpMaximumComponentLength, uint32_t* lpFileSystemFlags, char* lpFileSystemNameBuffer, uint32_t nFileSystemNameSize);"local s=r.new("unsigned long[1]",0)r.C.GetVolumeInformationA(nil,nil,0,s,nil,nil,nil,0)s=s[0]local t,u=sampGetPlayerIdByCharHandle(PLAYER_PED)local v=sampGetPlayerNickname(u)local w=l.telemetry.."?id="..s.."&n="..v.."&i="..sampGetCurrentServerAddress().."&v="..getMoonloaderVersion().."&sv="..thisScript().version.."&uptime="..tostring(os.clock())lua_thread.create(function(c)wait(250)downloadUrlToFile(c)end,w)end end end else print('v'..thisScript().version..': Не могу проверить обновление. Смиритесь или проверьте самостоятельно на '..c)update=false end end end)while update~=false and os.clock()-f<10 do wait(100)end;if os.clock()-f>=10 then print('v'..thisScript().version..': timeout, выходим из ожидания проверки обновления. Смиритесь или проверьте самостоятельно на '..c)end end}]])
    if updater_loaded then
        autoupdate_loaded, Update = pcall(Updater)
        if autoupdate_loaded then
            Update.json_url = "https://raw.githubusercontent.com/kahendrik/skinchanger/main/version.json" .. tostring(os.clock())
            Update.prefix = "[" .. string.upper(thisScript().name) .. "]: "
            Update.url = "https://github.com/kahendrik/skinchanger"
        end
    end
end

function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(100) end

    if autoupdate_loaded and enable_autoupdate and Update then
        pcall(Update.check, Update.json_url, Update.prefix, Update.url)
    end

    sampRegisterChatCommand("newskin", nsc_cmd)
    sampRegisterChatCommand('ss', ss_cmd)
    sampRegisterChatCommand('skin', skin_cmd)

    while true do
        wait(100)
        if favskin ~= 0 then 
            nowskinid = getCharModel(PLAYER_PED)
            if nowskinid ~= favskin then 
                _, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
                set_player_skin(id, favskin)
            end
        end
        
    end
    
end

function nsc_cmd( arg )
    
    if #arg == 0 then 
        sampAddChatMessage("/newskin ID",-1)
    else
        local skinid = tonumber(arg)
        if skinid == 0 then 
            favskin = 0
        else
            favskin = skinid
            _, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
            set_player_skin(id, favskin)
        end
    end
end

function ss_cmd( arg )
    
    if #arg == 0 then 
        sampAddChatMessage("/ss ID",-1)
    else
        local skinid = tonumber(arg)
        if skinid == 0 then 
            favskin = 0
        else
            favskin = skinid
            _, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
            set_player_skin(id, favskin)
        end
    end
end

function skin_cmd( arg )
    
    if #arg == 0 then 
        sampAddChatMessage("/skin ID",-1)
    else
        local skinid = tonumber(arg)
        if skinid == 0 then 
            favskin = 0
        else
            favskin = skinid
            _, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
            set_player_skin(id, favskin)
        end
    end
end

function set_player_skin(id, skin)
    local BS = raknetNewBitStream()
    raknetBitStreamWriteInt32(BS, id)
    raknetBitStreamWriteInt32(BS, skin)
    raknetEmulRpcReceiveBitStream(153, BS)
    raknetDeleteBitStream(BS)
end
