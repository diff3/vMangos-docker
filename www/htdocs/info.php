<?php

// Configuration.
// MaNGOSD IP.
$realmip = "127.0.0.1";
// MaNGOSD port.
$realmport = "8085";
// MySQL IP (and port).
$ip = "127.0.0.1:3306";
// MySQL Username.
$user = "mangos";
// MySQL Password.
$pass = "mangos";
// Realm database.
$r_db = "realmd";
// Character database.
$c_db = "characters";
// Images directory.
$img_base = "images/";
// End config.

$list="";
$i=0;
    
$maps_a = Array(
	0 => 'Eastern Kingdoms',
	1 => 'Kalimdor',
	2 => 'UnderMine',
	13 => 'Test zone',
	17 => 'Kalidar',
	30 => 'Alterac Valley',
	33 => 'Shadowfang Keep',
	34 => 'The Stockade',
	35 => 'Stormwind Prison',
	36 => 'Deadmines',
	37 => 'Plains of Snow',
	43 => 'Wailing Caverns',
	44 => 'Monastery Interior',
	47 => 'Razorfen Kraul',
	48 => 'Blackfathom Deeps',
	70 => 'Uldaman',
	90 => 'Gnomeregan',
	109 => 'Sunken Temple',
	129 => 'Razorfen Downs',
	169 => 'Emerald Forest',
	189 => 'Scarlet Monastery',
	209 => 'Zul\'Farrak',
	229 => 'Blackrock Spire',
	230 => 'Blackrock Depths',
	249 => 'Onyxias Lair',
	269 => 'Caverns of Time',
	289 => 'Scholomance',
	309 => 'Zul\'Gurub',
	329 => 'Stratholme',
	349 => 'Maraudon',
	369 => 'Deeprun Tram',
	389 => 'Ragefire Chasm',
	409 => 'The Molten Core',
	429 => 'Dire Maul',
	449 => 'Alliance PVP Barracks',
	450 => 'Horde PVP Barracks',
	451 => 'Development Land',
	469 => 'Blackwing Lair',
	489 => 'Warsong Gulch',
	509 => 'Ruins of Ahn\'Qiraj',
	529 => 'Arathi Basin',
	531 => 'Temple of Ahn\'Qiraj',
	533 => 'Naxxramas',
);

$def = Array(
	'character_race' => Array(
		1 => 'Human',
		2 => 'Orc',
		3 => 'Dwarf',
		4 => 'Night&nbsp;Elf',
		5 => 'Undead',
		6 => 'Tauren',
		7 => 'Gnome',
		8 => 'Troll',
		9 => 'Goblin',
	),

	'character_class' => Array(
		1 => 'Warrior',
		2 => 'Paladin',
		3 => 'Hunter',
		4 => 'Rogue',
		5 => 'Priest',
		7 => 'Shaman',
		8 => 'Mage',
		9 => 'Warlock',
		11 => 'Druid',
	),
);

$user_chars = "#[^a-zA-Z0-9_\-]#";
$email_chars = "/^[^0-9][A-z0-9_]+([.][A-z0-9_]+)*[@][A-z0-9_]+([.][A-z0-9_]+)*[.][A-z]{2,4}$/";

$result;
$realmname;
$realmstatus = "<FONT COLOR=yellow>Unknown</FONT>";
$uptime = "N/A";
$accounts = "N/A";
$totalchars = "N/A";
$now = date("H:i:s");
######################$con = @mysql_connect($ip, $user, $pass);
$con = @mysqli_connect($ip, $user, $pass, $c_db);
        
function make_players_array(){
	global $con, $c_db, $pl_array, $maps_a;
    $i=0;



$sql = "SELECT * FROM  characters WHERE `online`='1' ORDER BY `name`";
	$qry = @mysqli_query($con, $sql );

###########################	$query = @mysql_query("SELECT * FROM " . mysql_real_escape_string($c_db) . ".characters WHERE `online`='1' ORDER BY `name`", $con);


	while($result = mysqli_fetch_assoc($qry))

######################	while($result = mysql_fetch_assoc($query))
	{
		$char_data = ($result['level']);
		$char_gender = ($result['gender']);
        if (strlen($maps_a[$result['map']])>0)
        {
            $res_pos=$maps_a[$result['map']];
        }
        else
        {
            $res_pos = "Unknown Zone";
        };

        $pl_array[$i] = Array($result['name'], $result['race'], $result['class'], $char_data, $res_pos, $char_gender);
        $i++;
	}

    return $i;
}

