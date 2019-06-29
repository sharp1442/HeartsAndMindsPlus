
/* ----------------------------------------------------------------------------
Function: btc_fnc_fob_dismantle_s

Description:
    Fill me when you edit me !

Parameters:
    _flag - [Object]

Returns:

Examples:
    (begin example)
        _result = [] call btc_fnc_fob_dismantle_s;
    (end)

Author:
    Vdauphin

---------------------------------------------------------------------------- */

params [
    ["_flag", objNull, [objNull]]
];

private _pos = getPosASL _flag;
private _element = (btc_fobs select 2) find _flag;

[(btc_fobs select 1) select _element, objNull, objNull, true, true] call btc_fnc_eh_FOB_killed;

[btc_fob_mat, _pos, surfaceNormal _pos] call btc_fnc_log_create_s;
