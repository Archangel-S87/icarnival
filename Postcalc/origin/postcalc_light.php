<?php 
// Загружаем библиотеку
require_once 'postcalc_light_lib.php';
extract($arrPostcalcConfig, EXTR_PREFIX_ALL, 'postcalc_config');
// Инициализируем значения полей формы
$from   = ( isset($_GET['from']) ) ? $_GET['from'] : $postcalc_config_default_from;
$to     = ( isset($_GET['to']) ) ? $_GET['to'] : '190000';
$weight = ( isset($_GET['weight'])) ? $_GET['weight'] : 1000;
$valuation = ( isset($_GET['valuation']) ) ? $_GET['valuation']:1000;
$country   = ( isset($_GET['country']) ) ? $_GET['country'] : 'RU';
$bo        = ( isset($_GET['bo']) ) ? $_GET['bo'] : 's';
$arr_p     = ( isset($_GET['p']) ) ? $_GET['p'] : array();
$arr_sv    = ( isset($_GET['sv']) ) ? $_GET['sv'] : array();
// Выдаем заголовок с указанием на кодировку
header("Content-Type: text/html; charset=$postcalc_config_cs");
?>
<!DOCTYPE html>
<html>
    <head>
        <title>Клиент PostcalcLight</title>
        <meta charset='<?=$postcalc_config_cs?>'> 
        <style>
            #postcalc_form { width: 44em; margin-left: 2em; margin: 0 auto }
            #postcalc_form label { display: inline-block; width: 8em; }
            #postcalc_form legend { width:20em;padding:0.2em;padding-left:1em;padding-right:1em; } 
            #postcalc_loader {margin: 0 auto; top: 2em}
            #postcalc_country  { width:30em }
            #postcalc_from  { width:30em }
            #postcalc_to { width:30em }
            #postcalc_from_to { width: 32em; margin-left: 5em; }
            #postcalc_from_to TD { vertical-align: top }
            #postcalc_table { margin-left: 0em }
            #postcalc_table TD { padding:0.2em;padding-left:1em }
            #postcalc_table TH  { padding:0.5em; }
            #postcalc_wv { display: none }
            .center { text-align: center;} 
            #postcalc {align: left}
            #postcalc_output { width: 44em; margin-left: 2em; margin: 0 auto }
            @media print {
                    body { font-family: sans-serif, Arial; font-size: 10pt }
                    #postcalc_table {  background-color: grey }
                    #postcalc_table TR {  background-color: white }
                    #postcalc_form { display:none }
                    #postcalc_wv { display: block }
            }
       </style>
       <link rel='stylesheet' href='//yandex.st/jquery-ui/1.11.2/themes/<?=$postcalc_config_arrSkins[$postcalc_config_skin]?>/jquery-ui.min.css' type='text/css' media='screen' />
       <script src='//yandex.st/jquery/1.11.3/jquery.min.js'></script>
       <script src='//yandex.st/jquery-ui/1.11.2/jquery-ui.min.js'></script>

       <!--[if lt IE 8]><script>var OldIE = true;</script><![endif]-->
       <script src='postcalc_light_form_plugin.js'></script>
        <script>
        // Если возникают конфликты с другими библиотеками Javascript, использующими знак $, раскомментируйте следующую строчку
        //jQuery.noConflict();
        jQuery(document).ready(function( $ ){
            //Инициализируем форму
            $.fn.postcalc_light_form('postcalc_form');
            // Переключаем доп. панель с настройками
            $( "#toggleSettings" ).click(function() {
			  $( "#Settings" ).toggle( "slow", function() {
			  });
			});
        });
        
        
       </script> 
    </head>
    <body>
        <?php // Раскомментируйте, чтобы доступ был только по паролю $arrPostcalcConfig['pass'].
        //require 'postcalc_light_auth.php'; ?>
        <div id="postcalc" class="ui-widget">
        <form id="postcalc_form">
             <fieldset  class="ui-widget-content ui-corner-all">
        
               <legend  class="ui-widget-header ui-corner-all" >Доставка Почтой России и EMS</legend>
               <span style="display:<?= ($postcalc_config_hide_from) ? 'none' : 'block' ?>">
               <label for="from" title="Отделение связи отправителя - шестизначный индекс или местоположение EMS (название региона или центр региона)"> Откуда </label>
               <input type="text" id="from" name="from" data-autocomplete-url="postcalc_light_autocomplete.php" data-validation-error="В базе данных Клиента данное отделение связи отправителя не найдено." size="20" value="<?=$from?>"/>
               <br>
               </span>
               <label for="to" title="Отделение связи получателя - шестизначный индекс  или местоположение EMS (название региона или центр региона)"> Куда </label>
               <input type="text"  id="to" name="to" data-autocomplete-url="postcalc_light_autocomplete.php" data-validation-error="В базе данных Клиента данное отделение связи получателя не найдено." size="20" value="<?=$to?>"/>
               <br>
               <label for="weight" title="Вес отправления в граммах - от 1 до 100000"> Вес, г </label>
               <input type="text" data-range="1,100000" data-validation-error="Вес отправления в граммах - от 1 до 100000" id="weight" name="weight" size="6" value="<?=$weight?>"/>
               <br>
                <label for="valuation" title="Оценка товарного вложения в рублях - от 0 до 100000">Ценность, руб. </label>
                <input type="text" data-range="0,100000" data-validation-error="Оценка товарного вложения в рублях - от 0 до 100000" id="valuation" name="valuation" size="6" value="<?=$valuation?>"/>
                <br>
                <span style="display:block">
                <label for="country" title="Страна назначения">Страна</label>
                <select id="country" name="country" size="1">
                    <?php  
	                    $arrCountries = file('postcalc_light_countries.txt');
	                    $arrPostcalcCountries = array();
	                    foreach ( $arrCountries as $line_country ) {
							list($CountryCode, $CountryName) = explode("\t", $line_country);
							$arrPostcalcCountries[$CountryCode] = trim($CountryName);
	                        echo "<option value='$CountryCode'";
                            if ( $CountryCode == $country ) echo " selected";
                            echo ">$CountryName</option>\n";
						}
                    ?>
                </select><br>
                </span>
               <div id="toggleSettings" style="margin-left: 8em;" title="Панель дополнительных настроек: отправления, опции и услуги, коробка" class="ui-button">Дополнительные настройки >></div> 
               <div style="display:none" id="Settings">
              <fieldset style="background-color: #E8E8E8" >
               <legend>Дополнительно:</legend>
	                <label for="parcels" title="Виды отправлений. Не более 5 для внутренних и 5 для международных отправлений."  style="vertical-align:top">Отправления</label>
	                <select id="parcels" name="p[]" size="10" multiple>
	                    <?php asort($postcalc_config_arrParcels);
	                          foreach ( $postcalc_config_arrParcels as $parcel_code => $parcel_key ) {
	                            echo "<option value='$parcel_code'";
	                            if ( in_array($parcel_code, $arr_p) ) echo " selected";
	                            echo ">$parcel_key</option>\n";
						      }
	                    ?>
	                </select><br>
	                <label for="services" title="Можно выбрать несколько опций (Ctrl+click). Не все виды отправлений имеют все опции."  style="vertical-align:top">Опции и доп. услуги</label>
	                <select id="services" name="sv[]" size="5" multiple>
	                    <?php foreach ( $postcalc_config_arrServices as $service_code => $service_name ) {						
	                            echo "<option value='$service_code'";
	                            if ( in_array($service_code, $arr_sv) ) echo " selected";
	                            echo ">$service_name</option>\n";
						      }
	                    ?>
	                </select><br>
	                <label for="box" title="Коробка Почты России (пока только для отправления ЕКОМ)."  style="vertical-align:top">Коробка (ЕКОМ)</label>
	                <select id="box" name="bo" size="5" multiple>
	                    <?php foreach ( $postcalc_config_arrBox as $box_code => $box_name ) {						
	                            echo "<option value='$box_code'";
	                            if ( $box_code == $bo ) echo " selected";
	                            echo ">$box_name</option>\n";
						      }
	                    ?>
	                </select><br>	
                </fieldset>
                </div>
                
            </fieldset>
            <input type="submit" value="Рассчитать!" class="ui-button" onclick="javascript:ldr=document.getElementById('postcalc_loader');ldr.style.display='block';" id='postcalc_form_submit' style="margin-left:11em">
        </form>
       <div id='postcalc_loader' style='display:none; text-align: center'><img src='ajax-loader.gif' alt='Индикатор загрузки'></div> 
       <div id='postcalc_output'>
