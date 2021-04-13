<?php
ini_set("display_errors", 1);

$name = strip_tags(stripslashes($_POST['name']));
$inn_plat = strip_tags(stripslashes($_POST['inn_plat']));
$kpp_plat = strip_tags(stripslashes($_POST['kpp_plat']));
$address_plat = strip_tags(stripslashes($_POST['address_plat']));
$phone_plat = strip_tags(stripslashes($_POST['phone_plat']));
$purchases = strip_tags(stripslashes($_POST['purchases_s']));
$purchases = unserialize($purchases);

function textfield($pdf, $x, $y, $width, $text, $undertext)
{
	$pdf->SetXY($x,$y);
	$pdf->SetLineStyle(array('dash'=>0));
	$pdf->SetFontSize(9);
	$pdf->Write(5, $text);
	$pdf->Line($x+1, $y+5, $x+$width, $y+5);
	$pdf->SetXY($x, $y+4);
	$pdf->SetFontSize(7);
	$pdf->Write(5,"$undertext");
}

/**
 * Возвращает сумму прописью
 * @author runcore
 * @uses morph(...)
 */
function num2str($num) {
    $nul='ноль';
    $ten=array(
        array('','один','два','три','четыре','пять','шесть','семь', 'восемь','девять'),
        array('','одна','две','три','четыре','пять','шесть','семь', 'восемь','девять'),
    );
    $a20=array('десять','одиннадцать','двенадцать','тринадцать','четырнадцать' ,'пятнадцать','шестнадцать','семнадцать','восемнадцать','девятнадцать');
    $tens=array(2=>'двадцать','тридцать','сорок','пятьдесят','шестьдесят','семьдесят' ,'восемьдесят','девяносто');
    $hundred=array('','сто','двести','триста','четыреста','пятьсот','шестьсот', 'семьсот','восемьсот','девятьсот');
    $unit=array( // Units
        array('копейка' ,'копейки' ,'копеек',	 1),
        array('рубль'   ,'рубля'   ,'рублей'    ,0),
        array('тысяча'  ,'тысячи'  ,'тысяч'     ,1),
        array('миллион' ,'миллиона','миллионов' ,0),
        array('миллиард','милиарда','миллиардов',0),
    );
    //
    list($rub,$kop) = explode('.',sprintf("%015.2f", floatval($num)));
    $out = array();
    if (intval($rub)>0) {
        foreach(str_split($rub,3) as $uk=>$v) { // by 3 symbols
            if (!intval($v)) continue;
            $uk = sizeof($unit)-$uk-1; // unit key
            $gender = $unit[$uk][3];
            list($i1,$i2,$i3) = array_map('intval',str_split($v,1));
            // mega-logic
            $out[] = $hundred[$i1]; # 1xx-9xx
            if ($i2>1) $out[]= $tens[$i2].' '.$ten[$gender][$i3]; # 20-99
            else $out[]= $i2>0 ? $a20[$i3] : $ten[$gender][$i3]; # 10-19 | 1-9
            // units without rub & kop
            if ($uk>1) $out[]= morph($v,$unit[$uk][0],$unit[$uk][1],$unit[$uk][2]);
        } //foreach
    }
    else $out[] = $nul;
    $out[] = morph(intval($rub), $unit[1][0],$unit[1][1],$unit[1][2]); // rub
    $out[] = $kop.' '.morph($kop,$unit[0][0],$unit[0][1],$unit[0][2]); // kop
    return trim(preg_replace('/ {2,}/', ' ', join(' ',$out)));
}

/**
 * Склоняем словоформу
 * @ author runcore
 */
function morph($n, $f1, $f2, $f5) {
    $n = abs(intval($n)) % 100;
    if ($n>10 && $n<20) return $f5;
    $n = $n % 10;
    if ($n>1 && $n<5) return $f2;
    if ($n==1) return $f1;
    return $f5;
} 

require_once('tcpdf/tcpdf.php'); 
//create a FPDF object
$pdf=new TCPDF();