if (!$con) {

$result = "> Unable to connect to database: " . mysqli_connect_error();
###############	$result = "> Unable to connect to database: " . mysql_error();

}
else
{
##$con = mysqli_connect('localhost','mangos','mangos','realmd');
$con = mysqli_connect($ip, $user, $pass, $r_db);
   if(! $con ) {
      die('Could not connect: ' . mysqli_connect_error());
   }
#   echo 'Connected successfully2<br>';
$sql = "SELECT address FROM  realmlist WHERE id= 1";
	$qry = @mysqli_query($con, $sql );

#############    $qry = @mysql_query("select address from " . mysql_real_escape_string($r_db) . ".realmlist where id = 1", $con);
    if ($qry)
    {

        while ($row = mysqli_fetch_assoc($qry))
###############        while ($row = mysql_fetch_assoc($qry))

        {
            $realmip = $row['address'];
        }
    };
    unset($qry);


$sql = "SELECT name FROM  realmlist WHERE id= 1";
	$qry = @mysqli_query($con, $sql );

##################    $qry = @mysql_query("select name from " . mysql_real_escape_string($r_db) . ".realmlist where id = 1", $con);
    if ($qry)
    {

        while ($row = mysqli_fetch_assoc($qry))
########################        while ($row = mysql_fetch_assoc($qry))

        {
            $realmname = $row['name'];
        }
    };
    if (! $sock = @fsockopen($realmip, $realmport, $num, $error, 3))
    {
        $realmstatus = "<FONT COLOR=red>Offline</FONT>";
    }
    else
    { 
        $realmstatus = "<FONT COLOR=lime>Online</FONT>"; 
        fclose($sock);
    };
    unset($qry);



$sql = "SELECT * FROM  uptime uptime ORDER BY `starttime` DESC LIMIT 1";
	$qry = @mysqli_query($con, $sql );

##########################    $qry = @mysql_query("SELECT * FROM " . mysql_real_escape_string($r_db) . ".uptime ORDER BY `starttime` DESC LIMIT 1", $con);
    if ($qry)
    {

        $uptime_results = mysqli_fetch_array($qry);    
####################        $uptime_results = mysql_fetch_array($qry);    

        if ($uptime_results['uptime'] > 86400) { 
            $uptime =  round(($uptime_results['uptime'] / 24 / 60 / 60),2)." Days";
}
        elseif($uptime_results['uptime'] > 3600) { 
            $uptime =  round(($uptime_results['uptime'] / 60 / 60),2)." Hours";
}
        else
        { 
            $uptime =  round(($uptime_results['uptime'] / 60),2)." Min";
        }
    };
    unset($qry);

$sql = "SELECT Count(id) FROM  account";
	$qry = @mysqli_query($con, $sql );

###########################   $qry = @mysql_query("select Count(id) from " . mysql_real_escape_string($r_db) . ".account", $con);


    if ($qry)
    {
        while ($row = mysqli_fetch_assoc($qry))
##################################        while ($row = mysql_fetch_assoc($qry))

        {
            $accounts = $row['Count(id)'];
        }
    };
    unset($qry);

$con = @mysqli_connect($ip, $user, $pass, $c_db);
##$con = mysqli_connect('localhost','mangos','mangos','characters');

   if(! $con ) {
      die('Could not connect: ' . mysqli_connect_error());
   }
#   echo 'Connected successfully to characters 3<br>';

$sql = "SELECT Count(guid) FROM  characters";
	$qry = @mysqli_query($con, $sql );
   
##################    $qry = @mysql_query("select Count(guid) from " . mysql_real_escape_string($c_db) . ".characters", $con);
    if ($qry)
    {

        while ($row = mysqli_fetch_assoc($qry))
##################        while ($row = mysql_fetch_assoc($qry))

        {
            $totalchars = $row['Count(guid)'];
        }
    };

    $onlineplayers=make_players_array();

    if (!$sort = &$_GET['s']) $sort=0;
    if (!$flag = &$_GET['f']) $flag=0;
    if ($flag==0)	{	$flag=1; $sort_type='<'; } 
		else	{	$flag=0; $sort_type='>'; }
    $link=$_SERVER['PHP_SELF']."?f=".$flag."&s=";

    if (!empty($pl_array)) 
	{
        usort($pl_array, create_function('$a, $b', 'if ( $a['.$sort.'] == $b['.$sort.'] ) return 0; if ( $a['.$sort.'] '.$sort_type.' $b['.$sort.'] ) return -1; return 1;'));
	}

    
    while ($i < $onlineplayers)
	{
        $name=$pl_array[$i][0];
        $race=$pl_array[$i][1];
        $class=$pl_array[$i][2];
        $res_race = $def['character_race'][$race];
        $res_class = $def['character_class'][$class];
        $lvl=$pl_array[$i][3];
        $loc=$pl_array[$i][4];
        $gender=$pl_array[$i][5];
        $tmpnum = ($i + 1);
        $list.= "<tr>
        <td>$tmpnum</td>
        <td>$name</td>
        <td align=center><img alt=$res_race src='".$img_base."race/".$race."-$gender.gif' height=22 width=22></td>
        <td align=center><img alt=$res_class src='".$img_base."class/$class.gif' height=22 width=22></td>
        <td align=center>$lvl</td>
        <td>$loc</td>
        </tr>";
        $i++;
	}
};
?>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8" />
<title>Server Information - brotalnia's repack</title>
<style>
hr
{
    border:0;
    box-sizing:content-box;
    height:0;
    margin-top:10px;
    margin-bottom:10px;
    border-top:1px solid #eee;
}
.h1,h1
{
    font-family:inherit;
    font-weight:500;
    line-height:1.1;
    color:inherit;
    margin-top:20px;
    margin-bottom:10px;
    font-size:36px;
}
h2
{
    font-size:50px;
}
img
{
    border:0;
    vertical-align:middle;
}
*,:after,:before
{
    -webkit-box-sizing:border-box;
    -moz-box-sizing:border-box;
    box-sizing:border-box;
}
html
{
    font-size:10px;
    -webkit-tap-highlight-color:transparent;
}
a,body
{
    color:#fff;
}
body,html
{
    overflow:visible;
    font-family:Proxima Nova,sans-serif;
}
table, th, td {
    border: 1px solid black;
    border-collapse: collapse;
}
th, td {
    padding: 5px;
    text-align: left;
}
body {
    margin:0;
    height: 100%;
    width: 99%;
    background-color:#000000;
}
#wrapper {
     position: relative;
     height: 100%;
     width: 100%;
   }
