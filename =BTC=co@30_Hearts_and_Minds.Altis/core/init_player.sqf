btc_map_mapIllumination = ace_map_mapIllumination;
if !(isNil "btc_custom_loc") then {
    {
        _x params ["_pos", "_cityType", "_cityName", "_radius"];
        private _location = createLocation [_cityType, _pos, _radius, _radius];
        _location setText _cityName;
    } forEach btc_custom_loc;
};
btc_intro_done = [] spawn btc_fnc_intro;

[{!isNull player}, {
    [] call compileScript ["core\doc.sqf"];

    btc_respawn_marker setMarkerPosLocal player;
    player addRating 9999;
    ["InitializePlayer", [player]] call BIS_fnc_dynamicGroups;

    [player] call btc_eh_fnc_player;

    private _arsenal_trait = player call btc_arsenal_fnc_trait;
    if (btc_p_arsenal_Restrict isEqualTo 3) then {
        [_arsenal_trait select 1] call btc_arsenal_fnc_weaponsFilter;
    };
    [] call btc_int_fnc_add_actions;
    [] call btc_int_fnc_shortcuts;

    if (player getVariable ["interpreter", false]) then {
        player createDiarySubject ["btc_diarylog", localize "STR_BTC_HAM_CON_INFO_ASKHIDEOUT_DIARYLOG"];
    };

    switch (btc_p_autoloadout) do {
        case 1: {
            player setUnitLoadout ([_arsenal_trait select 0] call btc_arsenal_fnc_loadout);
        };
        case 2: {
            removeAllWeapons player;
        };
        default {
        };
    };

    if ([btc_player_side] call BIS_fnc_respawnTickets isEqualTo 0) then {
        [
            {scriptDone btc_intro_done},
            btc_fob_fnc_forceRespawn
        ] call CBA_fnc_waitUntilAndExecute;
    };

    if !(btc_p_respawn_ticketsShare) then {
        [
            {[player] call BIS_fnc_respawnTickets isNotEqualTo -1},
            {
                if ([player] call BIS_fnc_respawnTickets > 0) exitWith {};
                [
                    {scriptDone btc_intro_done},
                    BIS_fnc_EGSpectator,
                    ["Initialize", [
                        player, 
                        [btc_player_side],
                        BIS_respSpecAi,
                        BIS_respSpecAllowFreeCamera,
                        BIS_respSpecAllow3PPCamera,
                        BIS_respSpecShowFocus,
                        BIS_respSpecShowCameraButtons,
                        BIS_respSpecShowControlsHelper,
                        BIS_respSpecShowHeader,
                        BIS_respSpecLists]
                    ]
                ] call CBA_fnc_waitUntilAndExecute;
            }
        ] call CBA_fnc_waitUntilAndExecute;
    };

    if (btc_debug) then {
        onMapSingleClick "vehicle player setPos _pos";
        player allowDamage false;

        [{!isNull (findDisplay 12)}, {
            ((findDisplay 12) displayCtrl 51) ctrlAddEventHandler ["Draw", btc_debug_fnc_marker];
        }] call CBA_fnc_waitUntilAndExecute;
    };
}] call CBA_fnc_waitUntilAndExecute;