$pdf->setPDFVersion('1.6');
$pdf->SetFont('dejavusanscondensed','',8);

// params
$recipient = stripslashes($_POST['recipient']);
$inn = stripslashes($_POST['inn']);
$kpp = stripslashes($_POST['kpp']);
$account = stripslashes($_POST['account']);
$bank = stripslashes($_POST['bank']);
$bik = stripslashes($_POST['bik']);
$rukov = stripslashes($_POST['rukov']);
$sef = stripslashes($_POST['sef']);
$correspondent_account = stripslashes($_POST['correspondent_account']);
$banknote = stripslashes($_POST['banknote']);
$pence = stripslashes($_POST['pence']);
$order_id = stripslashes($_POST['order_id']);
$amount = stripslashes($_POST['amount']);
$deliver = stripslashes($_POST['delivery_price']);
$phone_seller = stripslashes($_POST['phone_seller']);
$index_seller = stripslashes($_POST['index_seller']);
$address_seller = stripslashes($_POST['address_seller']);
$vat = stripslashes($_POST['vat']);

$count = 0;

$amount_str = num2str($amount);

//purchase

$html_purchase = <<<EOD
<table width="540" border="1" cellpadding="2" cellspacing="0">
 <tr>
  <td width="20" align="center"><b>№</b></td>
  <td width="330" align="center"><b>Товары(работы, услуги)</b></td>  
  <td width="40" align="center"><b>Кол-во</b></td>
  <td width="30" align="center"><b>Ед.</b></td>
  <td width="60" align="center"><b>Цена</b></td>  
  <td width="60" align="center"><b>Сумма</b></td>
 </tr>
EOD;
$summa_zakaza = 0;
foreach($purchases as $purchase){
	if($purchase){
				$count = $count+1;				
				$html_purchase .= "<tr><td width='20' align='center'>".$count."</td>";
				$html_purchase .= "<td width='330'>".$purchase->product_name."</td>";
				$html_purchase .= "<td width='40' align='right'>".$purchase->amount."</td>";
				$html_purchase .= "<td width='30'>шт.</td>";
				$html_purchase .= "<td width='60' align='right'>".$purchase->price."</td>";				
				$html_purchase .= "<td width='60' align='right'>".$purchase->price*$purchase->amount."</td></tr>";
				$summa_zakaza = $summa_zakaza + $purchase->price*$purchase->amount;				
	}					
}
if(!empty($deliver)){		
				$count = $count+1;				
				$html_purchase .= "<tr><td width='20' align='center'>".$count."</td>";
				$html_purchase .= "<td width='330'>Доставка</td>";
				$html_purchase .= "<td width='40' align='right'>1</td>";
				$html_purchase .= "<td width='30'>шт.</td>";
				$html_purchase .= "<td width='60' align='right'>".$deliver."</td>";				
				$html_purchase .= "<td width='60' align='right'>".$deliver."</td></tr>";		
}			

$html_purchase .= "</table>";

$html_header_warning = <<<EOD
<table width="540" border="0" cellpadding="1" cellspacing="0">
<thead>
 <tr>
  <td align="center">Внимание! Оплата данного счета означает согласие с условиями поставки товара. Уведомление об оплате</td>
 </tr>
  <tr>
  <td align="center"> обязательно, в противном случае не гарантируется наличие товара на складе. Товар отпускается по факту</td>
 </tr>
  <tr>
  <td align="center">прихода денег на р/с Поставщика, самовывозом, при наличии доверенности и паспорта.</td>
 </tr>
</thead>
EOD;

