-- X1 de times personalizado
-- ~Fofinhoppp
math.randomseed(os.time())
tfm.exec.setRoomMaxPlayers(100)

tfm.exec.disableAutoScore()
tfm.exec.disableAutoShaman()
tfm.exec.disablePhysicalConsumables()
tfm.exec.disableAutoNewGame()
tfm.exec.disableAutoTimeLeft()
tfm.exec.setGameTime(99999999)

local _S = {
    admin = 'Pidoninho#0000',
    teams = {
        red = {
            color = '#FF0000',
            players = {},
            score = 0,
        },
        blue = {
            color = '#0000FF',
            players = {},
            score = 0,
        },
        yellow = {
            color = '#FFFF00',
            players = {},
            score = 0,
        },
        green = {
            color = '#00FF00',
            players = {},
            score = 0,
        },},
    translactions = {
        red = 'Vermelho',
        blue = 'Azul',
        yellow = 'Amarelo',
        green = 'Verde',},
    players = {},
    playersAlive = 0,
    state = 'lobby',
    rotation = 17,
    nextMap = nil,
    roundScore = 1,
    roundScored = false,
    messaged = nil,
    randomTeams = false,
    mapsCat = {3, 7, 17, 18, 'Burlas'},
    maps = {
        ['Burlas'] = {7372855,7372863,7372867,7372869,7372870,7372875,7372877,7372880,7372884,7372885,7372887,7372889,7372894,7372895,7372896,7372897,7372898,7372899,7372901,7372906,7372908,7372909,7372910,7372914,7372916,7372917,7372920,7372944,7372945,7372947,7372948,7372952,7372953,7372955,7372957,7372958,7372959,7372960,7372962,7372963,7372964,7372968,7372970,7372973,7372977,7372978,7373435,7373446,7373451,7373452,7373456,7373464,7373467,7373473,7373478,7373487,7373491,7373492,7373495,7373500,7373506,7373511,7373513,7373524,7373526,7373533,7373535,7373539,7373542,7373546,7373552,7373715,7373721,7373726,7373731,7373734,7373736,7373738,7373749,7373750,7373752,7373756,7373773,7373774,7373778,7373780,7373783,7373788,7373791,7373795,7329536,7467908,7467909,7467918,7467919,7467920,7467922,7467923,7467927,7467929,7467930,7467931,7467934,7467935,7467937,7467939,7467941,7467942,7467944,7467945,7467946,7467948,7467950,7467953,7467954,7467955,7467957,7467961,7467965,7467966,7467970,7467971,7467973,7467975,7467982,7467983,7481567,7488641,7488645,7488652,7488653,7488655,7488659,7488661,7488663,7488665,7488667,7488669,7488671,7488672,7488674,7488675,7488677,7488680,7488681,7488683,7488684,7488685,7488687,7488690,7488691,7488692,7488693,7488695,7488698,7488700,7488702,7488705,7488706,7488707,7488711,7488712,7488713,7581343,7581345,7581348,7581349,7581352,7581353,7581357,7581358,7581361,7581362,7581364,7581367,7581371,7587180,7587181,7587182,7587184,7587185,7587186,7587189,7587191,7587192,7588919,7590309,7590315,7590319,7590322,7590325,7590326,7590331,7590334,7590337,7590338,7590339,7590343,7590344,7590515,7590516,7590518,7590519,7590520,7590521,7590524,7590526,7590527,7590528,7590533,7590534,7590536,7590537,7590540,7590541},
    },
}

function eventNewPlayer(player)
    if not _S.players[player] then
        _S.players[player] = {
            team = nil,
        }
    end
    loadScore()
    lobby()
end

function genBarLine(id, x, y, h, player)
    if not player then player = nil end
    ui.addTextArea(id, '', player, x, y, h, 10, 0, 1, 1, true)
    ui.addTextArea(id+1, '', player, x-5, y-5, h+10, 10, 0xFFFFFF, 0xFFFFFF, 1, true)