#header {
    -webkit-box-sizing:content-box;
    -moz-box-sizing:content-box;
    box-sizing:content-box;
    background-color:rgb(3, 34, 76);
    color:white;
    text-align:center;
    padding:5px;
}
#nav {
    -webkit-box-sizing:content-box;
    -moz-box-sizing:content-box;
    box-sizing:content-box;
    position: absolute;
    line-height:30px;
    background-color: #033553;
    height: calc(100vh - 38px);
    height: -o-calc(100vh - 38px); /* opera */
    height: -webkit-calc(100vh - 38px); /* google, safari */
    height: -moz-calc(100vh - 38px); /* firefox */
    width:150px;
    float:left;
    padding:5px;
    color:rgb(255, 165, 0);
    font-weight: bold;
    font-size: 15px;
}
#nav a:link { color: rgb(255, 165, 0); }
#nav a:visited { color: rgb(255, 165, 0); }
#nav a:hover { color: #7FFF00; }
#nav a:active { color: rgb(255, 165, 0); }
#section {
    -webkit-box-sizing:content-box;
    -moz-box-sizing:content-box;
    box-sizing:content-box;
    background-image: url('images/graves.jpg');
    width: calc(100% - 175px);
    width: -o-calc(100% - 175px); /* opera */
    width: -webkit-calc(100% - 175px); /* google, safari */
    width: -moz-calc(100% - 175px); /* firefox */
    height: calc(100vh - 30px);
    height: -o-calc(100vh - 30px); /* opera */
    height: -webkit-calc(100vh - 30px); /* google, safari */
    height: -moz-calc(100vh - 30px); /* firefox */
    float:left;
    padding-left:175px;		 
}
#footer {
    background-color:rgb(3, 34, 76);
    color:white;
    clear:both;
    text-align:center;
    padding:5px;
    font-size: 16px;
}
#list
{
    -webkit-box-sizing:content-box;
    -moz-box-sizing:content-box;
    box-sizing:content-box;
    background:rgba(16,16,16,.9)!important;
    background-blend-mode:multiply;
    max-width:1170px;
    width:80%;
}
#info
{
    font-size: 20px;
}
</style>
</head>
<body>

<div id="header">
<h1>Vanilla Repack</h1>
</div>
<div id="wrapper">
<div id="nav">
<a href="http://www.youtube.com/brotalnia" style="text-decoration:none"><img src="images/youtube.png" alt="[1]" width="16" height="16"> My Channel</a><br>
<hr>
<a href="index.php" style="text-decoration:none"><img src="images/mangos.png" alt="[2]" width="16" height="16"> Registration</a><br>
<a href="info.php" style="text-decoration:none"><img src="images/lfg.png" alt="[3]" width="16" height="16"> Information</a><br>
<hr>
<div align="center">
<a href="http://www.ownedcore.com/forums/world-of-warcraft/world-of-warcraft-emulator-servers/wow-emu-general-releases/613280-elysium-core-1-12-repack-including-mmaps-optional-vendors.html" style="text-decoration:none"><img src="images/ocbanner.png" alt="OwnedCore" width="88" height="31"></a><br>
</div>
</div>
<div id="section">
<h2>Realm: <?php if(isset($realmname)){ echo $realmname; } else { echo "Lightbringer";} ?></h2>
<p id="info">Status: <?php echo $realmstatus; ?>
<br>
Server Time: <?php echo $now; ?>
<br>
Server Uptime: <?php echo $uptime; ?>
<br><br>
Total Accounts: <?php echo $accounts; ?>
<br>
Total Characters: <?php echo $totalchars; ?>
</p>
<br><br><br>
<div id="list">
  <center>Players Online: <?php if(isset($onlineplayers)){ echo $onlineplayers; } else { echo "0";} ?></center><br>
	<table width="100%" border="0" style="color:Azure">
  	<tr>
    	<td align="left" width=50></td>
        <td align="left" width=60>Name</td>
    	<td align="center" width=40>Race</td>
    	<td align="center" width=40>Class</td>
    	<td align="center" width=40>Level</td>
    	<td align="left" width=100>Zone</td>
  	</tr>
		<?php echo $list ?>
	</table>
</div>
</div>
<div id="footer">
Subscribe to my channel on <a href="http://www.youtube.com/brotalnia" style="color:#FF0000">Youtube</a>
</div>
</div>
</body>
</html>