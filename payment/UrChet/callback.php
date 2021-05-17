<?php

chdir('../..');
require_once('api/Fivecms.php');
$fivecms = new Fivecms();

/**
 * Склоняем словоформу
 * @ author runcore
 */
function morph($n, $f1, $f2, $f5)
{
    $n = abs(intval($n)) % 100;
    if ($n > 10 && $n < 20) return $f5;
    $n = $n % 10;
    if ($n > 1 && $n < 5) return $f2;
    if ($n == 1) return $f1;
    return $f5;
}

/**
 * Возвращает сумму прописью
 * @author runcore
 * @uses morph(...)
 * $onlyrub = true - выводить только рубли прописью, без единиц измерения и копеек
 */
function num2str($num, $onlyrub = false)
{
    $nul = 'ноль';
    $ten = array(
        array('', 'один', 'два', 'три', 'четыре', 'пять', 'шесть', 'семь', 'восемь', 'девять'),
        array('', 'одна', 'две', 'три', 'четыре', 'пять', 'шесть', 'семь', 'восемь', 'девять'),
    );
    $a20 = array('десять', 'одиннадцать', 'двенадцать', 'тринадцать', 'четырнадцать', 'пятнадцать', 'шестнадцать', 'семнадцать', 'восемнадцать', 'девятнадцать');
    $tens = array(2 => 'двадцать', 'тридцать', 'сорок', 'пятьдесят', 'шестьдесят', 'семьдесят', 'восемьдесят', 'девяносто');
    $hundred = array('', 'сто', 'двести', 'триста', 'четыреста', 'пятьсот', 'шестьсот', 'семьсот', 'восемьсот', 'девятьсот');
    $unit = array( // Units
        array('копейка', 'копейки', 'копеек', 1),
        array('рубль', 'рубля', 'рублей', 0),
        array('тысяча', 'тысячи', 'тысяч', 1),
        array('миллион', 'миллиона', 'миллионов', 0),
        array('миллиард', 'милиарда', 'миллиардов', 0),
    );
    //
    list($rub, $kop) = explode(".", sprintf("%015.2f", floatval($num)));
    $out = array();
    if (intval($rub) > 0) {
        foreach (str_split($rub, 3) as $uk => $v) { // by 3 symbols
            if (!intval($v)) continue;
            $uk = sizeof($unit) - $uk - 1; // unit key
            $gender = $unit[$uk][3];
            list($i1, $i2, $i3) = array_map("intval", str_split($v, 1));
            // mega-logic
            $out[] = $hundred[$i1]; # 1xx-9xx
            if ($i2 > 1) $out[] = $tens[$i2] . " " . $ten[$gender][$i3]; # 20-99
            else $out[] = $i2 > 0 ? $a20[$i3] : $ten[$gender][$i3]; # 10-19 | 1-9
            // units without rub & kop
            if ($uk > 1) $out[] = morph($v, $unit[$uk][0], $unit[$uk][1], $unit[$uk][2]);
        } //foreach
    } else $out[] = $nul;
    if (!$onlyrub) {
        $out[] = morph(intval($rub), $unit[1][0], $unit[1][1], $unit[1][2]); // rub
        $out[] = $kop . " " . morph($kop, $unit[0][0], $unit[0][1], $unit[0][2]); // kop
    }
    return trim(preg_replace("/ {2,}/", " ", join(" ", $out)));
}


$plat = strip_tags(stripslashes($_POST['platelschik']));
$gruz = strip_tags(stripslashes($_POST['gruzopoluchatel']));

$payment_settings = $fivecms->payment->get_payment_settings(stripslashes($_POST['payment_method']));

// params
$poluchatel = stripslashes($_POST['poluchatel']);
$inn = stripslashes($_POST['inn']);
$kpp = stripslashes($_POST['kpp']);
$bank = stripslashes($_POST['bank']);
$bik = stripslashes($_POST['bik']);
$schet = stripslashes($_POST['schet']);
$korchet = stripslashes($_POST['korchet']);
$banknote = stripslashes($_POST['banknote']);
$order_id = stripslashes($_POST['order_id']);