end

function table.shuffle(t)
    local rand = math.random
    assert(t, "table.shuffle() expected a table, got nil")
    local iterations = #t
    local j

    for i = iterations, 2, -1 do
        j = rand(i)
        t[i], t[j] = t[j], t[i]
    end
end

function loadScore()
    if _S.state == 'started' or _S.state == 'podium' then
        for i, v in pairs(tfm.get.room.playerList) do
            if _S.players[i].team then
                ui.addTextArea(0, string.format('<p align="center"><font size="15">%s x %s x %s x %s / %s', '<font color="'.._S.teams.red.color..'">' .. _S.teams.red.score ..'</font>', '<font color="'.._S.teams.blue.color..'">' .. _S.teams.blue.score ..'</font>', '<font color="'.._S.teams.yellow.color..'">' .. _S.teams.yellow.score ..'</font>', '<font color="'.._S.teams.green.color..'">' .. _S.teams.green.score ..'</font>', _S.roundScore), i, 5, 25, 790, 20, 0, 0, 0, true)
            else
                ui.addTextArea(0, string.format('<p align="center"><font size="15">%s x %s x %s x %s / %s <font color="#000000"><a href="event:join">Join', '<font color="'.._S.teams.red.color..'">' .. _S.teams.red.score ..'</font>', '<font color="'.._S.teams.blue.color..'">' .. _S.teams.blue.score ..'</font>', '<font color="'.._S.teams.yellow.color..'">' .. _S.teams.yellow.score ..'</font>', '<font color="'.._S.teams.green.color..'">' .. _S.teams.green.score ..'</font>', _S.roundScore), i, 5, 25, 790, 20, 0, 0, 0, true)
            end
        end
    end
end

