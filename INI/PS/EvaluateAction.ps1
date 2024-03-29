﻿function EvaluateAction()
{
    param(
        [string]$MyLocation,
        [int]$MyMode,
        [int]$global:MyStatus,
        [int]$routeComplete
    )
    #cl = currentLocation
    #m = Mode
        #[int]$FarmT = 0;
        #[int]$LazyWatch = 1;
        #[int]$SnipeItem = 2;
    #d = Danger Level
    write-host "Current Location:" $MyLocation
    write-host "Current Mode:" $MyMode
    write-host "Current Status:" $global:MyStatus

    #check to see if I'm in combat regardless of location

    if ($MyLocation -eq "Aera")
    {
        write-host "I'm in Aera"
        if ($MyMode -eq $FarmT -or $MyMode -eq $POP)
        {
            #
            if ($global:MyStatus -eq $Good){$return = "Head towards Aera Countryside"}
            elseif ($global:MyStatus -eq $Hurt){$return = "Go to the Inn"}
            else {$return = "ERROR"}
        }
        if ($MyMode -eq $Thorn)
        {
            if ($global:MyStatus -eq $Good){$return = "Head towards North West Hills"}
            elseif ($global:MyStatus -eq $Hurt){$return = "Go to the Inn"}
            else {$return = "ERROR"}
        }
        #define other modes here as if
    }
    elseif ($MyLocation -eq "Aera Inn")
    {
        write-host "I'm in Aera Inn"
        if ($global:MyStatus -eq $Good){$return = "Leave the Inn"}
        elseif ($global:MyStatus -eq $Hurt){$return = "Rest"}
        else {$return = "ERROR"}
    }
    elseif ($MyLocation -eq "North West Hills")
    {
        write-host "I'm in North West Hills"
        if ($MyMode -eq $FarmT -or $MyMode -eq $POP)
        {
            if ($global:MyStatus -eq $Good){$return = "Head towards Aera"}
            elseif ($global:MyStatus -eq $Hurt){$return = "Head towards Aera"}
            else {$return = "ERROR"}
        }
        if ($MyMode -eq $Thorn)
        {
            if ($global:MyStatus -eq $Good){$return = "Head towards The Fork"}
            elseif ($global:MyStatus -eq $Hurt){$return = "Head towards Aera"}
            else {$return = "ERROR"}
        }
    }
    elseif ($MyLocation -eq "Canyonside Plains")
    {
        write-host "I'm in Canyonside Plains"
        if ($MyMode -eq $FarmT -or $MyMode -eq $POP)
        {
            if ($global:MyStatus -eq $Good){$return = "Head towards North West Hills"}
            elseif ($global:MyStatus -eq $Hurt){$return = "Head towards North West Hills"}
            else {$return = "ERROR"}
        }
        if ($MyMode -eq $Thorn)
        {
            if ($global:MyStatus -eq $Good){$return = "Head towards North West Hills"}
            elseif ($global:MyStatus -eq $Hurt){$return = "Head towards North West Hills"}
            else {$return = "ERROR"}
        }
    }
    elseif ($MyLocation -eq "Cricketon Cave Entrance")
    {
        write-host "I'm at Cricketon Cave Entrance"
        if ($MyMode -eq $FarmT -or $MyMode -eq $POP)
        {
            if ($global:MyStatus -eq $Good){$return = "Head towards North West Hills"}
            elseif ($global:MyStatus -eq $Hurt){$return = "Head towards North West Hills"}
            else {$return = "ERROR"}
        }
        if ($MyMode -eq $Thorn)
        {
            if ($global:MyStatus -eq $Good){$return = "Head towards North West Hills"}
            elseif ($global:MyStatus -eq $Hurt){$return = "Head towards North West Hills"}
            else {$return = "ERROR"}
        }
    }
    elseif ($MyLocation -eq "The Fork")
    {
        write-host "I'm in The Fork"
        if ($MyMode -eq $FarmT -or $MyMode -eq $POP)
        {
            if ($global:MyStatus -eq $Good){$return = "Head towards North West Hills"}
            elseif ($global:MyStatus -eq $Hurt){$return = "Head towards North West Hills"}
            else {$return = "ERROR"}
        }
        if ($MyMode -eq $Thorn)
        {
            if ($global:MyStatus -eq $Good){$return = "Head towards High Road"}
            elseif ($global:MyStatus -eq $Hurt){$return = "Head towards North West Hills"}
            else {$return = "ERROR"}
        }
    }
    elseif ($MyLocation -eq "Spider Cave Cavern")
    {
        write-host "I'm in Spider Cave Cavern"
        if ($MyMode -eq $FarmT -or $MyMode -eq $POP)
        {
            if ($global:MyStatus -eq $Good){$return = "Head towards The Fork"}
            elseif ($global:MyStatus -eq $Hurt){$return = "Head towards The Fork"}
            else {$return = "ERROR"}
        }
        if ($MyMode -eq $Thorn)
        {
            if ($global:MyStatus -eq $Good){$return = "Head towards The Fork"}
            elseif ($global:MyStatus -eq $Hurt){$return = "Head towards The Fork"}
            else {$return = "ERROR"}
        }
    }
    elseif ($MyLocation -eq "High Road")
    {
        write-host "I'm in High Road"
        if ($MyMode -eq $FarmT -or $MyMode -eq $POP)
        {
            if ($global:MyStatus -eq $Good){$return = "Head towards The Fork"}
            elseif ($global:MyStatus -eq $Hurt){$return = "Head towards The Fork"}T
            else {$return = "ERROR"}
        }
        if ($MyMode -eq $Thorn)
        {
            if ($global:MyStatus -eq $Good -and $routeComplete -eq $Complete)
            {
                ##START ROUTE AGAIN
                write-host "Made it back to starting position, starting reouteComplete to 0"
                $global:routeComplete = $Incomplete
                $return = "Head towards High Road: Swampland"
            }
            elseif ($global:MyStatus -eq $Good){$return = "Head towards High Road: Swampland"}
            elseif ($global:MyStatus -eq $Hurt){$return = "Head towards The Fork"}
            else {$return = "ERROR"}
        }
    }
    elseif ($MyLocation -eq "High Road: Swampland")
    {
        write-host "High Road: Swampland"
        if ($MyMode -eq $FarmT -or $MyMode -eq $POP)
        {
            if ($global:MyStatus -eq $Good){$return = "Head towards High Road"}
            elseif ($global:MyStatus -eq $Hurt){$return = "Head towards High Road"}
            else {$return = "ERROR"}
        }
        if ($MyMode -eq $Thorn)
        {
            if ($global:MyStatus -eq $Good -and $routeComplete -eq $Complete){$return = "Head towards High Road"}
            elseif ($global:MyStatus -eq $Good){$return = "Head towards High Road: Dense Forest"}
            elseif ($global:MyStatus -eq $Hurt){$return = "Head towards High Road"}
            else {$return = "ERROR"}
        }
    }
    elseif ($MyLocation -eq "Dense Jungle")
    {
        write-host "I'm in Dense Jungle"
        if ($MyMode -eq $FarmT -or $MyMode -eq $POP)
        {
            if ($global:MyStatus -eq $Good){$return = "Head towards High Road: Swampland"}
            elseif ($global:MyStatus -eq $Hurt){$return = "Head towards High Road: Swampland"}
            else {$return = "ERROR"}
        }
        if ($MyMode -eq $Thorn)
        {
            if ($global:MyStatus -eq $Good){$return = "Head towards High Road: Swampland"}
            elseif ($global:MyStatus -eq $Hurt){$return = "Head towards High Road: Swampland"}
            else {$return = "ERROR"}
        }
    }
    ### coninue here
    elseif ($MyLocation -eq "High Road: Dense Forest")
    {
        write-host "I'm in High Road: Dense Forest"
        if ($MyMode -eq $FarmT -or $MyMode -eq $POP)
        {
            if ($global:MyStatus -eq $Good){$return = "Head towards High Road: Swampland"}
            elseif ($global:MyStatus -eq $Hurt){$return = "Head towards High Road: Swampland"}
            else {$return = "ERROR"}
        }
        if ($MyMode -eq $Thorn)
        {
            if ($global:MyStatus -eq $Good -and $routeComplete -eq $Complete){$return = "Head towards High Road: Swampland"}
            elseif ($global:MyStatus -eq $Good){$return = "Head towards High Road: Forest"}
            elseif ($global:MyStatus -eq $Hurt){$return = "Head towards High Road: Swampland"}
            else {$return = "ERROR"}
        }
    }
    elseif ($MyLocation -eq "High Road: Forest")
    {
        write-host "I'm in High Road: Forest"
        if ($MyMode -eq $FarmT -or $MyMode -eq $POP)
        {
            
            if ($global:MyStatus -eq $Good){$return = "Head towards High Road: Dense Forest"}
            elseif ($global:MyStatus -eq $Hurt){$return = "Head towards High Road: Dense Forest"}
            else {$return = "ERROR"}
        }
        if ($MyMode -eq $Thorn)
        {
            if ($global:MyStatus -eq $Good -and $routeComplete -eq $Complete){$return = "Head towards High Road: Dense Forest"}
            elseif ($global:MyStatus -eq $Good){$return = "Head towards High Road: Waterfall"}
            elseif ($global:MyStatus -eq $Hurt){$return = "Head towards High Road: Dense Forest"}
            else {$return = "ERROR"}
        }
    }
    elseif ($MyLocation -eq "The Den of a Fallen Beast")
    {
        write-host "I'm in The Den of a Fallen Beast"
        if ($MyMode -eq $FarmT -or $MyMode -eq $POP)
        {
            
            if ($global:MyStatus -eq $Good){$return = "Head towards High Road: Forest"}
            elseif ($global:MyStatus -eq $Hurt){$return = "Head towards High Road: Forest"}
            else {$return = "ERROR"}
        }
        if ($MyMode -eq $Thorn)
        {
            if ($global:MyStatus -eq $Good -and $routeComplete -eq $Complete){$return = "Head towards High Road: Forest"}
            elseif ($global:MyStatus -eq $Good){$return = "Head towards High Road: Forest"}
            elseif ($global:MyStatus -eq $Hurt){$return = "Head towards High Road: Forest"}
            else {$return = "ERROR"}
        }
    }
    elseif ($MyLocation -eq "High Road: Waterfall")
    {
        write-host "I'm in High Road: Waterfall"
        if ($MyMode -eq $FarmT -or $MyMode -eq $POP)
        {
            
            if ($global:MyStatus -eq $Good){$return = "Head towards High Road: Forest"}
            elseif ($global:MyStatus -eq $Hurt){$return = "Head towards High Road: Forest"}
            else {$return = "ERROR"}
        }
        if ($MyMode -eq $Thorn)
        {
            if ($global:MyStatus -eq $Good -and $routeComplete -eq $Complete){$return = "Head towards High Road: Forest"}
            elseif ($global:MyStatus -eq $Good){$return = "Head towards High Road: Waterfall Clearing"}
            elseif ($global:MyStatus -eq $Hurt){$return = "Head towards High Road: Forest"}
            else {$return = "ERROR"}
        }
    }
    elseif ($MyLocation -eq "High Road: Waterfall Clearing")
    {
        write-host "I'm in High Road: Waterfall Clearing"
        if ($MyMode -eq $FarmT -or $MyMode -eq $POP)
        {
            
            if ($global:MyStatus -eq $Good){$return = "Head towards High Road: Waterfall"}
            elseif ($global:MyStatus -eq $Hurt){$return = "Head towards High Road: Waterfall"}
            else {$return = "ERROR"}
        }
        if ($MyMode -eq $Thorn)
        {
            if ($global:MyStatus -eq $Good -and $routeComplete -eq $Complete){$return = "Head towards High Road: Waterfall"}
            elseif ($global:MyStatus -eq $Good -and $routeComplete -eq $Incomplete)
            {
                ##you've completed your're route!, now go back to the start
                write-host "Route Complete, setting status to 1"
                $global:routeComplete = $Complete;
                write-host "Current route status:" $routeComplete
                $return = "Head towards High Road: Waterfall"
            }
            elseif ($global:MyStatus -eq $Good){$return = "Head towards High Road: Waterfall"}
            #removing path to ogres
            #elseif ($global:MyStatus -eq $Good){$return = "Head towards High Road: Ogre Pass"}
            elseif ($global:MyStatus -eq $Hurt){$return = "Head towards High Road: Waterfall"}
            else {$return = "ERROR"}
        }
    }
    elseif ($MyLocation -eq "High Road: Ogre Pass")
    {
        write-host "I'm in High Road: Ogre Pass"
        if ($MyMode -eq $FarmT -or $MyMode -eq $POP)
        {
            
            if ($global:MyStatus -eq $Good){$return = "Head towards High Road: Waterfall Clearing"}
            elseif ($global:MyStatus -eq $Hurt){$return = "Head towards High Road: Waterfall Clearing"}
            else {$return = "ERROR"}
        }
        if ($MyMode -eq $Thorn)
        {
            if ($global:MyStatus -eq $Good -and $routeComplete -eq $Complete){$return = "Head towards High Road: Waterfall Clearing"}
            elseif ($global:MyStatus -eq $Good){$return = "Head towards High Road: Waterfall Clearing"}
            #removing pathing for ogres
            #elseif ($global:MyStatus -eq $Good){$return = "Head towards High Road: Forest Lookout"}
            elseif ($global:MyStatus -eq $Hurt){$return = "Head towards High Road: Waterfall Clearing"}
            else {$return = "ERROR"}
        }
    }
    elseif ($MyLocation -eq "High Road: Forest Lookout")
    {
        write-host "I'm in High Road: Forest Lookout"
        if ($MyMode -eq $FarmT -or $MyMode -eq $POP)
        {
            
            if ($global:MyStatus -eq $Good){$return = "Head towards High Road: Ogre Pass"}
            elseif ($global:MyStatus -eq $Hurt){$return = "Head towards High Road: Lake"}
            else {$return = "ERROR"}
        }
        if ($MyMode -eq $Thorn)
        {
            if ($global:MyStatus -eq $Good -and $routeComplete -eq $Complete){
             write-host "Go ALL the way back."
            $return = "Head towards High Road: Ogre Pass"}
            elseif ($global:MyStatus -eq $Good){
            write-host "Still need to complete your route, go to the LAKE."
            write-host "Current route status:" $routeComplete
            $return = "Head towards High Road: Lake"}
            elseif ($global:MyStatus -eq $Hurt){$return = "Head towards High Road: Lake"}
            else {$return = "ERROR"}
        }
    }
    elseif ($MyLocation -eq "High Road: Lake")
    {
        write-host "I'm in High Road: Lake"
        if ($MyMode -eq $FarmT -or $MyMode -eq $POP)
        {
            
            if ($global:MyStatus -eq $Good){$return = "Head towards High Road: Forest Lookout"}
            elseif ($global:MyStatus -eq $Hurt){$return = "Head towards Volantis River"}
            else {$return = "ERROR"}
        }
        if ($MyMode -eq $Thorn)
        {
            if ($global:MyStatus -eq $Good -and $routeComplete -eq $Complete){$return = "Head towards High Road: Forest Lookout"}
            elseif ($global:MyStatus -eq $Good -and $routeComplete -eq 0)
            {
                ##you've completed your're route!, now go back to the start
                write-host "Route Complete, setting status to 1"
                $global:routeComplete = $Complete;
                write-host "Current route status:" $routeComplete
                $return = "Head towards High Road: Forest Lookout"
            }
            elseif ($global:MyStatus -eq $Good){$return = "Head towards High Road: Forest Lookout"}
            elseif ($global:MyStatus -eq $Hurt){$return = "Head towards Volantis River"}
            else {$return = "ERROR"}
        }
    }
    elseif ($MyLocation -eq "Volantis River")
    {
        write-host "I'm in Volantis River"
        if ($MyMode -eq $FarmT -or $MyMode -eq $POP)
        {
            
            if ($global:MyStatus -eq $Good){$return = "Head towards High Road: Lake"}
            elseif ($global:MyStatus -eq $Hurt){$return = "Head towards Volantis Countryside"}
            else {$return = "ERROR"}
        }
        if ($MyMode -eq $Thorn)
        {
            if ($global:MyStatus -eq $Good -and $routeComplete -eq $Complete){$return = "Head towards High Road: Lake"}
            elseif ($global:MyStatus -eq $Good){$return = "Head towards High Road: Lake"}
            elseif ($global:MyStatus -eq $Hurt){$return = "Head towards Volantis Countryside"}
            else {$return = "ERROR"}
        }
    }
    elseif ($MyLocation -eq "Troll Caves")
    {
        write-host "I'm in Troll Caves"
        if ($MyMode -eq $FarmT -or $MyMode -eq $POP)
        {
            
            if ($global:MyStatus -eq $Good){$return = "Head towards Volantis River"}
            elseif ($global:MyStatus -eq $Hurt){$return = "Head towards Volantis River"}
            else {$return = "ERROR"}
        }
        if ($MyMode -eq $Thorn)
        {
            if ($global:MyStatus -eq $Good -and $routeComplete -eq $Complete){$return = "Head towards Volantis River"}
            elseif ($global:MyStatus -eq $Good){$return = "Head towards Volantis River"}
            elseif ($global:MyStatus -eq $Hurt){$return = "Head towards Volantis River"}
            else {$return = "ERROR"}
        }
    }
    elseif ($MyLocation -eq "Volantis Countryside")
    {
        write-host "I'm in Volantis Countryside"
        if ($MyMode -eq $FarmT -or $MyMode -eq $POP)
        {
            
            if ($global:MyStatus -eq $Good){$return = "Head towards Volantis River"}
            elseif ($global:MyStatus -eq $Hurt){$return = "Head towards Volantis"}
            else {$return = "ERROR"}
        }
        if ($MyMode -eq $Thorn)
        {
            if ($global:MyStatus -eq $Good -and $routeComplete -eq $Complete){$return = "Head towards Volantis River"}
            elseif ($global:MyStatus -eq $Good){$return = "Head towards Volantis River"}
            elseif ($global:MyStatus -eq $Hurt){$return = "Head towards Volantis"}
            else {$return = "ERROR"}
        }
    }
    ######## MAIN CITY 2 #########
    elseif ($MyLocation -eq "Volantis")
    {
        write-host "I'm in Volantis"
        if ($MyMode -eq $FarmT -or $MyMode -eq $POP)
        {
            
            if ($global:MyStatus -eq $Good){$return = "Head towards Volantis Countryside"}
            elseif ($global:MyStatus -eq $Hurt){$return = "Go to the Inn"}
            else {$return = "ERROR"}
        }
        if ($MyMode -eq $Thorn)
        {
            if ($global:MyStatus -eq $Good -and $routeComplete -eq $Complete){$return = "Head towards Volantis Countryside"}
            elseif ($global:MyStatus -eq $Good){$return = "Head towards Volantis Countryside"}
            elseif ($global:MyStatus -eq $Hurt){$return = "Go to the Inn"}
            else {$return = "ERROR"}
        }
    }
    elseif ($MyLocation -eq "Volantis Inn")
    {
        write-host "I'm in Volantis"
        if ($MyMode -eq $FarmT -or $MyMode -eq $POP)
        {
            
            if ($global:MyStatus -eq $Good){$return = "Leave the Inn"}
            elseif ($global:MyStatus -eq $Hurt){$return = "Rest"}
            else {$return = "ERROR"}
        }
        if ($MyMode -eq $Thorn)
        {
            if ($global:MyStatus -eq $Good -and $routeComplete -eq $Complete){$return = "Leave the Inn"}
            elseif ($global:MyStatus -eq $Good){$return = "Leave the Inn"}
            elseif ($global:MyStatus -eq $Hurt){$return = "Rest"}
            else {$return = "ERROR"}
        }
    }
    ####### continue here
    elseif ($MyLocation -eq "Artius River")
    {
        write-host "I'm in Artius River"
        if ($MyMode -eq $FarmT -or $MyMode -eq $POP)
        {
            
            if ($global:MyStatus -eq $Good){$return = "Head towards Aera"}
            elseif ($global:MyStatus -eq $Hurt){$return = "Head towards Aera"}
            else {$return = "ERROR"}
        }
    }
    elseif ($MyLocation -eq "Wildeburn Forest")
    {
        write-host "I'm in Wildeburn Forest"
        if ($MyMode -eq $FarmT -or $MyMode -eq $POP)
        {
            
            if ($global:MyStatus -eq $Good){$return = "Head towards Aera Countryside"}
            elseif ($global:MyStatus -eq $Hurt){$return = "Head towards Aera Countryside"}
            else {$return = "ERROR"}
        }
    }
    elseif ($MyLocation -eq "Giant Turtle")
    {
        write-host "I'm in Giant Turtle"
        if ($MyMode -eq $FarmT -or $MyMode -eq $POP)
        {
            
            if ($global:MyStatus -eq $Good){$return = "Head towards Aera"}
            elseif ($global:MyStatus -eq $Hurt){$return = "Head towards Aera"}
            else {$return = "ERROR"}
        }
    }
    elseif ($MyLocation -eq "Northern Hills")
    {
        write-host "I'm in Northern Hills"
        if ($MyMode -eq $FarmT -or $MyMode -eq $POP)
        {
            
            if ($global:MyStatus -eq $Good){$return = "Head towards Aera Countryside"}
            elseif ($global:MyStatus -eq $Hurt){$return = "Head towards Aera Countryside"}
            else {$return = "ERROR"}
        }
    }
    elseif ($MyLocation -eq "Aera Countryside")
    {
        write-host "I'm in Aera Countryside"
        if ($MyMode -eq $FarmT)
        {
            if ($global:MyStatus -eq $Good){$return = "Head towards Troll Camp"}
            elseif ($global:MyStatus -eq $Hurt){$return = "Head towards Aera"}
            else {$return = "ERROR"}
        }
        if ($MyMode -eq $POP)
        {
            if ($global:MyStatus -eq $Good){$return = "Head towards Aera Swamplands"}
            elseif ($global:MyStatus -eq $Hurt){$return = "Head towards Aera"}
            else {$return = "ERROR"}
        }
    }

    elseif ($MyLocation -eq "Aera Swamplands")
    {
        write-host "I'm in Aera Swamplands"
        if ($MyMode -eq $FarmT)
        {
            
            if ($global:MyStatus -eq $Good){$return = "Head towards Aera Countryside"}
            elseif ($global:MyStatus -eq $Hurt){$return = "Head towards Aera Countryside"}
            else {$return = "ERROR"}
        }
        if ($MyMode -eq $POP)
        {
            
            if ($global:MyStatus -eq $Good){$return = "Head towards Grand Mountain"}
            elseif ($global:MyStatus -eq $Hurt){$return = "Head towards Aera Countryside"}
            else {$return = "ERROR"}
        }
    }
    elseif ($MyLocation -eq "Grand Mountain")
    {
        write-host "I'm in Grand Mountain"
        if ($MyMode -eq $FarmT)
        {
            
            if ($global:MyStatus -eq $Good){$return = "Head towards Aera Swamplands"}
            elseif ($global:MyStatus -eq $Hurt){$return = "Head towards Aera Swamplands"}
            else {$return = "ERROR"}
        }
        if ($MyMode -eq $POP)
        {
            
            if ($global:MyStatus -eq $Good){$return = "Head towards Desert"}
            elseif ($global:MyStatus -eq $Hurt){$return = "Head towards Aera Swamplands"}
            else {$return = "ERROR"}
        }
    }
    elseif ($MyLocation -eq "Desert")
    {
        write-host "I'm in Desert"
        if ($MyMode -eq $FarmT)
        {
            
            if ($global:MyStatus -eq $Good){$return = "Head towards Grand Mountain"}
            elseif ($global:MyStatus -eq $Hurt){$return = "Head towards Grand Mountain"}
            else {$return = "ERROR"}
        }
        if ($MyMode -eq $POP)
        {
            
            if ($global:MyStatus -eq $Good){$return = "Head towards Cliffside Lookout"}
            elseif ($global:MyStatus -eq $Hurt){$return = "Head towards Grand Mountain"}
            else {$return = "ERROR"}
        }
    }
    ###### Start of path for POP
    elseif ($MyLocation -eq "Cliffside Lookout")
    {
        write-host "I'm in Cliffside Lookout"
        if ($MyMode -eq $FarmT)
        {
            
            if ($global:MyStatus -eq $Good){$return = "Head towards Desert"}
            elseif ($global:MyStatus -eq $Hurt){$return = "Head towards Rocky Path"}
            else {$return = "ERROR"}
        }
        if ($MyMode -eq $POP)
        {
            if ($global:MyStatus -eq $Good -and $routeComplete -eq $Complete)
            {
                ##START ROUTE AGAIN
                write-host "Made it back to starting position, starting reouteComplete to 0"
                $global:routeComplete = $Incomplete
                $return = "Head towards Rocky Path"
            }
            elseif ($global:MyStatus -eq $Good){$return = "Head towards Rocky Path"}
            elseif ($global:MyStatus -eq $Hurt){$return = "Head towards Rocky Path"}
            else {$return = "ERROR"}
        }
    }
    elseif ($MyLocation -eq "Rocky Path")
    {
        write-host "I'm in Rocky Path"
        if ($MyMode -eq $FarmT)
        {
            
            if ($global:MyStatus -eq $Good){$return = "Head towards Cliffside Lookout"}
            elseif ($global:MyStatus -eq $Hurt){$return = "Head towards Mountain Plains"}
            else {$return = "ERROR"}
        }
        if ($MyMode -eq $POP)
        {
            if ($global:MyStatus -eq $Good -and $routeComplete -eq $Complete){$return = "Head towards Cliffside Lookout"}
            elseif ($global:MyStatus -eq $Good){$return = "Head towards Mountain Plains"}
            elseif ($global:MyStatus -eq $Hurt){$return = "Head towards Mountain Plains"}
            else {$return = "ERROR"}
        }
    }
    
    elseif ($MyLocation -eq "Mountain Plains")
    {
        write-host "I'm in Mountain Plains"
        if ($MyMode -eq $FarmT)
        {
            
            if ($global:MyStatus -eq $Good){$return = "Head towards Rocky Path"}
            elseif ($global:MyStatus -eq $Hurt){$return = "Head towards Hermit's Cottage"}
            else {$return = "ERROR"}
        }
        if ($MyMode -eq $POP)
        {
            if ($global:MyStatus -eq $Good -and $routeComplete -eq $Complete){$return = "Head towards Rocky Path"}
            elseif ($global:MyStatus -eq $Good -and $routeComplete -eq 0)
            {
                ##you've completed your're route!, now go back to the start
                write-host "Route Complete, setting status to 1"
                $global:routeComplete = $Complete;
                write-host "Current route status:" $routeComplete
                $return = "Head towards Rocky Path"
            }
            elseif ($global:MyStatus -eq $Good){$return = "Head towards Rocky Path"}
            elseif ($global:MyStatus -eq $Hurt){$return = "Head towards Hermit's Cottage"}
            else {$return = "ERROR"}
        }
    }
    elseif ($MyLocation -eq "Hermit's Cottage")
    {
        write-host "I'm in Hermit's Cottage"
        if ($global:MyStatus -eq $Good){$return = "Head towards Mountain Plains"}
        elseif ($global:MyStatus -eq $Hurt){$return = "Rest"}
        else {$return = "ERROR"}
    }
    
    elseif ($MyLocation -eq "Troll Camp")
    {
        write-host "I'm in Troll Camp"
        if ($MyMode -eq $FarmT)
        {
            
            if ($global:MyStatus -eq $Good){$return = "Head towards Troll Cave Entrance"
            }
            elseif ($global:MyStatus -eq $Hurt){$return = "Head towards Aera Countryside"}
            else {$return = "ERROR"}
        }
    }
    elseif ($MyLocation -eq "Troll Cave Entrance")
    {
        write-host "I'm in Troll Cave Entrance"
        if ($MyMode -eq $FarmT)
        {
            
            if ($global:MyStatus -eq $Good){$return = "*6374789917704192*"} #Enter the cave
            elseif ($global:MyStatus -eq $Hurt){$return = "Head towards Troll Camp"}
            else {$return = "ERROR"}
        }
    }
    elseif ($MyLocation -eq "Troll Cave")
    {
        write-host "I'm in Troll Cave"
        if ($MyMode -eq $FarmT)
        {
            
            if ($global:MyStatus -eq $Good){$return = @("*6233658491928576*",
                    "*6355368402747392*",
                    "*5620413599055872*",
                    "*4523847580647424*"                    
                    "*4838459706441728*"
                    )
            } #Go Deeper            
            elseif ($global:MyStatus -eq $Hurt){$return = @("*6233658491928576*",
                    "*6355368402747392*",
                    "*5620413599055872*",
                    "*4838459706441728*"                    
                    )
            } #Head towards Troll Cave Entrance
            else {$return = "ERROR"}
        }
        #TO DO
        if ($MyMode -eq $Thorn)
        {
            if ($global:MyStatus -eq $Good){$return = ""}
            elseif ($global:MyStatus -eq $Hurt){$return = ""}
            else {$return = "ERROR"}
        }
    }
    elseif ($MyLocation -eq "Troll Dig")
    {
        write-host "I'm in Troll Dig"
        if ($MyMode -eq $FarmT)
        {
            if ($global:MyStatus -eq $Good){$return = @("*6258959808724992*",
                    "*6752386589655040*",
                    "*6245366304342016*",
                    "*5286275343974400*",
                    "*6442102582935552*",
                    "*5351800237457408*"                    
                    )
            }
            elseif ($global:MyStatus -eq $Hurt){$return = @("*4523847580647424*",
                    "*6009402344603648*",
                    "*6258959808724992*",
                    "*5286275343974400*",
                    "*6442102582935552*",
                    "*6245366304342016*"
                    )
            }
            else{$return = "ERROR"}
        }

    }
    elseif ($MyLocation -eq "Troll Dig: Planning Room")
    {
        write-host "I'm in" $MyLocation
        if ($MyMode -eq $FarmT)
        {
            if ($global:MyStatus -eq $Good){$return = @("*6009402344603648*")}
            elseif ($global:MyStatus -eq $Hurt){$return = @("*6752386589655040*",
                            "*6009402344603648*"
                            )
            }
            else{$return = "ERROR"}
        }
    }
    elseif ($MyLocation -eq "Troll Dig: Guard Station")
    {
        write-host "I'm in" $MyLocation
        if ($MyMode -eq $FarmT)
        {
            if ($global:MyStatus -eq $Good){$return = @("*4631695216082944*")}
            elseif ($global:MyStatus -eq $Hurt){$return = @("*4631695216082944*",
                            "*6442102582935552*"
                            )
            }
            else{$return = "ERROR"}
        }
    }
    elseif ($MyLocation -eq "Troll Keep Entryway")
    {
        write-host "I'm in" $MyLocation
        if ($MyMode -eq $FarmT)
        {
            if ($global:MyStatus -eq $Good){$return = @("*6204342655778816*")}
            elseif ($global:MyStatus -eq $Hurt){$return = @("*5351800237457408*")}
            else{$return = "ERROR"}
        }
    }
    elseif ($MyLocation -eq "Troll Keep Hub")
    {
        write-host "I'm in" $MyLocation
        if ($MyMode -eq $FarmT)
        {
            if ($global:MyStatus -eq $Good){$return = @("*5961972819427328*")}
            elseif ($global:MyStatus -eq $Hurt){$return = @("*6204342655778816*")}
            else{$return = "ERROR"}
        }
    }
    elseif ($MyLocation -eq "Troll Keep Smithy")
    {
        write-host "I'm in" $MyLocation
        if ($MyMode -eq $FarmT)
        {
            if ($global:MyStatus -eq $Good){$return = @("*5961972819427328*")}
            elseif ($global:MyStatus -eq $Hurt){$return = @("*5961972819427328*")}
            else{$return = "ERROR"}
        }
    }

    elseif ($MyLocation -like "*Camp:*")
    {
        write-host "I'm inside a campsite!"
        if ($MyMode -eq $FarmT -or $MyMode -eq $Thorn -or $MyMode -eq $POP)
        {
            
            if ($global:MyStatus -eq $Good) {$return = "Leave camp"}
            elseif ($global:MyStatus -eq $Hurt){$return = "Rest"}
            ##add logic here to view campsite viability
            else {$return = "ERROR"}
        }
    }
    elseif ($MyLocation -like "*Combat site:*")
    {
        write-host "I'm inside a combat site!"
        if ($MyMode -eq $FarmT -or $MyMode -eq $Thorn)
        {
            
            ##evaluate enemy
            $EnemyState = EvaluateEnemy
            ping localhost -n 2 | Out-Null
            if ($EnemyState -eq "Alive")
            {
                write-host "There is an Enemy on Screen, getting new destination (command)."
                write-host "Workable states (self), Good: $good Hurt: $hurt"
                write-host "My state: $global:MyStatus"
                if ($global:MyStatus -eq $Good) {$return = "Attack"} #partial text, need eval
                elseif ($global:MyStatus -eq $Hurt){$return = "Attack"} 
                #add logic for third status - Try to run away
                ##add logic here to deal with which weapon to use
                else {$return = "ERROR"}
            }
            elseif ($EnemyState -eq "Dead")
            {
                write-host "Looting site..."
                ###look for loot... then leave
                LootEnemyItems
                #$FoundGold = LootEnemyGold
                #write-host "What I found: "$FoundGold
                $return = "Leave this site and forget about it"
            }
            else
            {
                write-host "Unable to determine enemy status. ERROR"
                write-host "Presented enemy state:" $EnemyState
                $return = "ERROR"
            }
        }
        if ($MyMode -eq $POP)
        {
            ##evaluate enemy
            $EnemyState = EvaluateEnemy
            if ($EnemyState -eq "Alive")
            {
                write-host "There is an Enemy on Screen, getting information."
                $enemyName = getEnemyName
                if ($enemyName -like "*Protector*" -or $MyLocation -like "*Protector*") 
                {
                    ##Alert Admin!####
                    write-host "Found a protector!"
                    dologGeneric ("Account: "+$MyAccount+" Found Protector that needs killing!!!!!!!")
                    $return = "Standby"
                }
                elseif ($global:MyStatus -eq $Good) {$return = "Try to run away"} #partial text, need eval
                elseif ($global:MyStatus -eq $Hurt){$return = "Try to run away"} 
                #add logic for third status - Try to run away
                ##add logic here to deal with which weapon to use
                else {$return = "ERROR"}
            }
            elseif ($EnemyState -eq "Dead")
            {
                write-host "Looting site..."
                ###look for loot... then leave
                LootEnemyItems
                #$FoundGold = LootEnemyGold
                #write-host "What I found: "$FoundGold
                $return = "Leave this site and forget about it"
            }
            else
            {
                write-host "Unable to determine enemy status. ERROR"
                $return = "ERROR"
            }
        }
    }
    ### Need below for areas inside dungeons
    $EnemyState = EvaluateEnemy
    if ($EnemyState -eq "Alive" -and $MyMode -eq $Thorn -or $EnemyState -eq "Alive" -and $MyMode -eq $FarmT)
    {
        write-host "Enemy State from Special Thorn or FarmT mode is: $EnemyState"
        write-host "There is an Enemy on Screen outside of expected battlearea, getting new destination (command)."
        if ($MyMode -eq $FarmT -or $MyMode -eq $Thorn)
        {
            if ($global:MyStatus -eq $Good) {$return = "Attack"}
            elseif ($global:MyStatus -eq $Hurt){$return = "Attack"}
            #add logic for third status - Try to run away
            ##add logic here to deal with which weapon to use
            else {$return = "ERROR"}
        }
        ##add logic for other modes
    }
    <#
    elseif ($EnemyState -eq "Dead")
    {
        ###don't need to do anything?
    }

    else {$return = "ERROR"}
    #>
    write-host "Returned from EvaluateAction: $return"
    write-host "Exit EvaluateAction."
    return $return
}