$order = $fivecms->orders->get_order((integer)$order_id); // получаем данные заказа
$delivery = $fivecms->delivery->get_delivery($order->delivery_id); // получаем данные доставки

require_once 'fivecms/classes/PHPExcel.php';
$objReader = PHPExcel_IOFactory::createReader('Excel5');
$objPHPExcel = $objReader->load("fivecms/design/xls/invoice.xls");

$currency = $fivecms->money->get_currency();
// Получаем дату из текстового значения
$order_date = strtotime($order->date);
// Получаем полную дату для вставки в Ecxel 
$excel_full_date = PHPExcel_Shared_Date::PHPToExcel(gmmktime(0, 0, 0, date('m', $order_date), date('d', $order_date), date('Y', $order_date)));
$total_price = ($order->separate_delivery ? $order->total_price + $order->delivery_price : $order->total_price);

$objPHPExcel->setActiveSheetIndex(0);
$objPHPExcel->getActiveSheet()->setCellValue('B6', 'ИНН ' . $inn)
    ->setCellValue('E6', 'КПП ' . $kpp)
    ->setCellValue('B8', $poluchatel)
    ->setCellValue('B10', $bank)
    ->setCellValueExplicit('H9', $bik, PHPExcel_Cell_DataType::TYPE_STRING)
    ->setCellValueExplicit('H8', $schet, PHPExcel_Cell_DataType::TYPE_STRING)
    ->setCellValueExplicit('H10', $korchet, PHPExcel_Cell_DataType::TYPE_STRING)
    ->setCellValue('B12', 'Счет на оплату № ' . $order->id . ' от ' . date('d.m.Y', $order_date) . ' г.')
    ->setCellValue('D13', $plat)
    ->setCellValue('D14', $gruz);
//$objPHPExcel->getActiveSheet()->getStyle('H8')->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_TEXT);
$row_height = ceil(mb_strlen($plat, 'utf8') / 80) * 14.25;
$objPHPExcel->getActiveSheet()->getRowDimension(13)->setRowHeight($row_height);
$row_height = ceil(mb_strlen($gruz, 'utf8') / 80) * 14.25;
$objPHPExcel->getActiveSheet()->getRowDimension(14)->setRowHeight($row_height);

$skidka = 1 - $order->discount / 100;

$purchases = $fivecms->orders->get_purchases(array('order_id' => $order->id));
$baseRow = 18;
$subtotal = 0;
$subtotal_pdv = 0;

foreach ($purchases as $r => $p) {
    $row = $baseRow + $r;
    $objPHPExcel->getActiveSheet()->insertNewRowBefore($row, 1);
    $tovar = $p->product_name . ' ' . $p->variant_name . ' ' . ($p->sku ? 'артикул ' . $p->sku : '');

    $row_height = ceil(mb_strlen($tovar, 'utf8') / 50) * 12;
    $objPHPExcel->getActiveSheet()->mergeCells('C' . $row . ':E' . $row);
    $objPHPExcel->getActiveSheet()->setCellValue('B' . $row, $r + 1)
        ->setCellValue('C' . $row, $tovar)
        ->setCellValue('F' . $row, $fivecms->settings->units)
        ->setCellValue('G' . $row, $p->amount)
        ->setCellValue('H' . $row, round($p->price * (100 - $order->discount) / 100, 2))
        ->setCellValue('I' . $row, '=G' . $row . '*H' . $row);

    $objPHPExcel->getActiveSheet()->getRowDimension($row)->setRowHeight($row_height);
}
// Если есть доставка и она не пустая, то рисуем строку
if ($delivery && $order->delivery_price > 0) {
    $row++;
    $r++;
    $objPHPExcel->getActiveSheet()->insertNewRowBefore($row, 1);
    $objPHPExcel->getActiveSheet()->mergeCells('C' . $row . ':E' . $row);
    $objPHPExcel->getActiveSheet()->setCellValue('B' . $row, $r + 1)
        ->setCellValue('C' . $row, $delivery->name)
        ->setCellValue('G' . $row, 1)
        ->setCellValue('H' . $row, $order->delivery_price)
        ->setCellValue('I' . $row, '=G' . $row . '*H' . $row);
}

