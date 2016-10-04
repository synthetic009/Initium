param($AccountParam, $PasswordParam, $ModeParam, $LogGroupParam)
<#
Current use for Parameters:
Execute script from Powershell like: C:\ini\ps\Initium-Alpha.ps1 -AccountParam "ACCOUNT1@gmail.com" -PasswordParam "PASSWORD" -ModeParam "20" -LogGroupParam "GROUPNAME"
Mandatory Param:
    -AccountParam (Specifies what account you want to run under)
    -PasswordParam (Specifies password for said account)
Optional Param:
    -ModeParam (Species Mode to use, current options:
        To Farm Trolls, enter: 0
        To observe and log = 1;
        [NOT IMPLEMENTED] To Pickup items on floor in current zone that match picklist, enter: 2
        [NOT IMPLEMENTED] To simply sit and do nothing enter: 10
        To Farm High Road for Thorn (MAKE SURE YOU HAVE PICK LIST ENABLED), enter: 20
        To farm Protector of the Plains (Send alert on find, do not attack), enter: 41 or POP
    -LogGroupParam (Enables logging of Group Chat, enter the name of the group you're monitoring, example:
        "Potato" as a parameter will create a log file in C:\ini\data\log\GroupChat\PotatoGroupChatLog.txt with group chat log.
#>


#import selenium DLLs
cd "C:\"

if (test-path "C:\INI\PS\EvaluateAction.ps1")
{
    write-host "Importing Pathing logic..."
    . C:\INI\ps\EvaluateAction.ps1
}
else
{
    write-host "Pathing logic script not found! Missing: EvaluateAction.ps1"
    break;
}

if (test-path "C:\SeleniumDotNet\net40\Selenium.WebDriverBackedSelenium.dll")
{
    write-host "Importing Selenium library..."
    Add-Type -Path "C:\SeleniumDotNet\net40\Selenium.WebDriverBackedSelenium.dll"
}
else
{
    write-host "Selenium libarary not found! Missing: Selenium.WebDriverBackedSelenium.dll"
    break;
}

if (test-path "C:\SeleniumDotNet\net40\ThoughtWorks.Selenium.Core.dll")
{
    write-host "Importing Selenium library..."
    Add-Type -Path "C:\SeleniumDotNet\net40\ThoughtWorks.Selenium.Core.dll"
}
else
{
    write-host "Selenium libarary not found! Missing: ThoughtWorks.Selenium.Core.dll"
    break;
}

if (test-path "C:\SeleniumDotNet\net40\WebDriver.dll")
{
    write-host "Importing Selenium library..."
    Add-Type -Path "C:\SeleniumDotNet\net40\WebDriver.dll"
}
else
{
    write-host "Selenium libarary not found! Missing: WebDriver.dll"
    break;
}

if (test-path "C:\SeleniumDotNet\net40\WebDriver.Support.dll")
{
    write-host "Importing Selenium library..."
    Add-Type -Path "C:\SeleniumDotNet\net40\WebDriver.Support.dll"
}
else
{
    write-host "Selenium libarary not found! Missing: WebDriver.Support.dll"
    break;
}
#if we entered a param for log group param, enable use of EvalGroupChat function
if (!([string]::IsNullOrEmpty($LogGroupParam)))
{
    write-host "!!!!!!!!!!!!!!!!!!!!!!!!"
    write-host "Enabling use of EvalGroupChat Function."
    write-host "!!!!!!!!!!!!!!!!!!!!!!!!"
    $DefaultGroupChatLogDir = "C:\INI\Data\Log\GroupChat\"
    $MyGroup = $DefaultGroupChatLogDir+$LogGroupParam+"GroupChatLog.txt"
    $isEvalGroupChatEnabled = $True
}
else
{
    write-host "!!!!!!!!!!!!!!!!!!!!!!!!"
    write-host "Disabling use of EvalGroupChat Function."
    write-host "!!!!!!!!!!!!!!!!!!!!!!!!"
    $isEvalGroupChatEnabled = $False
}

$driver = New-Object OpenQA.Selenium.Chrome.ChromeDriver
$wait = New-TimeSpan -Seconds 10
$driver.Manage().Timeouts().ImplicitlyWait($wait)

$driver.Navigate().GoToUrl("https://www.playinitium.com/landing.jsp")

$changeToLoginLanding = $driver.FindElementByLinkText("Login").Click()

#ping localhost -n 2 | Out-Null
Start-Sleep -s 2

### order mattters with these
$LogPath = "C:\INI\Data\Log\"
$MyAccount = $AccountParam
$MyPass = $PasswordParam
$AccountLogPath = $LogPath+$MyAccount
### logging details

###create logging path
write-host "Checking that account specific path exists."
write-host "Checking:" $AccountLogPath
if (!(test-path $AccountLogPath))
{
    write-host "Path does not exist... creating."
    mkdir $AccountLogPath
    cd $AccountLogPath
    ping localhost -n 2 | Out-Null
}
else {"Log file exists.. continuing."}


####droplist details:
$DropPathAccount = $AccountLogPath+"\DropList.txt" 
$DropPathGen = $LogPath+"DropList.txt"

####ignorelist details:
$IgnorePathAccount = $AccountLogPath+"\IgnoreList.txt" 
$IgnorePathGen = $LogPath+"IgnoreList.txt"

#set droplist
write-host "Checking presence of DropList.."
if (test-path $DropPathAccount)
{
    write-host "Found valid DropList in:" $DropPathAccount
    $DropList = (Get-Content $DropPathAccount)
    Write-Host "Items in DropList:" $DropList
}
elseif (test-path $DropPathGen)
{
    write-host "Found valid DropList in:" $DropPathGen
    $DropList = (Get-Content $DropPathGen)
    Write-Host "Items in DropList:" $DropList
}
else
{
    write-host "Could not find valid DropList. Disabling option."
    $DropList = $NULL
}
#####

#set ignorelist
write-host "Checking presence of IgnoreList (BlackList).."
if (test-path $IgnorePathAccount)
{
    write-host "Found valid IgnoreList in:" $IgnorePathAccount
    $IgnoreList = (Get-Content $IgnorePathAccount)
    Write-Host "Items in DropList:" $IgnoreList
}
elseif (test-path $IgnorePathGen)
{
    write-host "Found valid IgnoreList in:" $IgnorePathGen
    $IgnoreList = (Get-Content $IgnorePathGen)
    Write-Host "Items in IgnoreList:" $IgnoreList
}
else
{
    write-host "Could not find valid IgnoreList. Disabling option."
    $IgnoreList = $NULL
}
#####

#######LOGIN#####
$account = $driver.FindElementsByName("email")
$enterAccountDetails = $account[1].SendKeys($MyAccount)

$pass = $driver.FindElementsByName("password")
$enterPasswordDetails = $pass[1].SendKeys($MyPass)

$loginButton = $driver.FindElementByLinkText("Login").Click()
#################

Start-Sleep -s 2

$NotifySleep10 = write-host "Sleeping for 10 seconds"

if ($ModeParam -eq $NULL)
{
    write-host "No Mode Parameter passed, using default 0, farm trolls."
    [int]$MyMode = 0;
}
else
{
    write-host "Changing Mode to be equal to:" $ModeParam
    if ($ModeParam -like "*Troll"){$MyMode = 0}
    elseif ($ModeParam -like "StandBy" -or $ModeParam -like "LazyWatch"){$MyMode = 1}
    elseif ($ModeParam -like "Thorn"){$MyMode = 20}
    elseif ($ModeParam -like "POP"){$MyMode = 41}
    elseif ($ModeParam -like "POS"){$MyMode = 42}
    elseif ($ModeParam -like "POJ"){$MyMode = 43}
    elseif ($ModeParam -like "POM"){$MyMode = 44}
    elseif ($ModeParam -like "POR"){$MyMode = 45}
    elseif ($ModeParam -like "POD"){$MyMode = 46}
    else{[int]$MyMode = $ModeParam}
}

#### Set Modes 
#[int]$MyMode = 0;
[int]$DesiredGold = 100000;

####
[int]$FarmT = 0;
[int]$LazyWatch = 1;
[int]$SnipeItem = 2;
[int]$StandBy = 10;
[int]$Thorn = 20;
[int]$POP = 41;
[int]$POS = 42;
[int]$POJ = 43;
[int]$POM = 44;
[int]$POR = 45;
[int]$POD = 46;
###
#status of route (0 = have not completed full route,
# 1 = need to go back to start
$global:routeComplete = 0;
[int]$Complete = 1;
[int]$Incomplete = 0; 
###Modes:
#
# 0 = Troll Farm
# 1 = Lazy Watch for Items
# 2 = Buy Good Items from Main town player shops
#

### MyStatus
$global:MyStatus = 0;
### Avalaiable Status':
[int]$Unknown = 0;
[int]$Dead = 1;
[int]$Dying = 2;
[int]$Hurt = 3;
[int]$Good = 5;
####
[bool]$InActiveCombat = $false;
#############################

function waitForElement($locator, $timeInSeconds,[switch]$byClass,[switch]$byName){
    #this requires the WebDriver.Support.dll in addition to the WebDriver.dll
    Add-Type -Path "C:\SeleniumDotNet\net40\WebDriver.Support.dll"
    $webDriverWait = New-Object OpenQA.Selenium.Support.UI.WebDriverWait($script:driver, $timeInSeconds)
    try{
        if($byClass){
            $null = $webDriverWait.Until([OpenQA.Selenium.Support.UI.ExpectedConditions]::ElementIsVisible( [OpenQA.Selenium.by]::ClassName($locator)))
        }
        elseif($byName){
            $null = $webDriverWait.Until([OpenQA.Selenium.Support.UI.ExpectedConditions]::ElementIsVisible( [OpenQA.Selenium.by]::Name($locator)))
        }
        else{
            $null = $webDriverWait.Until([OpenQA.Selenium.Support.UI.ExpectedConditions]::ElementIsVisible( [OpenQA.Selenium.by]::Id($locator)))
        }
        return $true
    }
    catch{
        write-host "!!!!!!!!!!!!!!!!!!!!!!"
        write-host "Timeout trying to wait for element!"
        write-host "!!!!!!!!!!!!!!!!!!!!!!"
        return "Wait for $locator timed out"
    }
}

#start of functions
#populates account specific log file with param
function dologSpecific()
{
    param($tolog)
    $dateformatted = (get-date -UFormat %Y%m%d)
    $datespecific = (get-date -UFormat %Y%m%d%H%M)
    $dateforlog = $datespecific+": "
    $AccountLogFile = $AccountLogPath+"\"+$MyAccount+"."+$dateformatted+".txt"
    Add-Content $AccountLogFile ($dateforlog+$tolog)
}

function dologGeneric()
{
    param($tolog)
    $dateformatted = (get-date -UFormat %Y%m%d)
    $datespecific = (get-date -UFormat %Y%m%d%H%M)
    $dateforlog = $datespecific+": "
    $GenericLogFile = $LogPath+$dateformatted+".txt"
    Add-Content $GenericLogFile ($MyAccount+"/"+$dateforlog+$tolog)
}

function doDropItem
{
    param($Equipment)
    $ajax = $Equipment.FindElementByPartialLinkText("Drop on ground")
    $ajax.click()
    write-host "Dropped item."
    ping localhost -n 2 | out-null
}

function EvaluateInventoryByDroplist()
{
    $driver.Keyboard.SendKeys("I");
    (Ping loopback -n 5) | Out-Null
    If ($driver.FindElementsById("inventory").Displayed)
    {
        $myItemsArray = @();
        write-host "Invetory is open."
        $myItems = $driver.FindElementsByClassName("main-item-container")
        #$driver.FindElementByPartialLinkText(
        write-host "Number of containers disaplyed:"$myItems.count
        Write-Host "Display only items equippable"

        $val = "W3SVC1"
        $tosearch = $DropList
        if ($tosearch -eq $NULL)
        {
            write-host "DropList undefined or set to disable, exiting function EvaluateInventoryByDroplist"
            return $false
        }
        $lineitem = ($tosearch | select-string -Pattern $val -NotMatch).LineNumber

        for ($i=0; $i -lt $myItems.count; $i++)
        {
            write-host "Evaluating item number: " $i
            for ($f=0; $f -lt $lineitem.count; $f++)
            {
                $droplistitem = ($tosearch | Select-Object -Index $f)
                #write-host "MUST Drop: "$droplistitem
                if ($myItems[$i].Text -like "*Drop on ground*" -and $myItems[$i].text -like $droplistitem)
                {
                    write-host "Item $i contains Equip."
                    $myItemsArray += $myItems[$i]
                }
            }
        }
        write-host "End of initial eval for equippable items."
        write-host ""
        return $myItemsArray
    }
}

function doDropList()
{
    $baditems = EvaluateInventoryByDroplist
    if ($baditems -eq $NULL -or $baditems -eq $false)
    {
        write-host "Exiting doDropList with NULL or False."
        return $false
    }
    if ($baditems.count -gt 0)
    {
        write-host "Dropping items in droplist"
        doDropItem $baditems
        while ($baditems.count -gt 0)
        {
            write-host "Attempting to drop another undesired item."
            $baditems = EvaluateInventoryByDroplist
            if ($baditems.count -eq 0 -or $baditems -eq $NULL)
            {
                write-host "All bad items have been dropped."
                write-host "Closing inventory."
                $CloseInventory = $driver.FindElementByClassName("page-popup-X").Click()
                ##$driver.Keyboard.SendKeys("I");
                return $true;
            }
            else
            {
                write-host "Current number of bad items: " $baditems.count
                doDropItem $baditems
            }
        }
    }
}

function GetEffectiveHealth
{
    $hp = $driver.FindElementById("hitpointsBar").Text
    $hpArray = $hp.Split("/")
    if ($hpArray[0] -le 0)
    {
        write-host "Character health is either unavailable or dead"
        $returnvalue = 0;
    }
    if ($hpArray[0] -gt 0)
    {
        $returnValue = (($hpArray[0]/$hpArray[1])*100)
    }
    write-host "Exit getEffectiveHealth."
    return $returnValue
}

function GetGold
{
   $MyGold = $driver.FindElementById("mainGoldIndicator").Text
   write-host "Exit getGold."
   return $MyGold
}

function GetLocation
{
    $location = $driver.FindElementByCssSelector("a[href*='main.jsp']").Text
    ping localhost -n 1 | out-null
    write-host "Exit getLocation."
    return $location
}

function GetWeight()
{
    write-host "Opening Avatar to get current weight by percentage."
    $OpenStats = $driver.FindElementByClassName("avatar-equip-backing").Click()
    ping localhost -n 2 | Out-Null
    $GetInventoryWeight = $driver.FindElementByName("inventoryWeight")
    $MyWeightPercent = (($GetInventoryWeight[0].Text).Split('(%')[1])
    write-host "My Weight: " $MyWeightPercent
    $OpenStats = $driver.FindElementByClassName("avatar-equip-backing").Click()
    write-host "Exit GetWeight."
    return $MyWeightPercent 
}

function GetStats
{
    $statsArray = @();

    $OpenStats = $driver.FindElementByClassName("avatar-equip-backing").Click()
    ping localhost -n 2 | Out-Null
        
    $GetStr = $driver.FindElementByName("strength")
    $MyStr = $GetStr[0].Text
    $RealStr = $MyStr[0].ToString()
    $statsArray += $RealStr
    #write-host "Parsed Str:" $RealStr

    $GetDex = $driver.FindElementByName("dexterity")
    $MyDex = $GetDex[0].Text
    $RealDex = $MyDex[0].ToString()
    $statsArray += $RealDex
    #write-host "Real Dex:" $RealDex

    $GetInt = $driver.FindElementByName("intelligence")
    $MyInt = $GetInt[0].Text
    $RealInt = $MyInt[0].ToString()
    $statsArray += $RealDex
    #write-host "Real Int:" $RealInt

    $GetInventoryWeight = $driver.FindElementByName("inventoryWeight")
    $MyWeightPercent = (($GetInventoryWeight[0].Text).Split('(%')[1])
    $statsArray += $MyWeightPercent 
    #Write-Host "My Inventory Weight:" $MyWeightPercent

    #start-sleep 1;
    #close window
    $OpenStats = $driver.FindElementByClassName("avatar-equip-backing").Click()
    write-host "Exit getStats."
    return $statsArray
}

function GetMyEquip
{
    $statsArray = @();
    $myEquipArray = @();
    try
    {
        $OpenStats = $driver.FindElementByClassName("avatar-equip-backing").Click()
        ping localhost -n 2 | Out-Null
        $myItems = $driver.FindElementsByClassName("main-item")
        write-host "My equipment is on screen."
        write-host "Number of items in Inventory:"$myItems.count
        #write-host "Item #0:" $myItems[0].Text
    
        for ($i=0; $i -lt $myItems.count; $i++)
        {
            if ($myItems[$i].text -like "*Helm*")
            {
                $myEquipArray += $myItems[$i].Text
                write-host "Added "$myItems[$i].Text "to EqipArray" 
            }
            if ($myItems[$i].text -like "*Chest*")
            {
                $myEquipArray += $myItems[$i].Text
                write-host "Added "$myItems[$i].Text "to EqipArray" 
            }
            if ($myItems[$i].text -like "*Shirt*")
            {
                $myEquipArray += $myItems[$i].Text
                write-host "Added "$myItems[$i].Text "to EqipArray" 
            }
            if ($myItems[$i].text -like "*Gloves*")
            {
                $myEquipArray += $myItems[$i].Text
                write-host "Added "$myItems[$i].Text "to EqipArray" 
            }
            if ($myItems[$i].text -like "*Legs*")
            {
                $myEquipArray += $myItems[$i].Text
                write-host "Added "$myItems[$i].Text "to EqipArray" 
            }
            if ($myItems[$i].text -like "*Boots*")
            {
                $myEquipArray += $myItems[$i].Text
                write-host "Added "$myItems[$i].Text "to EqipArray" 
            }
            if ($myItems[$i].text -like "*RightHand*")
            {
                $myEquipArray += $myItems[$i].Text
                write-host "Added "$myItems[$i].Text "to EqipArray" 
            }
            if ($myItems[$i].text -like "*LeftHand*")
            {
                $myEquipArray += $myItems[$i].Text
                write-host "Added "$myItems[$i].Text "to EqipArray" 
            }
            if ($myItems[$i].text -like "*RightRing*")
            {
                $myEquipArray += $myItems[$i].Text
                write-host "Added "$myItems[$i].Text "to EqipArray" 
            }
            if ($myItems[$i].text -like "*LeftRing*")
            {
                $myEquipArray += $myItems[$i].Text
                write-host "Added "$myItems[$i].Text "to EqipArray" 
            }
            if ($myItems[$i].text -like "*Neck*")
            {
                $myEquipArray += $myItems[$i].Text
                write-host "Added "$myItems[$i].Text "to EqipArray" 
            }
        }
      
        
        
        $GetStr = $driver.FindElementByName("strength")
        $MyStr = $GetStr[0].Text
        #write-host "MyStr:" $MyStr
        $SplitStr = $MyStr.Split(" ")
        #write-host "SplitStr0:"$SplitStr[0]
        #write-host "SplitStr1:"$SplitStr[1]
        $statsArray += $SplitStr[0]
  

        $GetDex = $driver.FindElementByName("dexterity")
        $MyDex = $GetDex[0].Text
        $SplitDex = $MyDex.Split(" ")
        $statsArray += $SplitDex[0]


        $GetInt = $driver.FindElementByName("intelligence")
        $MyInt = $GetInt[0].Text
        $SplitInt = $MyInt.Split(" ")
        $statsArray += $SplitInt[0]
        #write-host "Real Int:" $RealInt

        $GetInventoryWeight = $driver.FindElementByName("inventoryWeight")
        $MyWeightPercent = (($GetInventoryWeight[0].Text).Split('(%')[1])
        $statsArray += $MyWeightPercent 
        #Write-Host "My Inventory Weight:" $MyWeightPercent

        #start-sleep 1;
        #close window
        $OpenStats = $driver.FindElementByClassName("avatar-equip-backing").Click()
        write-host "Exit getStats."
        #return $statsArray
        return $myEquipArray
    }
    catch
    {
        write-host "!!!!!!!!!!!!!!!!!!!!!!"
        write-host "Unable to get character equipment."
        write-host "!!!!!!!!!!!!!!!!!!!!!!"
        
        return "ERROR"
    }
}

function GetNearbyItems
{
    $NearbyItemsButton = $driver.FindElementById("main-itemlist")
    if ($NearbyItemsButton.Displayed -eq $true)
    {
        $NearbyItemsButton.Click()
        $AvailableNearbyItems = $driver.FindElementsById("right")
        if ($AvailableNearbyItems.Displayed -eq $true)
        {
            #DOESNT WORK
            $return = $AvailableNearbyItems.Count
        }
        if ($AvailableNearbyItems.Displayed -eq $false)
        {
            write-host "Pop-up for nearby items did not pop-up!"
            $return = $null
        }
    }
    if ($NearbyItemsButton.Displayed -eq $false)
    {
        write-host "Item Button Not found!"
        $return = $null
    }
    write-host "Exit getNearbyItems."
    return $return
}

function doItemCollect
{
    param($Equipment)
    $ajax = $Equipment.FindElementByPartialLinkText("Collect")
    $ajax.click()
    write-host "Collected Item."
    ping localhost -n 2 | out-null

}

function EvaluateLootByIgnorelist()
{
    (Ping loopback -n 5) | Out-Null

    
    If ($driver.FindElementsById("inline-items").Displayed)
    {
        $myItemsArray = @();
        write-host "Enemy Loot screen is open."

        $myItems = $driver.FindElementsByClassName("main-item-container")
        #$driver.FindElementByPartialLinkText(
        write-host "Number of containers disaplyed:"$myItems.count
        
        Write-Host "Finding items not in ignore list."
        $val = "W3SVC1"

        $tosearch = $IgnoreList
        if ($tosearch -eq $NULL)
        {
            write-host "IgnoreList undefined or set to disable, exiting function EvaluateLootByIgnorelist"
            return $false
        }
        $lineitem = ($tosearch | select-string -Pattern $val -NotMatch).LineNumber

        for ($i=0; $i -lt $myItems.count; $i++)
        {
            write-host "Evaluating item number: " $i
            for ($f=0; $f -lt $lineitem.count; $f++)
            {
                $droplistitem = ($tosearch | Select-Object -Index $f)
                #write-host "MUST Drop: "$droplistitem
                if ($myItems[$i].Text -like "*Collect*" -and $myItems[$i].text -like $droplistitem)
                {
                    write-host "Item $i was present in the IgnoreList. Breaking (skipping)"
                    break;
                }
                elseif ($myItems[$i].Text -like "*Collect*" -and $myItems[$i].text -notlike $droplistitem -and $f -eq $lineitem.Count-1)
                {
                    write-host "Item $i was NOT present in the IgnoreList, adding to our list of items to collect."
                    $myItemsArray += $myItems[$i]
                }
            }
        }
        write-host "End of initial eval for lootable items."
        write-host ""
        return $myItemsArray
    }
}

function doPickList()
{
    try
    {
        $loot = EvaluateLootByIgnorelist

        if ($loot.count -gt 0)
        {
            write-host "Looting items found not inside IgnoreList"
            doItemCollect $loot
            while ($loot.count -gt 0)
            {
                write-host "Attempting to loot a desired item."
                $loot = EvaluateLootByIgnorelist
                if ($loot.count -eq 0 -or $loot -eq $NULL)
                {
                    write-host "All desired items have been looted."
                    break;
                }
                else
                {
                    write-host "Current number of items need collecting: " $loot.count
                    doItemCollect $loot
                }
            }

        }
    }
    catch
    {
        write-host "!!!!!!!!!!!!!!!!!!!!!!"
        write-host "Unable to get list of items."
        write-host "!!!!!!!!!!!!!!!!!!!!!!"
        isPopupDisplayed
        break;
    }
}

function LootEnemyItems()
{
   $loot = $driver.FindElementByPartialLinkText("Collect")
   if ($loot.Displayed)
   {
        write-host "There are items on screen. Preparing for autoloot."
        doPickList
        write-host "Autoloot completed."
        #$GoldLoot.Text
        #$return = $true
        start-sleep -s 2
   }
   else
   {
        write-host "Lootable items found."
        #$return = "No Lootable items found."

   }
   write-host "Exit LootEnemyItems."
   return #$return
}

function LootEnemyGold()
{
   $GoldLoot = $driver.FindElementByPartialLinkText("gold")
   if ($GoldLoot.Displayed)
   {
        write-host "I see gold! Mine!"
        $EnemyGold = $GoldLoot.Text
        $GoldLoot.Click()
        
        $return = $EnemyGold
        start-sleep -s 2
   }
   else
   {
        write-host "No Gold found."
        $return = "No Gold found."

   }
   write-host "Exit LootEnemyGold."
   return $return

}

function simpleEvaluateEquip()
{
    param($toEval)
    write-host "You entered simpleEvaluateEquip function."
    #write-host "Count: "$toEval.count  
    if ($MyMode -eq $FarmT -or $MyMode -eq $Thorn)
    {
        foreach ($item in $toEval)
        {
            if ($item -like "*None*")
            {
                write-host "Unequipped item:" $item
                if ($item -like "*Chest*" -or $item -like "*LeftHand*" -or $item -like "*RightHand*")
                {
                    write-host "You don't have a key item equipped!"
                    ### add logging/alert
                    dologGeneric ("Account: "+$MyAccount+" Missing Key item: ("+$item+")")
                    write-host "Exit LootEnemyGold."
                    return $False
                }
                   
            }
        
        }
    }
        
}

function getEnemyName()
{
    try
    {
        $characterDisplayBoxes = $driver.FindElementsByClassName("character-display-box").Text
        $enemyStats = $characterDisplayBoxes[1]
        $return = $enemyStats
    }
    catch
    {
        write-host "Unable to fetch enemy stats from function: getEnemyName()"
        dologGeneric ("Account: "+$MyAccount+" Unable to fetch enemy stats from function: getEnemyName()")
    }
}

function EvaluateEnemy()
{
    try
    {
        #$characterDisplayBoxes = $driver.FindElementsByClassName("character-display-box").Text
        $enemyHPBar = $driver.FindElementsById("hitpointsBar").Text
        #.Text
        #$charCount = $characterDisplayBoxes.count
        $charCount = ($enemyHPBar.ToCharArray() | Where-Object {$_ -eq '/'} | Measure-Object).Count
        #write-host "charCount:"$charcount
        if ($charCount -gt 1)
        {
            $hpArray = $enemyHpBar[1].Split("/")
            #write-host "Enemy HP:" $hpArray
            #write-host "text length:" $enemyHPBar.Length
            #write-host "HPBar0:"$enemyHPBar[0].length
            #write-host "HPBar1:"$enemyHPBar[1].length
            <#
            if ($enemyHPBar[1] -eq $null)
            {
                write-host "Null on value 1"
            }
            #>
            write-host "Enemy is on screen." 
            write-host "Health Bars (ME) (Enemy):" $enemyHPBar
            write-host "Player Count: $charCount"
            #write-host "Player Display Boxes: $characterDisplayBoxes" 
            #write-host "count:" $enemyHPBar.count 
            $return = "Alive"
            ###set active combat
            $InActiveCombat = $true
        }
        else
        {
            write-host "Only my own HP bar found. Presume I am alone"
            $return = "Dead"
            ###set active combat
            $InActiveCombat = $false
        } 

    }
    catch
    {
        write-host "!!!!!!!!!!!!!!!!!!!!!!"
        write-host "ERROR: No HP Bars found. What do?"
        write-host "!!!!!!!!!!!!!!!!!!!!!!"
     
        #figure out what we want to do here
        $return = "ERROR"
    }
    
    <#
    try{
    if ($driver.FindElementById("inline-items").Displayed -eq $true -or $driver.FindElementById("inline-characters").Displayed -eq $true)
    {
        write-host "Evaluation of Enemy: He's dead Jim."
        $return = "Dead"
    }
    }
    catch{
        $return = "Alive"
    return $return
    #>
    write-host "Exit EvaluateEnemy."
    return $return
}

##### Navagation Logic from EvaluateAction.ps1 ####

function doRest()
{
     #check to see if in rest and and need it
    $checkrest = $driver.FindElementsByClassName("main-button")
    foreach ($thing in $checkrest)
    {
        $onclickRest = $thing.GetAttribute('onclick')
        
        write-host "onclickrest:" $onclickRest
        if ($onclickRest -eq "doRest()")
        {
            write-host "Rest stop found. Resting."
            $thing.Click()
            ping loopback -n 50 | Out-Null
            write-host "Exit DoRest."
            return $true
        }
    }   
}

function doExplore
{
    "Exploring."
    $driver.Keyboard.SendKeys("W");
    "Sleeping for 10 seconds..."
    ping localhost -n 10 | Out-Null
    write-host "Exit doExplore."
}

function gotoDestination()
{
    param(
    $Destination
    )
    write-host "Inside goToDestination."
    write-host "Param Passed:" $Destination
    #write-host "Param Type:" $Destination.GetType()
    #write-host "Param count0:" $Destination[0]

    ##Auto rest if possible
    if ($global:MyStatus -eq $Hurt)
    {
        write-host "Attempting auto-rest; set newstatus = DoRest"
        $NewStatus = DoRest
        if ($NewStatus -eq $true)
        {
            write-host "Successfully rested!"
            return;
        }
    }
    if ($global:MyStatus -eq "Standby")
    {
        write-host "Standing by."
        return;
    }
    if ($Destination -match “[0-9]" -and $global:MyStatus -eq $Hurt)
    {
       Try
        {
            write-host "Backup strat, exit Dungeon:" 
            
            $goto = ($driver.FindElementByPartialLinkText("Head towards Troll Cave Entrance"))
            if ($goto.Displayed)
            {
                write-host "Found the button! Pressing."
                $goto.Click()
                write-host "Waiting 10 seconds..."
                ping loopback -n 10 | Out-Null
                #write-host "Backup strat eval done."
                return;
            }
        }
        catch
        {
            write-host "!!!!!!!!!!!!!!!!!!!!!!"
            write-host "Inside Destination match 0-9, status = hurt"
            write-host "!!!!!!!!!!!!!!!!!!!!!!"
            #failed
        }
    }
    
    #check to see if in combat
    if ($Destination -eq "Attack")
    {
        write-host "Finding Attack Buttons..."
        $action = $driver.FindElementByPartialLinkText("Attack")
        if ($action.Displayed -eq $true)
        {
            write-host "Attack button found, pressing."
            $action.Click()
        }
    }
  
    elseif ($Destination -eq "Leave this site and forget about it")
    {
        write-host "Leaving and forgetting about this place."
        $driver.Keyboard.SendKeys("F");
    }
    elseif ($Destination -match “[0-9]")
    {
        write-host "Evaluating destination by off IDs"
        $found = 0
        try
        {
        #write-host "Starting main eval"
        #assume we're interacting with UI nav menu, then default back to normal menu
        $DungeonUI = $driver.FindElementsByClassName("path-overlay-link")
        
            foreach ($item in $DungeonUI)
            {
                
                $onclick = $item.GetAttribute('onclick')
                write-host "Evaluating path:" $onclick
                foreach ($path in $Destination)
                {
                        
                    write-host "Path to eval against:" $path
                    #write-host $path
                    if ($onclick -like $path)
                    {
                        write-host "Path is like path:" $onclick
                        if ($onclick -like "*4838459706441728*" -and $global:MyStatus -eq $Good -and $item.Text -eq "Go Back")
                        {
                            write-host "Found Exit to Rest area, exiting."
                            $found = 1
                            $item.Click()
                            write-host "Waiting 10 seconds..."
                            ping localhost -n 10 | Out-Null
                        }
                        if ($onclick -like "*5961972819427328*" -and $global:MyStatus -eq $Good -and $item.Text -eq "Go Back" -or $item.Text -eq "Walk Here")
                        {
                            write-host "Found Exit to Smithy."
                            $found = 1
                            $item.Click()
                            write-host "Waiting 10 seconds..."
                            ping localhost -n 10 | Out-Null
                        }
                        if ($onclick -like "*5351800237457408*" -and $global:MyStatus -eq $Good -and $item.Text -eq "Venture into Troll Keep")
                        {
                            write-host "Found Troll Keep Secret path, entering."
                            $found = 1
                            $item.Click()
                            write-host "Waiting 10 seconds..."
                            ping localhost -n 10 | Out-Null
                        }
                        if ($onclick -like "*6374789917704192*" -and $global:MyStatus -eq $Good -and $item.Text -eq "Enter the cave")
                        {
                            write-host "Found Troll Cave, entering."
                            $found = 1
                            $item.Click()
                            write-host "Waiting 10 seconds..."
                            ping localhost -n 10 | Out-Null
                        }

                        if ($item.Text -eq "Go Deeper" -and $global:MyStatus -eq $Good)
                        {
                            write-host "Found a Path that goes deeper while I'm healthy."
                            $found = 1
                            $item.Click()
                            write-host "Waiting 10 seconds..."
                            ping localhost -n 10 | Out-Null
                        }
                        if ($item.Text -eq "Rest Area" -and $global:MyStatus -eq $Hurt)
                        {
                            write-host "Found a Path that goes to a rest area."
                            $found = 1
                            $item.Click()
                            write-host "Waiting 10 seconds..."
                            ping localhost -n 10 | Out-Null
                        }
                        if ($item.Text -eq "Go Back" -and $global:MyStatus -eq $Hurt)
                        {
                            write-host "Found a Path that goes back while I'm hurt."
                            $found = 1
                            $item.Click()
                            write-host "Waiting 10 seconds..."
                            ping localhost -n 10 | Out-Null
                        }
                        else 
                        {
                            write-host "Not the correct path:" $item.Text
                        }
                    }
                }

            }
            if ($found -eq 0) #could not find destination. explore
            {
                write-host "Path not found."
                #explore
                doExplore
            }
        }
        catch
        {
            write-host "!!!!!!!!!!!!!!!!!!!!!!"
            write-host "Inside Evaluating destination by off ID"
            write-host "!!!!!!!!!!!!!!!!!!!!!!"
        <#
            $RegularUI = $driver.FindElementsByClassName("main-button")
            
            foreach ($item in $RegularUI)
            {
                $onclick = $item.GetAttribute('onclick')
                if ($onclick -like $Destination)
                {
                    write-host "Found desired destination on Regular screen, clicking."
                    $found = 1
                    $item.Click()
                    write-host "Waiting 10 seconds..."
                    ping loopback -n 10 | Out-Null
                }
            }
            if ($found -eq 0) #could not find destination. explore
            {
                $driver.Keyboard.SendKeys("W");
                write-host "Waiting 10 seconds..."
                ping loopback -n 10 | Out-Null
            }
        #>}
        
    }

    else 
    {
        Try
        {
            write-host "Finding my destination on screen, attempting to move to:" $Destination
            
            $goto = ($driver.FindElementByPartialLinkText($Destination))
            write-host "Clicking on:" $goto.Text
            if ($goto.Text -eq "(R)")
            {
                $goto.Click()
                write-host "Sleeping for 50 seconds"
                ping loopback -n 50 | Out-Null
            }
            else
            {
                if ($goto.Displayed)
                {
                    write-host "Found the button! Pressing."
                    $goto.Click()
                }
                write-host "Waiting 10 seconds..."
                ping loopback -n 10 | Out-Null
            }
         
        }
        Catch
        {
            write-host "!!!!!!!!!!!!!!!!!!!!!!"
            write-host "Destination not found. Trying to explore"
            write-host "!!!!!!!!!!!!!!!!!!!!!!"
            
        
            $driver.Keyboard.SendKeys("W");
            write-host "Waiting 10 seconds..."
            ping loopback -n 10 | Out-Null
            #write-host "Element not present."
        }
    }
    write-host "Exit gotoDestination."
}

function checkStatus()
{
    param($currentEquip)
    if ($currentEquip -eq $false)
    {
        #write-host "I'm missing key equipment, changing mode to stand-by."
        if ($MyMode -eq $FarmT -or $MyMode -eq $Thorn -or $MyMode -eq $POP)
        {
            write-host "I'm missing key equipment, changing mode to stand-by."
            $global:MyStatus = $StandBy
            #write to generic log to alert admin
            dologGeneric ("Account: "+$MyAccount+" has been set to Stand-by mode, action needed.")
            dologGeneric ("Account: "+$MyAccount+" current MODE: "+$MyMode)
            $MyGold = GetGold
            dologGeneric ("Account: "+$MyAccount+" current GOLD: "+$MyGold)
            #$MyStats = GetStats
            #dologGeneric ("Account: "+$MyAccount+" current STATS: "+$MyStats)
            write-host "Exit checkStatus."
            return $StandBy
        }
    }
    else {
        write-host "    Set Status to default value, unknown: $unknown"
        write-host "Exit checkStatus."
        #$global:MyStatus = $unknown
        return $unknown
    }
}

function isPopupDisplayed()
{
    try
    {
        #$myPopUp = $driver.FindElementsByClassName("popup")
        if ($displayedPopup = $driver.FindElementsById("popup_footer_okay_1").Displayed)
        {
            write-host "We're inside a pop-up, check if Captcha"
            try{
                $captcha = $driver.FindElementById("recaptcha-anchor")
                $captcha.click()
                }
            catch{
                write-host "Unable to find recaptcha anchor"
                }
            write-host "Found Popup Messaged displayed. Finding close function..."
            $PopUp = $driver.FindElementsByClassName("popup_message_okay")
            write-host "PopUp var:" $PopUp.text
            $onClick = $PopUp.GetAttribute('onclick')
            write-host "onclick:" $onClick
            foreach ($item in $PopUp)
            {
                write-host "Found item:" $item
                $closePopup = $item.GetAttribute('onclick')
                if ($closePopup -eq "closepopupMessage(1)")
                {
                    write-host "Found close function, executing..."
                    $item.Click()
                    ping loopback -n 2 | Out-Null
                    write-host "Exit isPopupDisplayed"
                }
            }
        }
    }
    catch
    {
        write-host "!!!!!!!!!!!!!!!!!!!!!!"
        write-host "Could not find popup"
        write-host "!!!!!!!!!!!!!!!!!!!!!!"
    }
}
function EvalGroupChat()
{

    param($Group)

    write-host "Start of EvalGroupChat function..."
    write-host "Confirming chat log directories..."
    if([string]::IsNullOrEmpty($Group)) 
    {
        write-host "Group is UNDEFINED, using default location"
        $Group = "C:\Ini\Data\Log\GroupChat\DefaultGroupChatLog.txt"
    }
    if (!(test-path $Group))
    {
        write-host "Path does to Group Chat does not exist... creating."
        try{
            new-item $Group -ItemType file -Force
        }
        Catch{
            write-host "Unable to create dir:" $Group
        }
    }
    else
    {
        write-host "Confirmed directory."
    }

    $counter = 0
    $day = (get-date -UFormat %m%d)
    $dayForLog = "[$day]"
    write-host "Switching context to Group Chat."
    $groupChatTab = $driver.FindElementsById("GroupChat_tab")
    foreach ($thing in $groupChatTab)
    {
        $groupChatTab = $thing.GetAttribute('onclick')
        
        write-host "onClickSwitchToGroupChat:" $groupChatTab
        if ($groupChatTab -eq "changeChatTab(`"GroupChat`")")
        {
            try{
                write-host "Group Chat Tab Found, switching."
                $thing.Click()
                #ping loopback -n  | Out-Null
                write-host "Exit Switch to Group Chat."
                #return $true
            }
            catch{
                write-host "Unable to switch to group chat, writing to event log."
            }
        }
        else
        {
            write-host "Could not find expected value of group chat onClick function."
            #write-host "Expected:" $val
        }
    }   


    $groupChat = $driver.FindElementsById("chat_messages_GroupChat")
    write-host "Total Count for groupChat: " $groupChat.count
    $chatMessageMain = $groupChat[0].FindElementsByClassName("chatMessage-main")
    write-host "Total Count for groupChatMessages: " $chatMessageMain.count
    $getFileContent = get-content $Group
    #for ($i=0; $i -lt $chatMessageMain.count; $i++)
    for ($i=$chatMessageMain.count; $i -ge 0; $i--)
    {
        write-host ""
        write-host "Eval chat message #:$i" 
        $chatMessageTime = $chatMessageMain[$i].FindElementsByClassName("chatMessage-time")
        $chatMessageText = $chatMessageMain[$i].FindElementsByClassName("chatMessage-text") 
        #write-host "Message info text0:" $chatMessageText[0].text
        #write-host "Message info text1:" $chatMessageText[1].text
        $groupChatToEval = $chatMessageText[1].text
        $time = $chatMessageTime[0].text
        $groupChatCombined = $dayForLog+ $chatMessageTime[0].text+ $chatMessageText[0].text+$chatMessageText[1].text
        write-host $groupChatCombined


        try{
            $isInLog = ($getFileContent | Select-String -SimpleMatch $groupChatToEval)
        }
        catch{
            write-host "########################"
            write-host "Broke trying to find: $groupChatToEval"
            write-host "########################"
            continue;
        }
        write-host "isInLog value:" $isInLog
        if([string]::IsNullOrEmpty($isInLog)) 
        {            
            Write-Host "Nothing was found in:" $_.FullName "Searching for:" $groupChatToEval
            $groupChatCombined | Add-Content $Group
            $counter++            
        } 
        else 
        {
            #init text counter, if counter not equal number of timestamps collected, we add item to log
            $textCounter = 0;            
            #evalute if message was present with different timestamp
            write-host "Found a match while searching for:" $groupChatToEval    
            #Write-Host "Method Type for isInLog:" $isInLog.GetType()
            [System.String[]]$parsed = $isInLog
            [System.String[]]$parsed = $parsed.Split("][*]")
            write-host "Parsed isInLog:" $parsed
            #write-host "Method Type for parsed:" $parsed
            $tempArray = @()
            foreach ($item in $parsed)
            {
                if ($item -like "*:*" -and $item.Length -le 5)
                {
                    Write-Host "Player message timestamp from Log:" $item
                    $item = $item.Insert(0,"[")
                    $item = $item+"]"
                    $tempArray+= $item
                    write-host "Number of items matching player chat log text:" $tempArray.Count
                }
            }
            #test to see if our temp array matches any instances of timestamps in group chat string 
            if ($tempArray.Count -gt 0)
            {
                write-host "Total number of matching text in logs to test against:" $tempArray.Count
                for ($a=0; $a -lt $tempArray.Count; $a++)
                {
                    write-host "Compare log time entry:" $time
                    write-host "With player text timestamp:" $tempArray[$a]
                    if ($tempArray[$a] -eq $chatMessageTime[0].text)
                    {
                        write-host "Message matches timestamp of previous dialog"
                        $textCounter++
                    }
                }
                #if ($textCounter -lt $tempArray.Count)
                if ($textCounter -gt 0)
                {
                    write-host "!!!!!!!!!!!!!!!!!"
                    write-host "Found duplicate text, disgarding."
                    write-host "!!!!!!!!!!!!!!!!!"                
                }
                else
                {
                    write-host "@@@@@@@@@@@@@@@@@"
                    write-host "Found duplicate text but unique timestamp, adding to log!"
                    write-host "@@@@@@@@@@@@@@@@@"
                    $groupChatCombined | Add-Content $Group
                }  
            }
        }
    }
    return $counter
}



### Initialize 
$MyLocation = $Unknown
#ping localhost -n 1 | out-null
#skipping for now
#$MyStats = GetStats
#dologSpecific ("Current Stats: "+$MyStats)
#write-host "My Stats:" $MyStats
    
[int]$StatusCounter = 0
        $MyEquip = GetMyEquip
        dologSpecific ("My Current Equipment: "+$MyEquip)
        write-host "My Equipped Items..."

function Main()
{
    dologSpecific "Script Startup."
    write-host "Initilizing main function..."

    if ($MyMode -eq $FarmT -or $MyMode -eq $Thorn -or $MyMode -eq $LazyWatch -or $MyMode -eq $POP)
    {
        #Initilize
        $MyLocation = GetLocation
        dologSpecific ("Current Location: "+$MyLocation)
        write-host "My Location:" $MyLocation

        #$MyStats = GetStats
        #dologSpecific ("Current Stats: "+$MyStats)
        #write-host "My Stats:" $MyStats
    
        [int]$MyHealth = GetEffectiveHealth
        dologSpecific ("Current Health: "+$MyHealth) 
        write-host "My Health:" $MyHealth

        [int]$MyGold = GetGold
        dologSpecific ("Current Gold: "+$MyGold)
        dologSpecific ("Target Gold: "+$DesiredGold) 
        write-host "My Gold:" $MyGold
        write-host "Desired Gold:" $DesiredGold
        
        <#
        $MyEquip = GetMyEquip
        dologSpecific ("My Current Equipment: "+$MyEquip)
        write-host "My Equipped Items..."
        #>

        $amiEquipped = simpleEvaluateEquip $MyEquip
        dologSpecific ("Am I equipped?: "+$amiEquipped)

        $global:MyStatus = checkStatus $amiEquipped
        dologSpecific ("My Current Status: "+$global:MyStatus)
        write-host "Status Counter:" $StatusCounter
        ping localhost -n 3 | Out-Null

        while ($MyGold -lt $DesiredGold)
        {
            $StatusCounter++
            write-host ""
            write-host "###### Start of Loop ######"
            write-host "My Account:" $MyAccount
            ping localhost -n 2 | Out-Null

            [int]$MyHealth = GetEffectiveHealth
            dologSpecific ("Current Health: "+$MyHealth) 
            write-host "My Health:" $MyHealth

            [int]$MyGold = GetGold
            dologSpecific ("Current Gold: "+$MyGold)
            dologSpecific ("Target Gold: "+$DesiredGold) 
            write-host "My Gold:" $MyGold
            write-host "Desired Gold:" $DesiredGold

            if ($global:MyStatus -ne $Good)
            {
                write-host "My Status: $global:MyStatus"
                write-host "Started loop in non-Good, state, re-evaluating."
                $amiEquipped = simpleEvaluateEquip $MyEquip
                $global:MyStatus = checkStatus $amiEquipped
                write-host "My new Status: $global:MyStatus"

            }
            
            #start-sleep 2;
            $MyLocation = GetLocation
            write-host "Main: End GetLocation."
            if (($StatusCounter % 50 -eq 0) -and $isEvalGroupChatEnabled -eq $True)
            {
                write-host "%%%%%%%%%%%%%%%%%%%%%%%%%"
                write-host "Logging Group Chat."
                write-host "%%%%%%%%%%%%%%%%%%%%%%%%%"
                $newMessages = EvalGroupChat $MyGroup
                write-host "%%%%%%%%%%%%%%%%%%%%%%%%%"
                write-host "Added $newMessages new items to group chat."
                write-host "%%%%%%%%%%%%%%%%%%%%%%%%%"
            }
            else
            {
                write-host "Status counter not divisable by 10 and/or evalgroupchat is disabled, curret settings:"
                write-host "Status counter modulus 10:" ($StatusCounter % 10)
                write-host "isEvalGroupChatEnabled:" $isEvalGroupChatEnabled
            }
            
            #check to see if we need to stop farming
            if ($StatusCounter % 10 -eq 0)
            {
                write-host "Inside normal status check function."
                #every 10 ticks on our status counter and we check the status of our gear and items
                $MyEquip = GetMyEquip
                if ($MyEquip -eq "ERROR")
                {
                    write-host "Unable to check gear, seeing if there's a popup blocking us."
                    isPopupDisplayed
                    continue;
                }
                write-host "My Equipped Items..."
                $amiEquipped = simpleEvaluateEquip $MyEquip
                $global:MyStatus = checkStatus $amiEquipped
                #write-host "Checking Weight.."
                ####DROP ITEM LOGIC ######
                #DIABLED, functional but slow.
                <#
                $currentWeight = GetWeight
                if ($currentWeight -gt 75)
                {
                    write-host "Attempting to drop items from droplist."
                    $result = doDropList
                    if ($result -eq $true)
                    {
                        write-host "Successfully dropped items in DropList."
                        dologSpecific ("Successfully dropped items in DropList.")
                    }
                    else
                    {
                        dologSpecific ("Failed to drop items in DropList")
                        write-host "Failed to drop items in DropList"
                    }
                }
                ####DROP ITEM LOGIC ######
                #>
            }
            
            if ($MyMode -eq $LazyWatch)
            {
                "In LazyWatch mode..."
                write-host "Waiting 10 seconds..."
                ping localhost -n 10 | Out-Null
                continue;
            }
            if ($global:MyStatus -eq $Standby)
            {
                "In Standby.. Check items."
            }
            elseif ($MyHealth -ge 97)
            {
                
                $global:MyStatus = $Good
                
                write-host "Main: Start EvaluateAction."
                $Destination = EvaluateAction $MyLocation $MyMode $global:MyStatus $global:routeComplete
                if ($Destination -like "*ERROR*")
                {
                    write-host "Caught error in GetDestination, checking popups then change status to standby, goto main"
                    isPopupDisplayed
                    dologGeneric ("Account: "+$MyAccount+" Caught error in GetDestination, change status to standby.")
                    #$global:MyStatus = $unknown
                    continue;
                }
                write-host "Main: End EvaluateAction."
                write-host "My Destination:"$Destination 
                #do action
                write-host "Main: Start GoToDestination."
                GoToDestination $Destination
                write-host "Main: End GoToDestination."
                write-host "Main: Start GetEffectiveHealth"
                $MyHealth = GetEffectiveHealth
                write-host "Main: End GetEffectiveHealth"
                write-host "Main: Start GetGold."
                $MyGold = GetGold
                write-host "Main: End GetGold."
            }
            elseif ($MyHealth -ge 40 -and $MyHealth -lt 97)
            {
                $global:MyStatus = $Hurt
                write-host "I'm HURT!"
                write-host "Main: Start EvaluateAction."
                $Destination = EvaluateAction $MyLocation $MyMode $global:MyStatus $global:routeComplete
                if ($Destination -like "*ERROR*")
                {
                    write-host "Caught error in GetDestination, checking popups then change status to standby, goto main"
                    isPopupDisplayed
                    dologGeneric ("Account: "+$MyAccount+" Caught error in GetDestination, change status to standby.")
                    #$global:MyStatus = $unknown
                    continue;
                }
                
                write-host "Main: End EvaluateAction."
                write-host "My Destination:"$Destination 
                #do action
                write-host "Main: Start GoToDestination."
                GoToDestination $Destination
                write-host "Main: End GoToDestination."
                write-host "Main: Start GetEffectiveHealth"
                $MyHealth = GetEffectiveHealth
                write-host "Main: End GetEffectiveHealth"
                write-host "Main: Start GetGold."
                $MyGold = GetGold
                write-host "Main: End GetGold."
            }

            elseif ($MyHealth -lt 40)
            {
                $global:MyStatus = $Standby
                write-host "Main: Status changed to Standby."
                write-host "Main: Start EvaluateAction."
                $Destination = EvaluateAction $MyLocation $MyMode $global:MyStatus $global:routeComplete
                if ($Destination -like "*ERROR*")
                {
                    write-host "Caught error in GetDestination, checking popups then change status to standby, goto main"
                    isPopupDisplayed
                    dologGeneric ("Account: "+$MyAccount+" Caught error in GetDestination, change status to standby.")
                    #$global:MyStatus = $Standby
                    continue;
                }
                write-host "Main: End EvaluateAction."
                write-host "My Destination:"$Destination 
                #do action
                write-host "Main: Start GoToDestination."
                GoToDestination $Destination
                write-host "Main: End GoToDestination."
                write-host "Main: Start GetEffectiveHealth"
                $MyHealth = GetEffectiveHealth
                write-host "Main: End GetEffectiveHealth"
                write-host "Main: Start GetGold."
                $MyGold = GetGold
                write-host "Main: End GetGold."
                continue;
            }
        }
        if ($MyGold -ge $DesiredGold)
        {
            dologGeneric ("Account: "+$MyAccount+" has reached desired state of GOLD ("+$DesiredGold+")")
            dologGeneric ("Account: "+$MyAccount+" My GOLD: ("+$MyGold+")")
            write-host "I have met my exit condition, alerting admin."
            ##alert admin
        }
    }
}

Main

$driver.Close()