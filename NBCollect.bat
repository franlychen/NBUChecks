rem NetBackup Collection Script
rem Copyright (C) 2009, Timmins Software Corporation (info@mitrend.com)
rem $Date$
rem -----
rem Ensure netbackup\bin, netbackup\bin\admincmd, and volmgr\bin are in PATH
rem example: 
set PATH=%PATH%;"c:\program files\veritas\netbackup\bin\admincmd";"c:\program files\veritas\netbackup\bin";"c:\program files\veritas\volmgr\bin"

echo off
echo Output will be in %TEMP%\quick_
echo Executing ---date /t---
date /t > %TEMP%\quick_date.out

rem -----
rem Set the base date. 
rem By default, collect all backup images
rem Change to "01/01/1970" to gather all images ever.
rem Date format is locale dependent.   
set NBBASEDATE="09/01/2012"
rem -----

echo Executing ---time /t---
time /t > %TEMP%\quick_time.out

echo Executing ---reg query to get current timezone configuration ---
reg query "HKLM\SYSTEM\CurrentControlSet\Control\TimeZoneInformation" > %TEMP%\quick_timezone.out

echo Executing ---set---
set > %TEMP%\quick_set.out

echo Executing ---hostname---
hostname > %TEMP%\quick_hostname.out

echo > %TEMP%\quick_nbuquickv326w.out

echo %NBBASEDATE% > %TEMP%\quick_nbbasedate.out

rem Config
echo Executing ---bpconfig -L -U---
bpconfig -L -U  > %TEMP%\quick_bpconfig.out

rem Server Config
echo Executing ---bpgetconfig -X---
bpgetconfig -X > %TEMP%\quick_bpgetconfig.out

rem Licenses
echo Executing ---bpminlicense -list_keys -verbose---
bpminlicense -list_keys -verbose > %TEMP%\quick_bpminlicense.out

rem Retention Levels
echo Executing ---bpretlevel---
bpretlevel > %TEMP%\quick_bpretlevel.out

rem Storage Units
echo Executing ---bpstulist -U -L---
bpstulist -U -L > %TEMP%\quick_bpstulist.out

rem Storage Unit Groups
echo Executing ---bpstulist -U -go -L---
bpstulist -U -go -L > %TEMP%\quick_bpstulist_go.out

rem Clients
echo Executing ---bpclient -All -L---
bpclient -All -L > %TEMP%\quick_bpclient.out

rem Clients
echo Executing ---bpplclients---
bpplclients > %TEMP%\quick_bpplclients.out

rem Policies, human readable
echo Executing ---bppllist -allpolicies -L -U---
bppllist -allpolicies -L -U > %TEMP%\quick_bppllist.out

rem Policies, machine readable
echo Executing ---bppllist -allpolicies -l---
bppllist -allpolicies -l > %TEMP%\quick_bppllistl.out

rem Image List 
echo Executing ---bpimagelist -U -force -L -d %NBBASEDATE% ---
bpimagelist -U -force -L -d %NBBASEDATE% > %TEMP%\quick_bpimagelist.out 2>%TEMP%\quick_bpimagelist_err.out

rem If there is an error then try without -force
for %%R in (%TEMP%\quick_bpimagelist_err.out) do ( 
    if not %%~zR lss 1 (
	 rem Error occurred, running without -force.
	 rename %TEMP%\quick_bpimagelist_err.out %TEMP%\quick_bpimagelist_force_err.out	
	 echo Executing ---bpimagelist -U -L -d %NBBASEDATE% ---
	 bpimagelist -U -L -d %NBBASEDATE% > %TEMP%\quick_bpimagelist.out 2>%TEMP%\quick_bpimagelist_err.out
	)
)

rem Images on Media
echo Executing ---bpimmedia -U -force -l -d %NBBASEDATE% ---
bpimmedia -U -force -l -d %NBBASEDATE% > %TEMP%\quick_bpimmedial.out 2>%TEMP%\quick_bpimmedial_err.out

rem If there is an error then try without -force
for %%R in (%TEMP%\quick_bpimmedial_err.out) do ( 
    if not %%~zR lss 1 (
	 rem Error occurred, running without -force.
	 rename %TEMP%\quick_bpimmedial_err.out %TEMP%\quick_bpimmedial_force_err.out		
	 echo Executing ---bpimmedia -U -l -d %NBBASEDATE% ---
	 bpimmedia -U -l -d %NBBASEDATE% > %TEMP%\quick_bpimmedial.out 2>%TEMP%\quick_bpimmedial_err.out
	)
)

rem Media List
echo Executing ---bpmedialist -mlist -U -L---
bpmedialist -mlist -U -L > %TEMP%\quick_bpmedialist.out

rem Media List Summary
echo Executing ---bpmedialist -summary -U -L---
bpmedialist -summary -U -L > %TEMP%\quick_bpmedialistsummary.out

rem All Media, including Scratch
echo Executing ---vmquery -a ----
vmquery -a > %TEMP%\quick_vmquery.out

rem Drives
echo Executing ---tpconfig -dl----
tpconfig -dl > %TEMP%\quick_tpconfig.out

rem Drives and Robots
echo Executing ---vmglob -listall---
vmglob -listall > %TEMP%\quick_vmglob.out

rem Pools
echo Executing ---vmpool -listall---
vmpool -listall > %TEMP%\quick_vmpool.out

rem Devices
echo Executing ---vmoprcmd -d---
vmoprcmd -d > %TEMP%\quick_vmoprcmd.out

