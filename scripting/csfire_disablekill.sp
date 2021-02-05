#include <sourcemod>
#include <autoexecconfig>

#pragma newdecls required
#pragma semicolon 1

#define TAG_NCLR "[CSFIRE]"
#define TAG_CLR "[\x10csfire.gg\x01]"

ConVar g_cvEnableDisableKill;

public Plugin myinfo =
{
	name = "csfire_disablekill",
	author = "DRANIX",
	description = "Disable console kill commands (sm_explode, sm_kill)",
	version = "1.0",
	url = "www.csfire.gg"
};

public void OnPluginStart()
{
	//LoadTranslations("csfire_disablekill.phrases");

	AddCommandListener(Command_kill, "kill");
	AddCommandListener(Command_kill, "explode");

	AutoExecConfig_SetFile("csfire_disablekill_config");

	g_cvEnableDisableKill = AutoExecConfig_CreateConVar("sm_disablekill_enable", "0", "Enable or disabled kill console commands", FCVAR_PROTECTED, true, 0.0, true, 1.0);
	g_cvEnableDisableKill.AddChangeHook(OnConVarChanged);

	AutoExecConfig_ExecuteFile();
	AutoExecConfig_CleanFile();

}

public void OnConVarChanged(ConVar convar, const char[] oldValue, const char[] newValue) {
	if(convar == g_cvEnableDisableKill)
    {
        g_cvEnableDisableKill.SetBool(view_as<bool>(StringToInt(newValue)));
    }

}

public Action Command_kill(int client, const char[] command, int argc) {
	if(g_cvEnableDisableKill.BoolValue)
    {
		PrintToChat(client, "%s \x08You are not allowed to \x0Fkill \x08yourself.", TAG_CLR);
		return Plugin_Handled;
    }

	return Plugin_Continue;
}