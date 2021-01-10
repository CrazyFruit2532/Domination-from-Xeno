// by Xeno

d_interceptdb = isClass (configFile>>"Intercept">>"Dedmen">>"intercept_database");

d_fnc_createdbconn = {
	D_DB_CON = dbCreateConnection "domination";
};

d_fnc_queryconfig = {
	params ["_cname", ["_params", []]];
	
	private "_query";

	if (_params isEqualTo []) then {
		_query = dbPrepareQueryConfig _cname;
	} else {
		_query = dbPrepareQueryConfig [_cname, _params];
	};
	private _res = D_DB_CON dbExecute _query;
	(dbResultToParsedArray _res)
};

d_fnc_queryconfigasync = {
	params ["_cname", ["_params", []]];
	
	private "_query";

	if (_params isEqualTo []) then {
		_query = dbPrepareQueryConfig _cname;
	} else {
		_query = dbPrepareQueryConfig [_cname, _params];
	};
	private _res = D_DB_CON dbExecuteAsync _query;
};

d_fnc_gettoppplayers = {
	private _query = dbPrepareQueryConfig "getTop10Players";
	private _res = D_DB_CON dbExecuteAsync _query;
	_res dbBindCallback [{
		params ["_result"];
		
		private _dbresult = dbResultToParsedArray _result;
		if !(_dbresult isEqualTo []) then {
			{
				_x set [1, (_x # 1) call d_fnc_convtime];
			} forEach _dbresult;
			missionNamespace setVariable ["d_top10_db_players", _dbresult, true];
		};
	}];
};