$objPHPExcel->getActiveSheet()->removeRow($baseRow - 1, 1);

$objPHPExcel->getActiveSheet()->setCellValue('I' . ($row + 0), '=SUM(I' . ($baseRow - 1) . ':I' . ($row - 1) . ')')
    ->setCellValue('I' . ($row + 2), '=I' . ($row + 0))
    ->setCellValue('B' . ($row + 4), 'Всего наименований ' . ($r + 1) . ', на сумму')
    ->setCellValue('F' . ($row + 4), '=I' . ($row + 2))
    ->setCellValue('B' . ($row + 5), num2str($objPHPExcel->getActiveSheet()->getCell('I' . ($row + 2))->getCalculatedValue()));

if (isset($payment_settings['stamp'])) {
    // Лепим печать
    $objDrawing = new PHPExcel_Worksheet_Drawing();
    $objDrawing->setName('Stamp');
    $objDrawing->setDescription('stamp');
    $objDrawing->setPath('fivecms/design/xls/stamp.png');
    $objDrawing->setHeight(153);
    $objDrawing->setCoordinates('E' . ($row + 7));
    $objDrawing->setOffsetX(10);
    $objDrawing->setWorksheet($objPHPExcel->getActiveSheet());

    // Лепим подпись
    $objDrawing = new PHPExcel_Worksheet_Drawing();
    $objDrawing->setPath('fivecms/design/xls/podpis.png');
    $objDrawing->setHeight(68);
    $objDrawing->setCoordinates('E' . ($row + 6));
    $objDrawing->setOffsetX(-20);
    $objDrawing->setWorksheet($objPHPExcel->getActiveSheet());
    // ... и еще одну подпись
    $objDrawing = new PHPExcel_Worksheet_Drawing();
    $objDrawing->setPath('fivecms/design/xls/podpis.png');
    $objDrawing->setHeight(68);
    $objDrawing->setCoordinates('D' . ($row + 8));
    $objDrawing->setOffsetX(20);
    $objDrawing->setOffsetY(10);
    $objDrawing->setWorksheet($objPHPExcel->getActiveSheet());
}

if (isset($payment_settings['security'])) {
    $objPHPExcel->getActiveSheet()->getProtection()->setPassword($payment_settings['pass']);
    $objPHPExcel->getActiveSheet()->getProtection()->setSheet(true); // This should be enabled in order to enable any of the following!
    $objPHPExcel->getActiveSheet()->getProtection()->setSort(true);
    $objPHPExcel->getActiveSheet()->getProtection()->setInsertRows(true);
    $objPHPExcel->getActiveSheet()->getProtection()->setFormatCells(true);
    $objPHPExcel->getActiveSheet()->getProtection()->setObjects(true);
    $objPHPExcel->getActiveSheet()->getProtection()->setScenarios(true);
}

// Redirect output to a client’s web browser (Excel5)
header('Content-Type: application/vnd.ms-excel');
header('Content-Disposition: attachment;filename="Schet_N' . $order->id . '.xls"');
header('Cache-Control: max-age=0');
// If you're serving to IE 9, then the following may be needed
header('Cache-Control: max-age=1');

// If you're serving to IE over SSL, then the following may be needed
header('Expires: Mon, 26 Jul 1997 05:00:00 GMT'); // Date in the past
header('Last-Modified: ' . gmdate('D, d M Y H:i:s') . ' GMT'); // always modified
header('Cache-Control: cache, must-revalidate'); // HTTP/1.1
header('Pragma: public'); // HTTP/1.0


$objWriter = PHPExcel_IOFactory::createWriter($objPHPExcel, 'Excel5');
$objWriter->save('php://output');		