$html_seller_info = <<<EOD
<table border="1" cellpadding="2" cellspacing="0" width="540">
	<tbody>
		<tr height="16">
			<td colspan="19" height="31" rowspan="2">$bank</td>
			<td colspan="5">БИК</td>
			<td colspan="13">$bik</td>
		</tr>
		<tr height="15">
			<td colspan="5" height="30" rowspan="2">Сч. №</td>
			<td colspan="13" rowspan="2">$account</td>
		</tr>
		<tr height="15">
			<td colspan="19" height="15">Банк получателя</td>
		</tr>
		<tr height="16">
			<td colspan="3" height="16">ИНН</td>
			<td colspan="7">$inn</td>
			<td colspan="2">КПП&nbsp;&nbsp;</td>
			<td colspan="7">$kpp</td>
			<td colspan="5" rowspan="4">Сч. №</td>
			<td colspan="13" rowspan="4">$correspondent_account</td>
		</tr>
		<tr height="15">
			<td colspan="19" height="25" rowspan="2">$recipient</td>
		</tr>
		<tr height="15">
		</tr>
		<tr height="15">
			<td colspan="19" height="15">Получатель</td>
		</tr>
	</tbody>
</table>
EOD;

$date_now = date('d').".".date('m').".".date('Y');
$num_order_for_pay = <<<EOD
			<div><b>Счет на оплату № $order_id от $date_now г.</b></div>
EOD;

$postavshik = <<<EOD
	<table border="0" cellpadding="0" cellspacing="0" width="540">
	<tbody>
			<tr>
				<td width="80">Поставщик:</td>
				<td width="460">$recipient, ИНН $inn, КПП $kpp, Адрес: $index_seller, $address_seller, Тел./факс: $phone_seller
				</td>
			</tr>
		</tbody>
	</table>
EOD;

$pokupatel = <<<EOD
	<table border="0" cellpadding="0" cellspacing="0" width="540">
	<tbody>
			<tr>
				<td width="80">Покупатель:</td>
				<td width="460">$name, ИНН $inn_plat, КПП $kpp_plat, Адрес: $address_plat, Тел.: $phone_plat
				</td>
			</tr>
		</tbody>
	</table>
EOD;

//set document properties
$pdf->setPrintHeader(false); 
$pdf->setPrintFooter(false);
$pdf->setPageOrientation('P');
//set font for the entire document
$pdf->SetTextColor(0,0,0);

//set up a page
$pdf->AddPage();
$pdf->SetDisplayMode('real');

$pdf->SetFontSize(8);

// Начальные координаты
$x = 10;
$y = 10;

//Таблица товара
$pdf->SetXY($x,$y);
$pdf->SetFontSize(9);
$pdf->writeHTML($html_header_warning, true, false, false, false, '');

// Продавец
$y = $pdf->GetY();
$y += 5;
$pdf->SetXY($x,$y);
$pdf->writeHTML($html_seller_info, true, false, false, false, '');

// Счет на оплату
$y = $pdf->GetY();
$y += 5;
$pdf->SetXY($x,$y);
$pdf->SetFontSize(16);
$pdf->writeHTML($num_order_for_pay, true, false, false, false, '');
$y += 4; 
textfield($pdf, $x, $y, 190, '', '');

// Продавец
$y = $pdf->GetY();
$y += 5;
$pdf->SetXY($x,$y);
$pdf->SetFontSize(10);
$pdf->writeHTML($postavshik, true, false, false, false, '');

// Покупатель
$y = $pdf->GetY();
$pdf->SetXY($x,$y);
$pdf->SetFontSize(10);
$pdf->writeHTML($pokupatel, true, false, false, false, '');

//Таблица товара
$y += 10;
$pdf->SetXY($x,$y);
$pdf->SetFontSize(9);
$pdf->writeHTML($html_purchase, true, false, false, false, '');

/* count discount */
$total_price = $amount;
if(!empty($deliver))
	$total_price -= (float)$deliver; //Скидка не применяется к доставке
	
if($total_price != $summa_zakaza){
	$discount_text = " (со скидкой)";
} else {
	$discount_text = "";
}
/* count discount@ */

$amount_vat = $amount*$vat/(100+$vat);

$koopeiki = round(($amount*100-floor($amount)*100));
if($koopeiki==0)
	$koopeiki = '00';
	
$koopeiki_vat = round(($amount_vat*100-floor($amount_vat)*100));
if($koopeiki_vat==0)
	$koopeiki_vat = '00';	

