<?php 

// adapted from: http://stackoverflow.com/questions/2649579/downloading-attachments-to-directory-with-imap-in-php-randomly-works
// works with a few unnecessary notice messages by dropping attachment in CWD

// Report all errors except E_NOTICE
error_reporting(E_ALL & ~E_NOTICE);

/* connect to mail */
$hostname = "{".$_SERVER["MAILHOST"].":993/imap/ssl/novalidate-cert}INBOX";
$username = $_SERVER["MAILUSER"];
$password = $_SERVER["MAILPASS"];

/* try to connect */
$inbox = imap_open($hostname,$username,$password) or die('Cannot connect to mail: ' . imap_last_error());

/* grab emails */
$emails = imap_search($inbox, 'UNSEEN');

/* if emails are returned, cycle through each... */
if($emails) {
  /* begin output var */
  $output = '';
  /* put the newest emails on top */
  rsort($emails);

  foreach($emails as $email_number) {

    /* get information specific to this email */
    $overview = imap_fetch_overview($inbox,$email_number,0);
    $message = imap_fetchbody($inbox,$email_number,2);
    $structure = imap_fetchstructure($inbox,$email_number);
    print_r($overview);
    $attachments = array();
    if(isset($structure->parts) && count($structure->parts)) {
      for($i = 0; $i < count($structure->parts); $i++) {
        $attachments[$i] = array(
        'is_attachment' => false,
        'filename' => '',
        'name' => '',
        'attachment' => '');
        if($structure->parts[$i]->ifdparameters) {
          foreach($structure->parts[$i]->dparameters as $object) {
            if(strtolower($object->attribute) == 'filename') {
              $attachments[$i]['is_attachment'] = true;
              $attachments[$i]['filename'] = $object->value;
            }
          }
        }

        if($structure->parts[$i]->ifparameters) {
          foreach($structure->parts[$i]->parameters as $object) {
            if(strtolower($object->attribute) == 'name') {
              $attachments[$i]['is_attachment'] = true;
              $attachments[$i]['name'] = $object->value;
            }
          }
        }

        if($attachments[$i]['is_attachment']) {
          $attachments[$i]['attachment'] = imap_fetchbody($inbox, $email_number, $i+1);
          if($structure->parts[$i]->encoding == 3) { // 3 = BASE64
            $attachments[$i]['attachment'] = base64_decode($attachments[$i]['attachment']);
          }
          elseif($structure->parts[$i]->encoding == 4) { // 4 = QUOTED-PRINTABLE
            $attachments[$i]['attachment'] = quoted_printable_decode($attachments[$i]['attachment']);
          }
        }             
       } // for($i = 0; $i < count($structure->parts); $i++)
       } // if(isset($structure->parts) && count($structure->parts))

    if(count($attachments)!=0){
      foreach($attachments as $at){
        if($at[is_attachment]==1){
          print("Writing attachment ".$at[filename]."\n");
          file_put_contents($at[filename], $at[attachment]);
        }
      }
    }
  // now delete msg from inbox
  imap_delete($inbox,$email_number);
  }
} else {
  print("There are no emails to process\n"); 
}
// remove deleted
imap_expunge($inbox);
// close the connection
imap_close($inbox);

?>