<?php
if ( isset($_GET['from']) ) {
    
// Обращаемся к функции getPostcalc
$arrResponse = postcalc_request($from, $to, $weight, $valuation, $country, $bo, $arr_p, $arr_sv);

// Если вернулась строка - это сообщение об ошибке.
if ( !is_array($arrResponse) ) {
    echo "<span class='ui-state-error'>Произошла ошибка:</span><br> $arrResponse";
    if ( error_get_last() ){
        $arrError = error_get_last();
        echo "<br><span class='ui-state-error'>Ошибка PHP, строка $arrError[line] в файле $arrError[file]:</span><br> $arrError[message]";
    };
} else {
// Вернулся массив, Status=='OK'. 
// Откуда и Куда
echo "
    <div id='postcalc_from_to' class='ui-widget'>
 
        <b>Откуда:</b><br>
    {$arrResponse['Откуда']['Индекс']}, {$arrResponse['Откуда']['Название']}
            <br> {$arrResponse['Откуда']['Адрес']} 
";
if ($country == 'RU') {
echo " <br> 
    <b>Куда:</b><br>
    {$arrResponse['Куда']['Индекс']}, {$arrResponse['Куда']['Название']}
            <br>{$arrResponse['Куда']['Адрес']} 
";
} else {
echo "<br>
       <b>Куда:</b><br>
       Международная доставка: {$arrPostcalcCountries[$country]}
 
";
}
echo "<span id='postcalc_wv'><b>Вес:</b> $weight г.<br>\n<b>Оценка:</b> $valuation руб.</span>";
if ( isset($arrResponse['Ограничения']['Куда']) ) {
	echo "
	<hr>
	<br><span class='ui-state-error'>На доставку в ".$arrResponse['Куда']['Индекс']." действуют ограничения:</span><br>
	<table>
	<tr><td><b>Тип: </b></td><td>".$arrResponse['Ограничения']['Куда']['Тип']."</td></tr>
	<tr><td><b>Действие: </b></td><td>".$arrResponse['Ограничения']['Куда']['Действует']."</td></tr>";
	if ( isset($arrResponse['Ограничения']['Куда']['АвиаДоставка']) )
	     echo "<tr><td><b>Период авиадоставки: </b></td><td>". $arrResponse['Ограничения']['Куда']['АвиаДоставка']."</td></tr>";
	if ( isset($arrResponse['Ограничения']['Куда']['ЗапретДоставки']) )
	     echo "<tr><td><b>Полный запрет доставки: </b></td><td>". $arrResponse['Ограничения']['Куда']['ЗапретДоставки']."</td></tr>";
	echo "
	</table>
	<hr>
";
	}
echo "	</div>";
// Выводим таблицу отправлений
echo "
<br>
<br>
<table id='postcalc_table' class='ui-widget-content ui-corner-all'>
<tr class='ui-widget-header ui-widget-content'><th>Название</th>";
    if ( $postcalc_config_arrColumns['Количество'] ) echo "<th nowrap>Кол-во</th>";
    if ( $postcalc_config_arrColumns['Тариф'] ) echo "<th>Тариф</th>";
    if ( $postcalc_config_arrColumns['Страховка'] ) echo "<th>Страховка</th>";
    if ( $postcalc_config_arrColumns['Доставка'] ) echo "<th>Доставка</th>";
    if ( $postcalc_config_arrColumns['Ценность'] ) echo "<th>Ценность</th>";
    if ( $postcalc_config_arrColumns['СрокДоставки'] ) echo "<th>Сроки</th>";
echo "</tr>\n";
// Выводим список тарифов
$counter = 0;

foreach ( $arrResponse['Отправления'] as  $parcel_short_name => $arr_parcel ) {
    
    // Выводим только те виды отправлений, которые содержатся в массиве arrParcels.
    if ( !in_array($parcel_short_name, $postcalc_config_arrParcels) ) continue;
    
    if ( isset($arr_parcel['Доставка']) && $arr_parcel['Доставка'] ) {
	echo "<tr";
        // Расцветка четных полос. 
        if ( $counter % 2 ) echo " class='ui-state-highlight'";
        echo "><td nowrap>$arr_parcel[Название] </td>";
        
        // Столбец Количество
        if ( $postcalc_config_arrColumns['Количество'] ) 
             echo "<td>$arr_parcel[Количество]</td>";

        // Столбец Тариф
        if ( $postcalc_config_arrColumns['Тариф'] ) 
             echo "<td nowrap>".number_format($arr_parcel['Тариф'],2,',',' ')."</td>";

        // Столбец Страховка
        if ( $postcalc_config_arrColumns['Страховка'] ) 
             echo isset($arr_parcel['ОценкаПолная']) ?
                 "<td nowrap>".number_format($arr_parcel['Страховка'],2,',',' ')."</td>" : "<td style='text-align:center'>-</td>";
        
        // Столбец Доставка
        if ( $postcalc_config_arrColumns['Доставка'] ) 
             echo "<td nowrap>".number_format($arr_parcel['Доставка'],2,',',' ')."</td>";
        
        // Столбец ОценкаПолная (Ценность)
        // ОценкаПолная вычисляется только для ценных отправлений
        if ( $postcalc_config_arrColumns['Ценность'] ) 
             echo isset($arr_parcel['ОценкаПолная']) ?
                 "<td nowrap>".number_format($arr_parcel['ОценкаПолная'],2,',',' ')."</td>" : "<td style='text-align:center'>-</td>";
        
        // Столбец Срок Доставки
        if ( $postcalc_config_arrColumns['СрокДоставки'] ) 
            echo "<td class='center'>$arr_parcel[СрокДоставки]</td>";
        
        echo "
                </tr>\n";
        
        $counter++;
    }
    
}
echo "</table>
<div style='margin-left: 0em'>* Тарифы для корпоративных клиентов Почты России и физических лиц без договора отличаются. </div>
";

if ( $postcalc_config_debug ) { 
    echo "<pre>\n"; 
    print_r($arrResponse); 
    echo "</pre>\n"; 
}
    

}

}

?>
    </div>
            </div>
        </body>
</html>
