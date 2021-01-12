<?php

require_once('api/Fivecms.php');
$fivecms = new Fivecms();

/* 
* Обновление курса валют по расписанию 
* #!/bin/bash 
* wget --output-document=/dev/null http://site.ru/update_currency.php 2>&1
*/
class ExchangeRatesCBRF
{
	var $rates;
	function __construct($date = null)
	{
		$client = new SoapClient("http://www.cbr.ru/DailyInfoWebServ/DailyInfo.asmx?WSDL"); 
		if (!isset($date)) $date = date("Y-m-d"); 
		$curs = $client->GetCursOnDate(array("On_date" => $date));
		$this->rates = new SimpleXMLElement($curs->GetCursOnDateResult->any);
	}

	function GetRate ($code)
	{
	//Этот метод получает в качестве параметра цифровой или буквенный код валюты и возвращает ее курс
		$code1 = (int)$code;
		if ($code1!=0) 
		{
			$result = $this->rates->xpath('ValuteData/ValuteCursOnDate/Vcode[.='.$code.']/parent::*');
		}
		else
		{
			$result = $this->rates->xpath('ValuteData/ValuteCursOnDate/VchCode[.="'.$code.'"]/parent::*');
		}
		if (!$result)
		{
			return false; 
		}
		else 
		{
			$vc = (float)$result[0]->Vcurs;
			$vn = (int)$result[0]->Vnom;
			return ($vc/$vn);
		}

	}
}

$rates = new ExchangeRatesCBRF();
$currencies = $fivecms->money->get_currencies();
$currency = $fivecms->money->get_currency();

foreach($currencies as $cu) {
	if($cu->id != $currency->id) {
		$value = $rates->GetRate($cu->code);
		// echo $cu->code.' = '.$value;
		// Обновляем валюту, если курс поменялся.
		if($cu->rate_to != $value) {
			$fivecms->money->update_currency($cu->id, array('rate_to'=>$value));			
		}
	}	
}

?>