rem Device Config
echo Executing ---vmoprcmd -devconfig -l---
vmoprcmd -devconfig -l > %TEMP%\quick_vmoprcmd_devconfig.out

rem Disk Pools
echo Executing ---nbdevquery -listdp -U---
nbdevquery -listdp -U >  %TEMP%\quick_nbdevquery_listdp.out

rem Storage Servers
echo Executing ---nbdevquery -liststs -U---
nbdevquery -liststs -U >  %TEMP%\quick_nbdevquery_liststs.out

rem Disk Volumes - Data Domain
echo Executing ---nbdevquery -listdv -U---
nbdevquery -listdv -stype DataDomain -U >  %TEMP%\quick_nbdevquery_listdv_dd.out

rem Disk Volumes - Pure Disk
echo Executing ---nbdevquery -listdv -U---
nbdevquery -listdv -stype PureDisk -U >  %TEMP%\quick_nbdevquery_listdv_pd.out

rem Global Disk Parameters
echo Executing ---nbdevquery -listglobals -U---
nbdevquery -listglobals -U >  %TEMP%\quick_nbdevquery_listglobals.out

rem Recent Activity Summary
echo Executing ---bpdbjobs -summary---
bpdbjobs -summary > %TEMP%\quick_bpdbjobssummary.out

rem Recent Activity
echo Executing ---bpdbjobs -report -all_columns---
bpdbjobs -report -all_columns > %TEMP%\quick_bpdbjobs.out

rem Fibre Transport Clients
echo Executing ---nbftconfig -listclients -verbose---
nbftconfig -listclients -verbose > %TEMP%\quick_nbftconfig_listclients.out

rem Fibre Transport Servers
echo Executing ---nbftconfig -listservers -verbose---
nbftconfig -listservers -verbose > %TEMP%\quick_nbftconfig_listservers.out

rem NBU Version
echo Executing ---version ----
type "c:\program files\veritas\netbackup\version.txt" > %TEMP%\quick_version.out


echo Executing ---time /t---
time /t > %TEMP%\quick_time2.out


rem Useful commands for detailed analysis
rem
rem echo Executing ---bperror -hoursago 168 -U -all -L---
rem bperror -hoursago 168 -U -all -L > %TEMP%\quick_bperrora.out
rem 
rem echo Executing ---bpsyncinfo -L---
rem bpsyncinfo -L > %TEMP%\quick_bpsyncinfo.out
rem 
rem echo Executing ---bpdrfiles -list---
rem bpdrfiles -list > %TEMP%\quick_bpdrfiles.out
rem
rem echo Executing ---vxlogview -a -t 120:0:0---
rem vxlogview -a -t 120:0:0 > %TEMP%\quick_vxlogview.out
rem 
rem echo Executing ---vltcontainers -view---
rem vltcontainers -view > %TEMP%\quick_vltcontainers.out
rem 

set runCoverage=n
echo -----
echo Optional: Scan client versions and policy coverage
echo using the NetBackup bpcoverage command. Reference: http://www.symantec.com/docs/TECH9292

set /p runCoverage= "Scan client versions and policy coverage? (y/n)[n]:"

if "%runCoverage%"=="y" goto runCoverage
if "%runCoverage%"=="Y" goto runCoverage
goto doneCoverage


:runCoverage
	del /F %TEMP%\quick_bpcoverage.out
	for /F "tokens=3 skip=2" %%i in (%TEMP%\quick_bpplclients.out) do (
		echo Checking coverage for %%i
		echo Checking coverage for %%i >> %TEMP%\quick_bpcoverage.out
		bpcoverage -c %%i >> %TEMP%\quick_bpcoverage.out
		echo. >> %TEMP%\quick_bpcoverage.out
	)
:doneCoverage


if NOT EXIST %TEMP%\quick_bpdbjobs.out (
	echo ERROR: Script did not run successfully: %TEMP%\quick_bpdbjobs.out does not exist. Please rerun the script and monitor for errors. 
	echo ERROR: Failed.  
) else if NOT EXIST %TEMP%\quick_bpmedialist.out (
	echo ERROR: Script did not run successfully: %TEMP%\quick_bpmedialist.out does not exist. Please rerun the script and monitor for errors. 
	echo ERROR: Failed.  
) else if NOT EXIST %TEMP%\quick_bpimagelist.out (
	echo ERROR: Script did not run successfully: %TEMP%\quick_bpimagelist.out does not exist. Please rerun the script and monitor for errors. 
	echo ERROR: Failed.  
) else if NOT EXIST %TEMP%\quick_bpimmedial.out (
	echo ERROR: Script did not run successfully: %TEMP%\quick_bpimmedial.out does not exist. Please rerun the script and monitor for errors. 
	echo ERROR: Failed.  
) else if NOT EXIST %TEMP%\quick_bpplclients.out   (
	echo ERROR: Script did not run successfully: %TEMP%\quick_bpplclients.out does not exist. Please rerun the script and monitor for errors. 
	echo ERROR: Failed.  
) else if NOT EXIST %TEMP%\quick_bpgetconfig.out   (
	echo ERROR: Script did not run successfully: %TEMP%\quick_bpgetconfig.out does not exist. Please rerun the script and monitor for errors. 
	echo ERROR: Failed.  
) else (
	echo INFO: Complete. Output files are in %TEMP%\quick_
	echo INFO: Zip these files and send the zip file.  
  	
)
pause
