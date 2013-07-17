<?php

$domain1 = 'jodd.org';
$to = 'bug@jodd.org';
$subject = '[jodd] Bug report.';
$date = date ("l, F jS, Y");
$time = date ("h:i A");
$intro = "Submitted on $date at $time.\n\n";
$redirect = "/bugs-ok.html";
$back = "Please use back button and try again.";
$answer = 11;

// check referer
$referrer = strtolower($_SERVER["HTTP_REFERER"]);
$pos1 = strpos($referrer, $domain1);
if ($pos1 === false) {
	die("Not called from a valid domain.");
}

// generic data reader
$msg = "";
foreach ($_POST as $key => $string) {
	$value = stripslashes($string);
	if ($key == name) {
		$name = $value;
	} elseif ($key == check) {
		$check = $value;
	} elseif ($key == email) {
		$email = $value;
		$headers = "From: " . $name . " <" . $email. ">\n";
		$headers .= "Reply-To: <" . $email . ">\n";
		$headers .= "Return-Path: <" . $email . ">\n";
		$headers .= "Envelope-from: <" . $email . ">\n";
		$headers .= "Content-Type: text/plain; charset=UTF-8\n";
		$headers .= "MIME-Version: 1.0\n";
	} else {
		$msg .= ucfirst ($key) ." : ". $value . "\n"; 
	}
}

// check
if ((empty($check)) || (($check != $answer))) {
	die("Non-human detected! Or at least, someone with bad math skills;)");
}

// check existance
if ((empty($name)) || (empty($msg)) || (empty($email))) {
	die('Error! You didn\'t fill all the required fields (name, e-mail and message). $back');
}

// check email
if (!eregi("^[[:alnum:]][a-z0-9_.-]*@[a-z0-9.-]+\.[a-z]{2,4}$", $email)) { 
	die("$email - This is not a reasonable email address. $back");
}

// finally, email and redirect
mail($to, $subject, $intro . $msg, $headers);
header("Location: $redirect");
?>