/*$koopeiki_del = round(($deliver*100-floor($deliver)*100));
if($koopeiki_del==0)
	$koopeiki_del = '00';
	
if($deliver > 0){
// Доставка
$y = $pdf->GetY();
$y += 5; 
$pdf->SetXY($x+110, $y);
$pdf->SetFont('dejavusanscondensed','B',10);
$pdf->Write(5, 'Доставка:  ');
$pdf->SetFont('dejavusanscondensed','',10);
$pdf->Write(5, floor($deliver).' '.$banknote.' '.$koopeiki_del.' '.$pence);}*/

// Сумма платежа
$y = $pdf->GetY();
$y += 5; 
$pdf->SetXY($x+110, $y);
$pdf->SetFont('dejavusanscondensed','B',10);
$pdf->Write(5, 'Итого'.$discount_text.': ');
$pdf->SetFont('dejavusanscondensed','',10);
$pdf->Write(5, floor($amount).' '.$banknote.' '.$koopeiki.' '.$pence);

//  НДС
$y += 5;
$pdf->SetXY($x+110, $y);
$pdf->SetFont('dejavusanscondensed','B',10);
if(empty($vat)){
	$pdf->Write(5, 'Без налога (НДС)  ');
	$pdf->SetFont('dejavusanscondensed','',10);
	$pdf->Write(5, ' —');
} else { 
	$pdf->Write(5, 'В том числе НДС:  ');
	$pdf->SetFont('dejavusanscondensed','',10);
	$pdf->Write(5, floor($amount_vat).' '.$banknote.' '.$koopeiki_vat.' '.$pence);
}
//  Итого
$y += 5;
$pdf->SetXY($x+110, $y);
$pdf->SetFont('dejavusanscondensed','B',10);
$pdf->Write(5, 'Всего к оплате:  ');
$pdf->SetFont('dejavusanscondensed','',10);
$pdf->Write(5, floor($amount).' '.$banknote.' '.$koopeiki.' '.$pence);
$pdf->SetFontSize(8);

//Всего наименований
$y += 15;
$pdf->SetXY($x, $y);
$pdf->SetFontSize(11);
$pdf->Write(5, 'Всего наименований ');
$pdf->Write(5, $count);
$pdf->Write(5, ', на сумму ');
$pdf->Write(5, floor($amount).' '.$banknote.' '.$koopeiki.' '.$pence);

//Сумма прописью
$y += 5;
$pdf->SetXY($x, $y);
$pdf->SetFont('dejavusanscondensed','B',10);
$pdf->Write(5, 'Сумма прописью: ');
$pdf->Write(5, $amount_str);
textfield($pdf, $x, $y, 190, '', '');

// Подпись плательщика
$y += 10;
$pdf->SetXY($x, $y);
$pdf->SetFont('dejavusanscondensed','',10);
$pdf->Write(5, 'Руководитель');
$pdf->SetXY($x+30, $y);
$pdf->SetFont('dejavusanscondensed','',10);
$pdf->Write(5, $rukov);
textfield($pdf, $x+30, $y, 50, '', '');
$pdf->SetXY($x+100, $y);
$pdf->SetFont('dejavusanscondensed','',10);
$pdf->Write(5, 'Главный бухгалтер');
$pdf->SetXY($x+140, $y);
$pdf->SetFont('dejavusanscondensed','',10);
$pdf->Write(5, $sef);
textfield($pdf, $x+140, $y, 50, '', '');

$y += 5;
$pdf->SetXY($x+60, $y);
$pdf->Image('sign.png', '', '', 30, 26, '', '', '', true, 300, '', false, false, 0, false, false, false);
$pdf->SetXY($x+160, $y);
$pdf->Image('buh.png', '', '', 30, 26, '', '', '', true, 300, '', false, false, 0, false, false, false);

$y += 15;
$pdf->SetXY($x, $y);
$pdf->Image('print.png', '', '', 50, 50, '', '', '', true, 300, '', false, false, 0, false, false, false);

//Output the document
$pdf->Output('receipt.pdf','I');
