<?php

// accdbtomysql.php
// this is a partial rewrite of convert.php
// using arrays and prepared statements

/* activate reporting */
mysqli_report(MYSQLI_REPORT_ALL);

// Connect to remote database - tunnel should have been set up already
echo "Connecting to database...";
$db = new mysqli("127.0.0.1", $_SERVER["DBUSER"], $_SERVER["DBPASS"], $_SERVER["DBNAME"]);

if (mysqli_connect_errno()) {
    printf("Connect failed: %s\n", mysqli_connect_error());
    exit();
}
echo "Connected.";
// reused variables
$members = array();
$airfields = array();
$fix_table = array( "Blackburn Brian" => "Blackburn Bryan",
		"R. Brierley" => "Brierley Russell",
		"carter rod" => "Carter Rod",
		"Davis, Martin John" => "Davis Martin",
		"Greig Darryl John" => "Greig Darryl",
		"Gnaegi Jorg" => "Gnaegi Joerg",
		"Hanbury R" => "Hanbury Rob",
		"R Hanbury" => "Hanbury Rob",
		"russell ian" => "Russell Ian",
		"Lockyer Lawrence" => "Lockyear Lawrence",
		"MacNeal Dennis" => "Macneall Dennis",
		"McNeal Dennis" => "Macneall Dennis",
		"McNeil Dennis" => "Macneall Dennis",
		"Mclnnes Roy" => "McInnes Roy",
		"saunders" => "Saunders Kevin",
		"Kevin Saunders" => "Saunders Kevin",
		"smoothy bob" => "Smoothy Bob",
		"Thurkle Diane" => "Thurkle Dianne",
		"kamp Peter" => "Kamp Peter",
		"Spicer Shelly" => "Spicer Shelley",
		"galloway" => "Galloway Charles",
		"tif" => "TIF",
		"Tif" => "TIF",
		"tit" => "TIF",
		"rti" => "TIF",
		"visitor" => "Visitor",
		"VISITOR" => "Visitor",
		"wis`" => "Visitor",
		"Sutherland Andrrew" => "Sutherland Andrew" );

// Members table
echo "Loading table members...\n";
$db->query("DELETE FROM members");