function lobby()
    if _S.state ~= 'lobby' then return end
    ui.addTextArea(0, '\n\n<font color="#000000" size="15">Admin: '.. _S.admin ..'', nil, 5, 5, 790, 390, 0xFFFFFF, 0xFFFFFF, 0, true)
    genBarLine(10, 200, 80, 460)
    if tonumber(_S.rotation) then
        ui.addTextArea(12, '<font color="#000000" size="15"><p align="center">Rotação: P'.. _S.rotation, nil, 200, 68, 460, 30, 0, 1, 0, true)
    else
        ui.addTextArea(12, '<font color="#000000" size="15"><p align="center">Rotação: '.. _S.rotation, nil, 200, 68, 460, 30, 0, 1, 0, true)
    end
    for i, v in pairs({'red', 'blue', 'yellow', 'green'}) do
        local text = {}
        for i, v in pairs(_S.teams[v].players) do
            if v then
                text[#text+1] = v ..'\n'
            end
        end
        ui.addTextArea(i, '<font color="#000000" size="10">'.. table.concat(text), nil, (i-1)*120 + 200, 150, 100, 300, '0x' .. _S.teams[v].color:sub(2,7), '0x' .. _S.teams[v].color:sub(2,7), 1, true)
        if not _S.randomTeams then
            ui.addTextArea(i+5, '<p align="center"><a href="event:join_'..v..'"><font color="#000000" size="15">Join</font></a>\nTime '.. _S.translactions[v] .. '</p>', nil, (i-1)*120 + 200, 100, 100, 300, 0, 0, 0, true)
        else
            ui.addTextArea(i+5, '<p align="center"><font color="#C1C1C1" size="15">Join</font>\nTime '.. _S.translactions[v] .. '</p>', nil, (i-1)*120 + 200, 100, 100, 300, 0, 0, 0, true)
        end
    end
    for i, v in pairs({'Rotação', 'Pontos', 'Random'}) do
        genBarLine(13 + (i-1)*3, 20, (i-1)*50 + 230, 150, _S.admin)
        ui.addTextArea(15 + (i-1)*3, '<font color="#000000" size="15"><p align="center"><a href="event:'..v..'">'.. v, _S.admin, 0, (i-1)*50 + 250-12-20, 200, 30, 0, 1, 0, true)
    end
    genBarLine(22 , 700, 350, 80, _S.admin)
    ui.addTextArea(24, '<font color="#000000" size="15"><p align="center"><a href="event:start">Start', _S.admin, 640, 370-12-20, 200, 30, 0, 1, 0, true)
    ui.setMapName('Lobby')
end

function eventTextAreaCallback(id, player, callback)
    if callback:sub(1, 5) == 'join_' then
        local team = callback:sub(6)
            if team == _S.players[player].team then return end
            if _S.players[player].team then
                for i, v in pairs(_S.teams[_S.players[player].team].players) do
                    if v == player then
                        _S.teams[_S.players[player].team].players[i] = nil
                        break
                    end
                end
            end
            _S.players[player].team = team
            _S.teams[team].players[#_S.teams[team].players+1] = player
            lobby()
    elseif callback == 'start' then
        _S.state = 'started'
        newRound()
    elseif callback == 'Random' then
        local rplayers = {}
        for name in pairs(tfm.get.room.playerList) do
            table.insert(rplayers, name)
        end
        for i, v in pairs(_S.teams) do
            v.players = {}
        end
        table.shuffle(rplayers)
        for i = 1, #rplayers do
            local name = rplayers[i]
            local team = nil
            if (i % 4 == 1) then
                team = 'red'
            elseif (i % 4 == 2) then
                team = 'blue'
            elseif (i % 4 == 3) then
                team = 'yellow'
            else
                team = 'green'
            end
            _S.players[name].team = team
            _S.teams[team].players[#_S.teams[team].players+1] = name
        end
        _S.randomTeams = true
        lobby()
    elseif callback == 'Rotação' then
        local text = {}
        for i, v in pairs(_S.mapsCat) do
            text[#text+1] = '<a href="event:rot_'..v..'">'.. v .. '</a>\n'
        end
        ui.addTextArea(30, table.concat(text), player, 80, (2-1)*50 + 250-12-30, 40, nil, 0xFFFFFF, 0xFFFFFF, 1, true)
    elseif callback:sub(1, 4) == 'rot_' then
        local rot = callback:sub(5)
        _S.rotation = rot
        ui.removeTextArea(30, nil)
        lobby()
    elseif callback == 'Pontos' then
        local text = {}
        for i = 1, 6 do
            text[#text+1] = '<a href="event:pt_'..(i*10)..'">'.. i*10 .. '</a>\n'
        end
        ui.addTextArea(30, table.concat(text), player, 80, (3-1)*50 + 250-12-30, 40, nil, 0xFFFFFF, 0xFFFFFF, 1, true)
    elseif callback:sub(1, 3) == 'pt_' then
        _S.roundScore = callback:sub(4)
        ui.removeTextArea(30, nil)
        lobby()
    elseif callback == 'join' then
        ui.addTextArea(1, string.format('<p align="center"><font size="15">%s | %s | %s | %s', '<font color="'.._S.teams.red.color..'"><a href="event:joinOn_red">' .. _S.translactions['red'] ..'</a></font>', '<font color="'.._S.teams.blue.color..'"><a href="event:joinOn_blue">' .. _S.translactions['blue'] ..'</a></font>', '<font color="'.._S.teams.yellow.color..'"><a href="event:joinOn_yellow">' .. _S.translactions['yellow'] ..'</a></font>', '<font color="'.._S.teams.green.color..'"><a href="event:joinOn_green">' .. _S.translactions['green'] ..'</a></font>'), player, 400, 40, nil, 20, 1, 1, 0.5, true)
    elseif callback:sub(1,7) == 'joinOn_' then
        local team = callback:sub(8)
        _S.players[player].team = team
        _S.teams[team].players[#_S.teams[team].players+1] = player
        ui.removeTextArea(1, player)
    end
end

function eventNewGame()
    if _S.state == 'started' then
        if tonumber(_S.rotation) == 3 then
            tfm.exec.setGameTime(60*5)
        elseif tonumber(_S.rotation) == 18 then
            tfm.exec.setGameTime(60*2)
        else
            tfm.exec.setGameTime(60)
        end
        _S.playersAlive = 0
        _S.roundScored = false
        for i = 1, 30 do
            ui.removeTextArea(i, nil)
        end
        for i, v in pairs(tfm.get.room.playerList) do
            if _S.players[i].team then
                tfm.exec.setNameColor(i, '0x'.. _S.teams[_S.players[i].team].color:sub(2,7))
                _S.playersAlive = _S.playersAlive + 1
            else
                tfm.exec.killPlayer(i)
            end
        end
        loadScore()
    elseif _S.state == 'podium' then
        _S.playersAlive = 99
        tfm.exec.setGameTime(9999999)
        ui.setMapName('Pódio')
        ui.removeTextArea(0)
        _S.state = 'finished'
        local colour = '0x' .. _S.teams[_S.roundScored].color:sub(2,7)
        tfm.exec.addPhysicObject(0, 399, 384, {type = 12, color = colour, height = 200, width = 400, miceCollision = false})
        tfm.exec.addPhysicObject(1, 686, 271, {type = 12, color = colour, height = 461, width = 94, miceCollision = false})
        tfm.exec.addPhysicObject(2, 110, 271, {type = 12, color = colour, height = 461, width = 94, miceCollision = false})

        for i, v in pairs(tfm.get.room.playerList) do
            if _S.players[i].team == _S.roundScored then
                tfm.exec.setNameColor(i, '0x'.. _S.teams[_S.players[i].team].color:sub(2,7))
            else
                tfm.exec.killPlayer(i)
            end
        end
    end
end

function eventPlayerDied(player)
    if _S.players[player].team then
        _S.playersAlive = _S.playersAlive - 1
    end
end
function eventPlayerLeft(player)
    if _S.players[player].team then
        _S.playersAlive = _S.playersAlive - 1
    end
end
function eventPlayerWon(player)
    if not _S.roundScored then
        _S.teams[_S.players[player].team].score = _S.teams[_S.players[player].team].score + 1
        _S.roundScored = true
        tfm.exec.setGameTime(3)
        if _S.teams[_S.players[player].team].score == tonumber(_S.roundScore) then
            _S.state = 'podium'
            _S.roundScored = _S.players[player].team
        end
        loadScore()
    end
end

function eventLoop(elapsed, remaining)
    if _S.state == 'finished' then
        ui.addTextArea(0, string.format(string.rep('\n', 15) .. '<p align="center"><font size="20" color="'.._S.teams[_S.roundScored].color..'">Bom trabalho, o time %s venceu.', _S.translactions[_S.roundScored]), nil, 5, 5, 790, 390, 0x1, 0x1, 0, true)
    end
    if remaining < 1000 or _S.playersAlive <= 0 and elapsed > 1000 then
        newRound()
    end
    if _S.messaged then
        _S.messaged = _S.messaged - 0.5
        if _S.messaged <= 0 then
            _S.messaged = nil
            ui.removeTextArea(40, nil)
        end
    end
end

function eventChatCommand(player, command)
    if player == _S.admin then
        if command:sub(1,3) == 'np ' then
            tfm.exec.newGame(command:sub(4))
        elseif command:sub(1,3) == 'npp' then
            _S.nextMap = command:sub(5)
        elseif command == 'skip' then
            newRound()
        elseif command:sub(1,3) == 'msg' then
            ui.addTextArea(40, '<rose>['.. player .. '] '.. command:sub(5), nil, 5, 23, 790, 20, 0x1, 0x1, 0.1, true)
            _S.messaged = 10
        elseif command == 'reset' then
            _S = {
                admin = 'Pidoninho#0000',
                teams = {
                    red = {
                        color = '#FF0000',
                        players = {},
                        score = 0,
                    },
                    blue = {
                        color = '#0000FF',
                        players = {},
                        score = 0,
                    },
                    yellow = {
                        color = '#FFFF00',
                        players = {},
                        score = 0,
                    },
                    green = {
                        color = '#00FF00',
                        players = {},
                        score = 0,
                    },},
                translactions = {
                    red = 'Vermelho',
                    blue = 'Azul',
                    yellow = 'Amarelo',
                    green = 'Verde',},
                players = {},
                playersAlive = 0,
                state = 'lobby',
                rotation = 17,
                nextMap = nil,
                roundScore = 1,
                roundScored = false,
                messaged = nil,
                randomTeams = false,
                mapsCat = {3, 7, 17, 18, 'Burlas'},
                maps = {
                    ['Burlas'] = {7372855,7372863,7372867,7372869,7372870,7372875,7372877,7372880,7372884,7372885,7372887,7372889,7372894,7372895,7372896,7372897,7372898,7372899,7372901,7372906,7372908,7372909,7372910,7372914,7372916,7372917,7372920,7372944,7372945,7372947,7372948,7372952,7372953,7372955,7372957,7372958,7372959,7372960,7372962,7372963,7372964,7372968,7372970,7372973,7372977,7372978,7373435,7373446,7373451,7373452,7373456,7373464,7373467,7373473,7373478,7373487,7373491,7373492,7373495,7373500,7373506,7373511,7373513,7373524,7373526,7373533,7373535,7373539,7373542,7373546,7373552,7373715,7373721,7373726,7373731,7373734,7373736,7373738,7373749,7373750,7373752,7373756,7373773,7373774,7373778,7373780,7373783,7373788,7373791,7373795,7329536,7467908,7467909,7467918,7467919,7467920,7467922,7467923,7467927,7467929,7467930,7467931,7467934,7467935,7467937,7467939,7467941,7467942,7467944,7467945,7467946,7467948,7467950,7467953,7467954,7467955,7467957,7467961,7467965,7467966,7467970,7467971,7467973,7467975,7467982,7467983,7481567,7488641,7488645,7488652,7488653,7488655,7488659,7488661,7488663,7488665,7488667,7488669,7488671,7488672,7488674,7488675,7488677,7488680,7488681,7488683,7488684,7488685,7488687,7488690,7488691,7488692,7488693,7488695,7488698,7488700,7488702,7488705,7488706,7488707,7488711,7488712,7488713,7581343,7581345,7581348,7581349,7581352,7581353,7581357,7581358,7581361,7581362,7581364,7581367,7581371,7587180,7587181,7587182,7587184,7587185,7587186,7587189,7587191,7587192,7588919,7590309,7590315,7590319,7590322,7590325,7590326,7590331,7590334,7590337,7590338,7590339,7590343,7590344,7590515,7590516,7590518,7590519,7590520,7590521,7590524,7590526,7590527,7590528,7590533,7590534,7590536,7590537,7590540,7590541},
                },
            }
            table.foreach(tfm.get.room.playerList, eventNewPlayer)
            tfm.exec.newGame(7465292)
        end
    end
end

function newRound()
    if _S.state == 'started' then
        if not _S.nextMap then
            if tonumber(_S.rotation) then
                tfm.exec.newGame('#' .. tonumber(_S.rotation))
            else
                tfm.exec.newGame(_S.maps[_S.rotation][math.random(#_S.maps[_S.rotation])])
            end
        else
            tfm.exec.newGame(_S.nextMap)
            _S.nextMap = nil
        end
    elseif _S.state == 'podium' then
        tfm.exec.newGame(7610813)
    end
end

tfm.exec.newGame(7465292)

table.foreach(tfm.get.room.playerList, eventNewPlayer)
for _, v in next, {'np', 'npp', 'skip', 'msg', 'reset'} do
    system.disableChatCommandDisplay(v)
end
