# StatsDisplayer
KF2 Mutator

This mutator display player stats in a chat box.

Why offline only?  
For now, unfortunately, I do not realize how to output text messages DIRECTLY into chat boxes online.

There are 2 undirectly ways.  
1: To make a new Broadcast controller seen in RPWMod.  
  Problem: Multiple BroadcastHandler cannot exist so you cannot use with RPWMod.  
  
2: To replace PlayerController class with a new one.  
  Problem: Most of Custom Game Mode use their own customized PlayerController class so some functions in custom game mode must be disabled.
           For example, when you use Controlled Difficulty and Server Extention RPG Mod at the same time, you cannot use CD's Ready System because its ready counts depend on its 
           PlayerControlle class 'CD_PlayerController' and ServerExtention replaces this with its own 'ExtPlayerController'.
           
Maybe there is an another way to activate online.      