$handle = popen("mdb-export -D '%Y-%m-%d %H:%M:%S' BSSDATA.accdb 'Members'", "r");
$columns = fgetcsv($handle);
// for stats
$inrows["members"]=0;
$outrows["members"]=0;
// prepare SQL statement
$stmt = $db->prepare("INSERT INTO members (member_id,first_name,surname,initials,member_type,street_address,suburb,post_code,phone_number,fax_number,home_number,mobile_number,email_address,towpilot) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
$stmt->bind_param('sssssssssssssi',$memberid,
    $memfirstname,
    $memsurname,
    $meminit,
    $memtype,
    $memaddress,
    $memsuburb,
    $mempcode,
    $memphone,
    $memfax,
    $memhome,
    $memmob,
    $mememail,
    $memtowpilot
);
// loop through input rows
while ($values = fgetcsv($handle)) {
    $result = array_combine($columns, $values);
    $member_code = preg_replace('/\s\s+/', ' ', $result["Member Code"]); // consolidate multiple spaces
    $member_code = preg_replace('/\s+$/', '', $member_code); // trim trailing whitespace
    if (isset($fix_table[$member_code])) { $member_code = $fix_table[$member_code]; };
    $members["$member_code"] = $result["MemberID"];
    $inrows["members"]++;
    $memberid = $result["MemberID"];
    $memfirstname = $db->real_escape_string($result["First name"]);
    $memsurname = $db->real_escape_string($result["Surname"]);
    $meminit = $result["Initials"];
    $memtype = $result["Member type"];
    $memaddress = $db->real_escape_string($result["Street Address"]);
    $memsuburb = $db->real_escape_string($result["Suburb"]);
    $mempcode = $result["Post code"];
    $memphone = $result["Phone number"];
    $memfax = $result["Fax number"];
    $memhome = $result["Home number"];
    $memmob = $result["MobilePhone"];
    $mememail = $db->real_escape_string($result["email"]);
    $memtowpilot = $result["TowPilot"];

    if($stmt->execute()){
        $outrows["members"]++;
        //print($outrows["members"]."\r");
    } else {
        print("\nERROR: ".$db->error.">>".print_r($result)."\n");
        exit;
    }
}
pclose($handle);
$stmt->close();
echo "Members table done. IN=".$inrows["members"]." OUT=".$outrows["members"]."\n";

// Membership types table
echo "Loading table membership_types...\n";
$db->query("DELETE FROM membership_types");

$handle = popen("mdb-export -D '%Y-%m-%d %H:%M:%S' BSSDATA.accdb 'Membership types'", "r");
$inrows["membership_types"]=0;
$outrows["membership_types"]=0;
$columns = fgetcsv($handle);

$stmt = $db->prepare("INSERT INTO membership_types (member_type,explanation,bss_fee,gfa,caravanfee,airconfee) VALUES (?,?,?,?,?,?)");
$stmt->bind_param('ssssss',$mt_member_type,
                                  $mt_explanation,
                                  $mt_bss_fee,
                                  $mt_gfa,
                                  $mt_caravanfee,
                                  $mt_airconfee
);

while ($values = fgetcsv($handle)) {
    $result = array_combine($columns, $values);
    $mt_member_type=$result['Member Type'];
    $mt_explanation=$result['Explanation'];
    $mt_bss_fee=$result['BSS_Fee'];
    $mt_gfa=$result['GFA'];
    $mt_caravanfee=$result['CaravanFee'];
    $mt_airconfee=$result['AirConFee'];

    $inrows["membership_types"]++;
    if($stmt->execute()){
        $outrows["membership_types"]++;
        print($outrows["membership_types"]."\r");
    } else {
        print("\nERROR: ".$db->error.">>".print_r($result)."\n");
    }
}
pclose($handle);
echo "Membership types table done. IN=".$inrows["membership_types"]." OUT=".$outrows["membership_types"]."\n";

// Flight log table
echo "Loading table flight_log...\n";
$db->query("DELETE FROM flight_log");

$handle = popen("mdb-export -D '%Y-%m-%d %H:%M:%S' BSSDATA.accdb 'Flight log'", "r");
$inrows["flight_log"]=0;
$outrows["flight_log"]=0;
$columns = fgetcsv($handle);

$stmt = $db->prepare("INSERT INTO flight_log
                      (flight_date,flight_number,glider_registration,
                       pilot_in_command,second_pilot,flight_type,
                       tug_registration,tug_pilot,
                       time_off,tug_down,glider_down,tow_height,
                       flight_cost,member_code_1,member_code_2,
                       airfield) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");
$stmt->bind_param('sissssssssssssss',$fl_flight_date,$fl_flight_number,$fl_glider_registration,
                       $fl_pilot_in_command,$fl_second_pilot,$fl_flight_type,
                       $fl_tug_registration,$fl_tug_pilot,
                       $fl_time_off,$fl_tug_down,$fl_glider_down,$fl_tow_height,
                       $fl_flight_cost,$fl_member_code_1,$fl_member_code_2,
                       $fl_airfield);

while ($values = fgetcsv($handle)) {
    $result = array_combine($columns, $values);
    // $log_type = $result['Log Type']; // discard this
    $fl_flight_date = $result['Flight Date']; // date only
    $fl_flight_number = $result['Flight Number']; // sequence number of flight in that day
    $fl_glider_registration = $result['Glider Registration']; // foreign key
    $fl_pilot_in_command = $result['Pilot in Charge']; // name of member - convert to ID
    $fl_second_pilot = $result['2nd Pilot']; // name of member - convert to ID
    $fl_flight_type = $result['Type of Flight']; // foreign key
    $fl_tug_registration = $result['Tug Registration']; // foreign key
    $fl_tug_pilot = $result['Tug Pilot']; // name of member - convert to ID
    $fl_time_off = $result['Time Off']; // time only
    $fl_tug_down = $result['Tug Down']; // time only
    $fl_glider_down = $result['Glider Down']; // time only
    $fl_tow_height = $result['Tow Height']; // may be a time in minutes
    // $retrieve_tug_time = $result['Retrieve Tug Time']; // not used?
    // $retrieve_glider_time = $result['Retrieve Glider Time']; // not used?
    // $processed = $result['Processed']; // maybe remove/relocate this information
    $fl_flight_cost = $result['Flight Cost'];
    if ($fl_flight_cost == ''){
        $fl_flight_cost = NULL; // mysql decimal column will not accept blanks
        // echo "set flight_cost to NULL";
    }
    $fl_member_code_1 = $result['Member Code 1']; // name of member - convert to ID
    $fl_member_code_2 = $result['Member Code 2']; // name of member - convert to ID
    // $peak_flag = $result['Peak Flag']; // maybe remove/relocate this information
    // $comment = $result['Comment']; // not used?
    // $distance = $result['Distance']; // only one flight with this set!
    $fl_airfield = $result['Airfield']; // name of airfield - convert to airfield ID?

    if (!$fl_flight_number) {
        // echo "Empty flight number on $fl_flight_date\n";
	continue;
    }
    $fl_pilot_in_command = lookup_member_id($fl_pilot_in_command,"P1");
    //if ($pilot_in_command == "NULL") { echo("Unknown P1 for flight $flight_number on $flight_date.\n"); }
    $fl_second_pilot = lookup_member_id($fl_second_pilot,"P2");
    $fl_tug_pilot = lookup_member_id($fl_tug_pilot,"Tugpilot");
    $fl_member_code_1 = $fl_pilot_in_command;
    $fl_member_code_2 = $fl_second_pilot;


    $inrows["flight_log"]++;
    if($stmt->execute()){
        $outrows["flight_log"]++;
        print($outrows["flight_log"]."\r");
    } else {
        print("\nERROR: ".$db->error.">>".print_r($result)."\n");
    }
}
pclose($handle);
echo "Flight log table done. IN=".$inrows["flight_log"]." OUT=".$outrows["flight_log"]."\n";

// Member transactions table
echo "Loading table member_transactions...\n";
$db->query("DELETE FROM member_transactions");

$handle = popen("mdb-export -D '%Y-%m-%d %H:%M:%S' BSSDATA.accdb 'Member transactions'", "r");
$columns = fgetcsv($handle);
$inrows["member_transactions"]=0;
$outrows["member_transactions"]=0;

$stmt = $db->prepare("INSERT INTO member_transactions
                      (member_id,date,type,
                       sequence_number,transaction,ref_no,
                       origin,amount,comment) VALUES (?,?,?,?,?,?,?,?,?)");
$stmt->bind_param('issisisds',$member_id,$date,$type,
                       $sequence_number,$transaction,$ref_no,
                       $origin,$amount,$comment);

while ($values = fgetcsv($handle)) {
    $result = array_combine($columns, $values);
    if ($result['Amount'] == ''){
        $result['Amount'] = NULL; // mysql decimal column will not accept blanks
        // echo "set amount to NULL\n";
    }
    $member_id = lookup_member_id($result['Member Code'],"Transaction");
    $date = $result['Date'];
    $type = $result['Type'];
    $sequence_number = $result['Sequence Number'];
    $transaction = $result['Transaction'];
    $ref_no = $result['Ref No'];
    $origin = $result['Origin'];
    $amount = $result['Amount'];
    $comment = $db->real_escape_string($result['Comment']);

    $inrows["member_transactions"]++;
    try {
        $stmt->execute();
        $outrows["member_transactions"]++;
        //print($outrows["member_transactions"]."\r");
    } catch (mysqli_sql_exception $e) {
        echo $e->__toString();
        print("\nERROR: ".$db->error.">>".print_r($result)."\n");
    }
    /* if($stmt->execute()){
        $outrows["member_transactions"]++;
        //print($outrows["member_transactions"]."\r");
    } else {
        print("\nERROR: ".$db->error.">>".print_r($result)."\n");
    } */
}
pclose($handle);
echo "Member transactions table done. IN=".$inrows["member_transactions"]." OUT=".$outrows["member_transactions"]."\n";

/* Gliders table */
echo "Loading table gliders...";
$db->query("DELETE FROM gliders");

$handle = popen("mdb-export -D '%Y-%m-%d %H:%M:%S' BSSDATA.accdb 'Glider List'", "r");
$columns = fgetcsv($handle);
$inrows["gliders"]=0;
$outrows["gliders"]=0;

$stmt = $db->prepare("INSERT INTO gliders
                      (registration,model,seats,
                       club_aircraft) VALUES (?,?,?,?)");
$stmt->bind_param('ssii',$registration,$model,$seats,$club_aircraft);

while ($values = fgetcsv($handle)) {
    $result = array_combine($columns, $values);
    $registration = $result['Glider registration'];
    $model = $result['Model'];
    $seats = $result['Number of seats'];
    $club_aircraft = $result['Club aircraft'];

    $inrows["gliders"]++;
    if($stmt->execute()){
        $outrows["gliders"]++;
        print($outrows["gliders"]."\r");
    } else {
        print("\nERROR: ".$db->error.">>".print_r($result)."\n");
    }
}
pclose($handle);
echo "Gliders table done. IN=".$inrows["gliders"]." OUT=".$outrows["gliders"]."\n";


/* Tugs table */
echo "Loading table tugs...";
$db->query("DELETE FROM tugs");

$handle = popen("mdb-export -D '%Y-%m-%d %H:%M:%S' BSSDATA.accdb 'Tug List'", "r");
$columns = fgetcsv($handle);
$inrows["tugs"]=0;
$outrows["tugs"]=0;
$stmt = $db->prepare("INSERT INTO tugs
                      (registration,model,rate) VALUES (?,?,?)");
$stmt->bind_param('ssd',$registration,$model,$rate);

while ($values = fgetcsv($handle)) {
    $result = array_combine($columns, $values);
    $registration = $result['Tug reg'];
    $model = $result['Type'];
    $rate = $result['Charge'];

    $inrows["tugs"]++;
    if($stmt->execute()){
        $outrows["tugs"]++;
        print($outrows["tugs"]."\r");
    } else {
        print("\nERROR: ".$db->error.">>".print_r($result)."\n");
    }
}
pclose($handle);
echo "Tugs table done. IN=".$inrows["tugs"]." OUT=".$outrows["tugs"]."\n";

$db->close();

function lookup_member_id($member_code,$COL) {
    if (empty($member_code)) { return NULL; }

    global $members, $fix_table;

    $member_code = preg_replace('/\s\s+/', ' ', $member_code); // strip extra whitespace
    if (isset($fix_table["$member_code"])) { $member_code = $fix_table["$member_code"]; }
    if (isset($members[$member_code])) {
        return $members[$member_code];
    } else {
		if ($COL != "P2") {  // don't care too much if P2 is not a member
        print("WARNING: Unable to find member_id for '$member_code' for column $COL\n");
		}
	return NULL;
    }
}

?>

