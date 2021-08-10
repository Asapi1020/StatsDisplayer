class StatsDisplayer extends KFMutator
	config(StatsDisplayer);

struct StatsToDisplay
{
	var int DoshEarned;
	var int DamageDealt;
	var int DamageTaken;
	var int HealsGiven;
	var int HealsRecv;
	var int LargeKills;
	var int ShotsFired;
	var int ShotsHit;
	var int HeadShots;
	var float Accuracy;	
	var float HSAccuracy;	
};

var bool bHasDisplayed;

var config bool bDontInit;

var config bool bAccuracy;
var config bool bHSAccuracy;
var config bool bHeadShots;
var config bool bLargeKills;
var config bool bDamageDealt;
var config bool bDamageTaken;

var config bool bEndWaveStats;
var config bool bDuringWaveStats;

function PostBeginPlay(){
	super.PostBeginPlay();

	if(!bDontInit) InitConfig();
	SaveConfig();
	SetTimer(1.f, true, 'CheckState');
}

function InitConfig(){
	bDontInit = true;

	bAccuracy = true;
	bHSAccuracy = true;
	bHeadShots = false;
	bLargeKills = false;
	bDamageDealt = false;
	bDamageTaken = false;

	bEndWaveStats = false;
	bDuringWaveStats = true;
}

function StatsToDisplay GetStats(KFPlayerController KFPC){
	local StatsToDisplay std;

	std.DoshEarned = KFPC.MatchStats.TotalDoshEarned;
	std.LargeKills = KFPC.MatchStats.TotalLargeZedKills;
	std.HealsGiven = KFPC.MatchStats.TotalAmountHealGiven;
	std.HealsRecv  = KFPC.MatchStats.TotalAmountHealReceived;
	std.DamageDealt= KFPC.MatchStats.TotalDamageDealt;
	std.DamageTaken= KFPC.MatchStats.TotalDamageTaken;
	std.ShotsFired = KFPC.ShotsFired;
	std.ShotsHit   = KFPC.ShotsHit;
	std.HeadShots  = KFPC.MatchStats.TotalHeadShots;

	if(!(MyKFGI.MyKFGRI.bTraderIsOpen)){
		std.DoshEarned += KFPC.MatchStats.GetDoshEarnedInWave();
		std.HealsGiven += KFPC.MatchStats.GetHealGivenInWave();
		std.HealsRecv  += KFPC.MatchStats.GetHealReceivedInWave();
		std.DamageDealt+= KFPC.MatchStats.GetDamageDealtInWave();
		std.DamageTaken+= KFPC.MatchStats.GetDamageTakenInWave();
		std.HeadShots  += KFPC.MatchStats.GetHeadShotsInWave();
	}

	if (std.ShotsFired > 0 && std.ShotsHit > 0){
		std.Accuracy   = (Float(std.ShotsHit)/Float(std.ShotsFired) * 100.0);
		std.HSAccuracy = (Float(std.Headshots)/Float(std.ShotsHit) * 100.0);
	}

	return std;
}

function CheckState(){

	//EndWave
	if (MyKFGI.MyKFGRI.bTraderIsOpen){
		if(!bHasDisplayed && bEndWaveStats){
			DisplayStats();
			bHasDisplayed = true;
		}
		if(IsTimerActive('DisplayStats')){
			ClearTimer('DisplayStats');
		}
	}

	//DuringWave
	else if(!(MyKFGI.MyKFGRI.bTraderIsOpen)){
		if(bHasDisplayed) bHasDisplayed = false;
		if(bDuringWaveStats && !(IsTimerActive('DisplayStats'))){
			SetTimer(6.f , true, 'DisplayStats');
		}
	}
}

function DisplayStats(){
	local KFPlayerController KFPC;	
	local StatsToDisplay std;

	foreach WorldInfo.AllControllers(class'KFPlayerController', KFPC){
		std = GetStats(KFPC);
		PersonalMessage(KFPC, "[Stats Displayer]");
		if(bAccuracy) PersonalMessage(KFPC, "Accuracy = " $ string(std.Accuracy));
		if(bHSAccuracy) PersonalMessage(KFPC, "HSAccuracy = " $ string(std.HSAccuracy));
		if(bHeadShots) PersonalMessage(KFPC, "HeadShots = " $ string(std.Accuracy));
		if(bLargeKills) PersonalMessage(KFPC, "LargeKills = " $ string(std.Accuracy));
		if(bDamageDealt) PersonalMessage(KFPC, "DamageDealt = " $ string(std.DamageDealt));
		if(bDamageTaken) PersonalMessage(KFPC, "DamageTaken = " $ string(std.DamageTaken));
	}
}

function PersonalMessage(KFPlayerController KFPC, string s){
	if ( None != KFPC.MyGFxManager.PartyWidget ) KFPC.MyGFxManager.PartyWidget.ReceiveMessage( s, "00FF0A" );
	if ( KFPC.MyGFxManager != none ) KFPC.MyGFxManager.PostGameMenu.ReceiveMessage( s, "00FF0A" );
	if ( None != KFPC.MyGFxHUD && None != KFPC.MyGFxHUD.HudChatBox ) KFPC.MyGFxHUD.HudChatBox.AddChatMessage(s, "00FF0A" );
}