<?php

/**
 * Класс для работы доставки Почтой России
 * Сайт https://www.postcalc.ru/
 */
class Postcalc
{
    /**
     * API ключ сервиса
     * @var string
     */
    private static $key = '';

    /**
     * Отделение отправителя по умолчанию. 101000 - Московский главпочтамт.
     * @var string
     */
    private static $default_from = 'Москва';

    // ID доставки в системе
    private static $delivery_id = 122;

    public $config = [
        // === ИСТОЧНИК ДАННЫХ ===
        'txt_dir' => '/base',   // Путь размещение текстовых файлов данных

        // === НАСТРОЙКИ ЗАПРОСА ===
        'ib' => 'p',    // База страховки - полная f или частичная p
        'r' => 0.01,   // Округление вверх поля ОценкаПолная при ответе по API. 0.01 - округление до копеек, 1 - до рублей
        'pr' => 0,      // Наценка в рублях за обработку заказа
        'pk' => 0,      // Наценка в рублях за упаковку одного отправления
        'cs' => 'utf-8',    // Кодировка
        'd' => 'now',  // Дата отправления
        'co' => 1,      // Если 1, то рассчитываются тарифы для корпоративных клиентов
        'p' => ['bv','b1v','pv','p1','em','is','isa','ip','ipa','iem'],  // Запросить расчеты по отправлениям:
        // внутренние - ценная бандероль, ценная посылка, ценная посылка и бандероль 1-го класса, EMS;
        // международные - мелкий пакет, мелкий пакет авиа, посылка, посылка авиа, ЕMS с товарами.
        'sv' => [],     // Опции и дополнительные услуги
        'pa' => 0,      // Неделимое отправление (товар нельзя отправить в нескольких посылках).
        'city_as_pindex' => 1,  // Если 1, то в запрос вместо нас.пункта будет подставлен его почтовый индекс по умолчанию. Настоятельно рекомендуется оставить city_as_pindex равным 1!
        'bo' => '',     // Упаковка возможные значения s,m,l,xl,ng (негабарит).

        // === НАСТРОЙКИ ВЕБ-ФОРМЫ ===
        'hide_from' => 0,       // Скрыть поле "Откуда".
        'autocomplete_items' => 10,     // Число элементов в списке автодополнения для полей "Откуда" и "Куда"

        // === ЖУРНАЛ СОЕДИНЕНИЙ И СТАТИСТИКА ===
        'log' => 1,                    // Если 1, ведет в cache_dir журнал соединений вида postcalc_light_YYYY-MM.log
        // Учтите, что при перезагрузке сервера временный каталог по умолчанию (/tmp)
        // обычно очищается и журналы удаляются, поэтому задайте для cache_dir иной каталог.
        'error_log' => 1,              // Если 1, ведет в cache_dir журнал ошибок соединения вида postcalc_light_error_YYYY-MM.log
        'error_log_send' => 10,        // Число ошибок соединения, после которых по адресу ml отсылается извещение об ошибках.
        // Если 0, извещение не отсылается.
        'pass' => '',                  // Пароль для доступа к статистике. Если пустая строка - не запрашивается.
        'pass_keep_days' => 365,       // Сколько хранить пароль в куки. 0 - хранить в течение сеанса.

        // === НАСТРОЙКИ СОЕДИНЕНИЯ ===
        'cache_dir' => '',  // Каталог кэширования - любой, в который веб-сервер имеет право записи
        'cache_valid' => 600,           // Время в секундах, после которого кэш считается устаревшим
        'timeout' => 5,                 // Время ожидания ответа сервера в секундах
        'servers' => ['test.postcalc.ru', 'api.postcalc.ru'],    //Список серверов

        // === НАСТРОЙКИ ВЫВОДА ВЕБ-КЛИЕНТА ===
        /* Режим отладки. Если 1 - под таблицей с тарифами выводится полный массив ответа сервера.
         Обратите внимание на параметры _request и _server в самом конце - это переменные, которые были в запросе,
         и некоторые переменные ответа сервера.
         Переменная [_server][REMOTE_ADDR] содержит реальный IP, с которого ушел ваш запрос.
         */
        'debug' => 0,
    ];

    /**
     * Какие колонки таблицы показывать.
     * @var array
     */
    public $columns = [
        'Количество' => 1,
        'Тариф' => 1,
        'Страховка' => 1,
        'Доставка' => 1,
        'Ценность' => 1,
        'СрокДоставки' => 1,
    ];

    /**
     * Размеры коробки для EKOM и EMS
     * @var array
     */
    public $boxes = [
        's' => 'S (260*170*80)',
        'm' => 'M (300*200*150)',
        'l' => 'L (400*270*180)',
        'xl' => 'XL (530*360*220)',
        'ng' => 'Негабарит'
    ];

    /**
     * Массив названий почтовых отправлений, который выводится в клиенте.
     * @var array
     */
    public $parcels = [
        'Письма' => [
            'ls' => 'ПростоеПисьмо',
            'lr' => 'ЗаказноеПисьмо',
            'lv' => 'ЦенноеПисьмо',
            'l1r' => 'ЗаказноеПисьмо1Класс',
            'l1v' => 'ЦенноеПисьмо1Класс',
        ],
        'Бандероли' => [
            'bs' => 'ПростаяБандероль',
            'br' => 'ЗаказнаяБандероль',
            'bv' => 'ЦеннаяБандероль',
            'b1r' => 'ЗаказнаяБандероль1Класс',
            'b1v' => 'ЦеннаяБандероль1Класс',
        ],
        'Посылки' => [
            'pv' => 'ЦеннаяПосылка',
            'p1' => 'Посылка1Класс',
        ],
        'EMS' => [
            'em' => 'EMS',
        ],
        'Отправления для интернет-магазинов' => [
            'po' => 'ПосылкаОнлайн',
            'co' => 'КурьерОнлайн',
            'ek' => 'ЕКОМ',
            'emo' => 'EMSОптимальное',
            'emoc' => 'EMSОптимальноеКурьер',
        ],
        'Отправления для юрлиц' => [
            'bc' => 'БизнесКурьер',
            'bce' => 'БизнесКурьерЭкспресс',
        ],
        'Международные отправления' => [
            'ib' => 'МждБандероль',
            'iba' => 'МждБандерольАвиа',
            'ibr' => 'МждБандерольЗаказная',
            'ibar' => 'МждБандерольАвиаЗаказная',
            'im' => 'МждМешокМ',
            'ima' => 'МждМешокМАвиа',
            'imr' => 'МждМешокМЗаказной',
            'imar' => 'МждМешокМАвиаЗаказной',
            'is' => 'МждМелкийПакет',
            'isa' => 'МждМелкийПакетАвиа',
            'isr' => 'МждМелкийПакетЗаказной',
            'isar' => 'МждМелкийПакетАвиаЗаказной',
            'ip' => 'МждПосылка',
            'ipa' => 'МждПосылкаАвиа',
            'ied' => 'EMS_МждДокументы',
            'iem' => 'EMS_МждТовары',
        ]
    ];

    /**
     * @var array
     */
    public $services = [
        'fr' => 'Хрупкая (только для посылок)',
        'ng' => 'Негабаритная (только для посылок)',
        'op' => 'Проверка соответствия вложения описи',
        'ko' => 'Проверка комплектности',
        'pp' => 'Предпочтовая подготовка',
        'sm' => 'SMS получателю',
        'sm2' => 'SMS отправителю',
        'cod' => 'Оплата в момент доставки (COD)',
        'uv' => 'Простое уведомление о вручении',
        'uvr' => 'Заказное уведомление о вручении',
        'uve' => 'Электронное уведомление о вручении',
        'iuv' => 'Международное уведомление о вручении',
    ];

    /**
     * Postcalc constructor.
     * @param array|false $config
     */
    public function __construct($config = [])
    {
        $this->config['txt_dir'] = __DIR__ . $this->config['txt_dir'];
        $this->config['cache_dir'] = sys_get_temp_dir();
        $this->config['default_from'] = self::$default_from;

        if ($config && is_array($config)) {
            $this->config = array_merge($this->config, $config);
        }
    }

    /**
     * Основная функция опроса сервера Postcalc.RU
     *
     * Настройки хранятся в конфигурационном файле файле postcalc_light_config.php.<br>
     *
     * Принимает следующие данные: отправитель, получатель, вес, оценка, страна. <br>
     *
     * 1). Проверяет эти данные, при ошибке возвращает строку с сообщением об ошибке.<br>
     *
     * 2). В цикле опрашивает сервера проекта Postcalc.RU (переменная servers
     * конфигурационного файла).<br>
     *
     * 3). В случае успеха возвращает массив с полученными от сервера данными,
     * при ошибке - строку с сообщением об ошибке.<br>
     *
     * 4). Использует кэширование: в случае успеха записывает ответ в каталог cache_dir,
     * хранит ответ в течение cache_valid секунд. <br>
     *
     * <code>
     * $res=postcalc_request('101000', 'Александровка, Алтайский край, Локтевский район', 505.1, 1000, 'RU');
     *
     * if (is_array($res)) {
     *      echo $res['Отправления']['ПростаяБандероль']['Тариф'];
     *      } else {
     *      echo "Ошибка: $res";
     * }
     * </code>
     *
     * @param string $From Отправитель. Либо 6-значный индекс ОПС, который проверяется по файлу postcalc_light_post_indexes.txt
     * или таблице postcalc_light_post_indexes, либо наименование населенного пункта, которое проверяется по файлу
     * postcalc_light_cities.txt или таблице postcalc_light_cities.
     * @param string $To Получатель. Либо 6-значный индекс ОПС, который проверяется по файлу postcalc_light_post_indexes.txt
     * или таблице postcalc_light_post_indexes, либо наименование населенного пункта, которое проверяется по файлу
     * postcalc_light_cities.txt или таблице postcalc_light_cities.
     * @param float $Weight Вес в граммах, от 1 до 100000.
     * @param int $Valuation Оценка почтового отправления в рублях, от 0 до 100000.
     * @param string $Country Двухбуквенный код страны, проверяется по файлу postcalc_light_countries.txt или
     * таблице postcalc_light_countries. Если отличается от RU, поле $To игнорируется.
     * @param string $Box
     * @param array $parcels
     * @param array $services
     * @return array|string В случае успеха возвращает массив с данными, полученными от сервера Postcalc.RU.
     *  При ошибке возвращает строку с сообщением об ошибке.
     * @uses postcalc_get_default_ops() Используется при валидации отправителя и получателя.
     * @uses postcalc_arr_from_txt() Используется при валидации страны.
     *
     * @since 10.05.2014
     * @author Postcalc.RU <postcalc@mail.ru>
     * @version 2.7
     */
    public function postcalc_request($From, $To, $Weight, $Valuation = 0, $Country = 'RU', $Box = '', $parcels = [], $services = [])
    {
        $config = $this->config;
        extract($this->config, EXTR_PREFIX_ALL, 'config');
        // Обязательно! Проверяем данные - больше всего ошибочных запросов из-за неверных значений веса и оценки,
        // из-за пропущенного поля "Куда".
        if (!is_numeric($Weight) || !($Weight > 0 && $Weight <= 100000)) {
            return "Bec в граммах - число от 1 до 100000, десятичный знак - точка!";
        }
        if (!is_numeric($Valuation) || !($Valuation >= 0 && $Valuation <= 100000)) {
            return "Оценка в рублях - число от 0 до 100000, десятичный знак - точка!";
        }

        // Отдельная функция проверяет правильность полей Откуда и Куда
        $PindexFrom = $this->get_default_ops($From);
        if (!$PindexFrom) {
            return "Поле 'Откуда': '$From' - не является допустимым индексом, названием региона или центра региона!";
        }

        $PindexTo = $this->get_default_ops($To);
        if (!$PindexTo) {
            return "Поле 'Куда': '$To' - не является допустимым индексом, названием региона или центра региона!";
        }

        // Если установлен флаг city_as_pindex, то в запрос подставляем почтовый индекс по умолчанию.
        // Если флаг city_as_pindex не установлен, переводим название нас.пункта в "процентную" кодировку.
        if (!$config['city_as_pindex']) {
            $From = rawurlencode($From);
            $To = rawurlencode($To);
        }

        if (!postcalc_arr_from_txt('postcalc_light_countries.txt', $Country, 1))
            return "Код страны '$Country' не найден в базе стран postcalc_light_countries.txt!";

        // Формируем запрос со всеми необходимыми переменными.
        $query_string = [
            'key' => self::$key,
            'o' => 'php',
            'sw' => 'PostcalcLight_2.7',
            'f' => $From,
            't' => $To,
            'w' => $Weight,
            'v' => $Valuation,
            'c' => $Country,
            'cs' => $config['cs'],
            'ib' => $config['ib'],
            'co' => $config['co']
        ];

        // Дата, по умолчанию - сегодня
        if ($config['d'] != 'now') {
            $query_string['d'] = $config['d'];
        }

        // Округление, по умолчанию - до 2 знаков
        if ($config['r'] != 0.01) {
            $query_string['r'] = $config['r'];
        }

        // Сбор за упаковку одного отправления, по умолчанию 0
        if ($config['pr'] > 0) {
            $query_string['pr'] = $config['pr'];
        }

        // Сбор за упаковку одного отправления, по умолчанию 0
        if ($config['pk'] > 0) {
            $query_string['pk'] = $config['pk'];
        }

        // Делимое отправление или нет
        if ($config['pa'] > 0) {
            $query_string['pa'] = $config['pa'];
        }

        // Переменная $Box может принимать значения s,m,l,xl,ng (негабарит).
        if ($Box) {
            $query_string['bo'] = $Box;
        } else if ($config['bo'] != '') {
            // Устанавливаем из конфига
            $query_string['bo'] = $config['bo'];
        }

        // Список кодов отправлений через запятую
        if ($parcels) {
            $query_string['p'] = implode(',', $parcels);
        } else if ($config['p'] != []) {
            // Устанавливаем из конфига
            $query_string['p'] = implode(',', $config['p']);
        }

        // Список доп.опций и услуг через запятую
        if ($services) {
            $query_string['sv'] = implode(',', $services);
        } else if ($config['sv'] != []) {
            // Устанавливаем из конфига
            $query_string['sv'] = implode(',', $config['sv']);
        }

        $query_string = http_build_query($query_string);

        // Название файла - префикс postcalc_ плюс хэш строки запроса
        $cache_file = "{$config['cache_dir']}/postcalc_" . md5($query_string) . '.txt';
        // Сборка мусора. Удаляем все файлы, которые подходят под маску, старше POSTCALC_CACHE_VALID секунд
        $cache_files = glob("{$config['cache_dir']}/postcalc_*.txt");
        $Now = time();
        foreach ($cache_files as $fileObj) {
            if ($Now - filemtime($fileObj) > $config['cache_valid']) unlink($fileObj);
        }

        // Если существует файл кэша для данной строки запроса, просто зачитываем его
        if (file_exists($cache_file)) {
            return unserialize(file_get_contents($cache_file));
        } else {
            $TS = microtime(1);
            // Опрашиваем в цикле сервера Postcalc.RU, пока не получаем ответ
            $ConnectOK = 0;

            foreach ($config['servers'] as $server) {
                // Запрос к серверу.
                $Request = "http://$server/?$query_string";
                $res = $this->http_request($Request, $config['timeout']);
                // При ошибке соединения опрашиваем следующий сервер в цепочке.
                if ($res === false) {
                    // === ОБРАБОТКА ОШИБОК СОЕДИНЕНИЯ
                    // Журнал ошибок соединения, поля разделены табуляцией:
                    // метка времени, сервер, истекшее время с начала сессии (т.е. всех запросов), краткое сообщение об ошибке, полное сообщение об ошибке
                    if ($config['error_log'] && count(error_get_last())) {
                        $ErrorLog = "{$config['cache_dir']}/postcalc_error_" . date('Y-m') . '.log';
                        $errors = error_get_last();
                        $PHPErrorMessage = $errors['message'];
                        // Отрезаем конец сообщения PHP, где сообщается причина проблемы
                        $ErrMessage = substr($PHPErrorMessage, strrpos($PHPErrorMessage, ':') + 2);
                        $fp_log = fopen($ErrorLog, 'a');
                        fwrite($fp_log, date('Y-m-d H:i:s') . "\t$server\t" . number_format((microtime(1) - $TS), 3) . "\t$ErrMessage\t$PHPErrorMessage\n");
                        fclose($fp_log);
                        if ($config['error_log_send'] > 0) {
                            $fp_log = fopen($ErrorLog, 'r');
                            // Последовательно идем по логу и сохраняем в переменной $MailMessage фрагмент не более $config_error_log_send строк
                            $MailMessage = '';
                            $send_log = false;
                            $line_counter = 0;
                            while (($line = fgets($fp_log)) !== false) {
                                $line_counter++;
                                if ($send_log) {
                                    $MailMessage = '';
                                    $send_log = false;
                                }
                                $MailMessage .= $line;
                                // Если в $MailMessage оказалось ровно $config_error_log_send строк, сбрасываем счетчик строк и устанавливаем флаг $send_log.
                                // Если следующее чтение вернуло конец файла, цикл будет прерван и фрагмент лога отослан по почте.
                                // Иначе фрагмент лога будет сброшен, как и флаг $send_log
                                if ($line_counter % $config['error_log_send'] === 0) {
                                    $line_counter = 0;
                                    $send_log = true;
                                }
                            }
                            fclose($fp_log);
                            if ($send_log) {
                                // TODO postcalc_light_stat нужно заменить
                                $MailMessage = "{$_SERVER['SERVER_ADDR']} [{$_SERVER['SERVER_ADDR']}]: ошибки соединения в скрипте {$_SERVER['SCRIPT_FILENAME']}.\n"
                                    . "Подробности см. в http://{$_SERVER['HTTP_HOST']}" . dirname($_SERVER['REQUEST_URI']) . "/postcalc_light_stat.php\n"
                                    . "Последние строки ({$config['error_log_send']}}) из журнала ошибок:\n\n"
                                    . $MailMessage;
                                mail($config['ml'],
                                    "{$_SERVER['SERVER_ADDR']} [{$_SERVER['SERVER_ADDR']}]: connection errors in postcalc_light_lib",
                                    $MailMessage,
                                    "Content-Transfer-Encoding: 8bit\nContent-Type: text/plain; charset={$config['cs']}\n");
                            }
                        }
                    }
                    // === КОНЕЦ ОБРАБОТКИ ОШИБОК СОЕДИНЕНИЯ
                    continue;
                }
                $ConnectOK = 1;
                break;
            }
            if (!$ConnectOK) {
                return 'Не удалось соединиться ни с одним из следующих серверов postcalc.ru: ' . implode(',', $config['servers']) . '. Проверьте соединение с Интернетом.';
            }

            $res_size = strlen($res);

            // Если поток сжат, разархивируем его
            if (substr($res, 0, 3) == "\x1f\x8b\x08") {
                $res = gzinflate(substr($res, 10, -8));
            }

            // Переводим ответ сервера в массив PHP
            if (!$response = unserialize($res)) {
                return "Получены странные данные. Ответ сервера:\n$res";
            }

            // Обработка возможной ошибки
            if ($response['Status'] != 'OK') {
                return "Сервер вернул ошибку: {$response['Status']}!";
            }

            // Журнал успешных соединений, поля разделены табуляцией:
            // метка времени, сервер, затраченное время, размер ответа, строка запроса
            if ($config['log']) {
                // TODO postcalc_light_ заменить
                $fp_log = fopen("{$config['cache_dir']}/postcalc_light_" . date('Y-m') . '.log', 'a');
                fwrite($fp_log, date('Y-m-d H:i:s') . "\t$server\t" . number_format((microtime(1) - $TS), 3) . "\t$res_size\t$query_string\n");
                fclose($fp_log);
            }
            // Успешный ответ пишем в кэш
            file_put_contents($cache_file, $res);

            return $response;
        }

    }

    /**
     * Функция проверки правильности отправителя или получателя. Принимает либо 6-значный индекс,
     * либо название населенного пункта из файла postcalc_light_cities.txt или таблицы postcalc_light_cities.
     * Например: 'Москва', 'Абагур (Новокузнецк)', 'Абрамцево, Московская область, Сергиево-Посадский район'.
     *
     * Возвращает 6-значный индекс ОПС, если не найдено - false.
     *
     * Если передан 6-значный индекс, проверка идет по текстовому файлу postcalc_light_post_indexes.txt
     * или таблице postcalc_light_post_indexes, где находятся все почтовые индексы России в формате
     * индекс ОПС - название ОПС из "эталонного справочника Почты России".
     *
     * <code>
     * $From = 'Сергиев Посад';
     *
     * $postIndex = get_default_ops($From);
     *
     * if ( !$postIndex ) echo "'$From' не является допустимым индексом, названием региона или центра региона!";
     * </code>
     *
     * @param string $from_to Проверяемое значение
     * @return string  При ошибке возвращает false, иначе - шестизначный индекс ОПС.
     *
     * @uses postcalc_arr_from_txt() Запрашивает массив, созданный из текстового файла.
     */
    private function get_default_ops($from_to)
    {
        if (!$from_to) return false;
        // Особый ключ из таблицы почтовых индексов - 000000. Значение - дата и номер обновления таблицы почтовых индексов.
        if ($from_to == '000000') return false;

        if (preg_match('/^[1-9][0-9]{5}$/', $from_to)) {
            // Это 6-значный индекс. 
            $isPindex = true;
            $arr = postcalc_arr_from_txt('postcalc_light_post_indexes.txt', $from_to);
        } else {
            // Это любое другое сочетание букв и цифр
            $isPindex = false;
            $arr = postcalc_arr_from_txt('postcalc_light_cities.txt', $from_to);
        }
        // Ищем точное совпадение $FromTo и ключа в массиве. 
        if (isset($arr[$from_to])) {
            return ($isPindex) ? $from_to : $arr[$from_to];
        }

        return false;
    }

    private function http_request($request, $timeout)
    {
        $user_agent = 'PostcalcLight_2.7 ' . phpversion();
        // Получаем значение для специального индекса 000000, который содержит версию БД
        $arr = $this->arr_from_txt('postcalc_light_post_indexes.txt', '000000', 1);
        if ($arr) {
            $user_agent .= ' DB ' . current($arr);
        }

        // Если установлен пакет curl, используем именно его, т.к. file_get_contents делает лишний цикл запрос-ответ.
        if (function_exists('curl_init')) {
            $ch = curl_init();
            curl_setopt($ch, CURLOPT_URL, $request);
            curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
            curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, $timeout);
            curl_setopt($ch, CURLOPT_HTTPHEADER, ['Connection: close', 'Accept-Encoding: gzip']);
            curl_setopt($ch, CURLOPT_USERAGENT, $user_agent);
            $response = curl_exec($ch);
            curl_close($ch);
        } else {
            // Формируем опции запроса. Это _необязательно_, однако упрощает контроль и отладку
            $options = ['http' => ['header' => [
                'Connection: close', 'Accept-Encoding: gzip',
                'timeout' => $timeout,
                'user_agent' => $user_agent
            ]]];
            // Подавляем вывод сообщений и сохраняем ответ в переменной $Response. 
            $response = @file_get_contents($request, false, stream_context_create($options));
        }
        return $response;
    }

    /**
     * Функция генерирует массив PHP либо из текстового файла с данными,
     * либо из таблицы MySQL.
     *
     * В первом случае открывает файл $src_txt, в котором находятся данные в формате:
     * [ключ]\t[значение]\n.
     *
     * Во втором случае обращается к таблице MySQL. Ее название совпадает с названием
     * текстового файла без расширения .txt.
     *
     * Возвращает массив. Параметр search - совпадение с началом ключа. Если пустая
     * строка (по умолчанию) - возвращает все строки.
     *
     * @param string $src_txt Название файла с данными (включая расширение .txt).
     * @param string $search Совпадение с началом ключа. Если пустая строка - возвращает полную таблицу.
     * @param integer $limit Возвращать не более $limit элементов (для Autocomplete)
     * @return array Массив, если совпадений нет - пустой массив
     *
     */
    private function arr_from_txt($src_txt, $search = '', $limit = 0)
    {
        $cs = $this->config['cs'];

        $arr = [];

        // === Источник - текстовый файл.
        $src_idx = basename($src_txt, 'txt') . 'idx';
        $src_txt = $this->config['txt_dir'] . '/' . $src_txt;
        $src_idx = $this->config['txt_dir'] . '/' . $src_idx;
        $search = mb_convert_case($search, MB_CASE_LOWER, $cs);

        // == Если нет файла индекса или фильтр отсутствует, идем полным перебором 
        if (!file_exists($src_idx) || $search == '') {
            $fp = fopen($src_txt, 'r');
            $counter = 0;
            while (($line = fgets($fp)) !== false) {
                list($key, $value) = explode("\t", $line);
                if ($search == '' ||
                    ($search != '' && mb_stripos($key, $search, 0, $cs) === 0)
                ) {
                    $arr[$key] = trim($value);
                    if ($limit > 0 && ++$counter >= $limit) break;
                }
            }
            fclose($fp);
            return $arr;
        }
        // == Индексный файл есть.
        $string_idx = file_get_contents($src_idx);
        // Начало совпадения
        $pos = mb_strpos(
            $string_idx,
            // Берем два первых символа
            "\n" . mb_substr($search, 0, 2, $cs),
            0,
            $cs
        );
        $idx_len = mb_strlen($string_idx, $cs);
        // Конец строки с совпадением
        $pos_line_end = mb_strpos($string_idx, "\n", $pos + 1, $cs);
        $s = mb_substr($string_idx, $pos + 1, $pos_line_end - $pos - 1, $cs);
        // Получили сдвиг в оригинальном файле.
        list($tmp, $offset) = explode("\t", $s);
        // Теперь длина. 
        if ($idx_len == $pos_line_end + 1) {
            // Если это последняя строка в файле индекса, то будем брать фрагмент до конца файла данных.
            // Берем любое большое число.
            $len = 1000000;
        } else {
            $pos = $pos_line_end + 1;
            $pos_line_end = mb_strpos($string_idx, "\n", $pos + 1, $cs);
            $s = mb_substr($string_idx, $pos + 1, $pos_line_end - $pos, $cs);
            list($tmp, $offset2) = explode("\t", trim($s));
            $len = $offset2 - $offset;
        }
        $fp = fopen($src_txt, 'r');
        fseek($fp, $offset);
        $chunk = fread($fp, $len);
        fclose($fp);
        // Теперь делаем массив.
        $arr_tmp = explode("\n", trim($chunk));
        $counter = 0;
        foreach ($arr_tmp as $no => $line) {
            list($key, $value) = explode("\t", $line);
            if ($search == '' ||
                ($search != '' && mb_stripos($key, $search, 0, $cs) === 0)
            ) {
                $arr[$key] = trim($value);
                if ($limit > 0 && ++$counter >= $limit) break;
            }

        }
        return $arr;
    }


    /**
     * Ищет индекс по названию
     * @param string $search
     * @return array
     */
    public function find_index($search = '')
    {
        return $this->arr_from_txt('postcalc_light_post_indexes.txt', $search, $this->config['autocomplete_items']);
    }

    /**
     * Автодополнение для полей "Откуда" и "Куда" на веб-странице. Работает с виджетом jQuery Autocomplete.
     *
     * Внимание! Входные данные ожидаются всегда в кодировке UTF-8.
     * jQuery Autocomplete эту кодировку обеспечивает автоматически, в остальных случаях можно применять
     * функцию javascript encodeURIComponent().
     *
     * Возвращает массив JSON для непосредственного использования в виджете jQuery Autocomplete в кодировке UTF-8.
     *
     *
     * @param string $search Начало почтового индекса или населенного пункта.
     * @return mixed Объект JSON для непосредственного использования в виджете jQuery Autocomplete.
     *
     * @uses postcalc_arr_from_txt() Запрашивает функцию postcalc_arr_from_txt() для получения массива, сгенерированного из текстового файла.
     */
    public function autocomplete($search)
    {
        $limit = $this->config['autocomplete_items'];
        $arr = [];
        // Не менее 3 начальных символов должны быть цифрами
        if (preg_match("/\d{3,}/", $search)) {
            $indexes = $this->arr_from_txt('postcalc_light_post_indexes.txt', $search, $limit);
            foreach ($indexes as $index => $name) {
                $arr[] = ['value' => (string)$name, 'index' => (string)$index];
            }
        } else {
            $cities = $this->arr_from_txt('postcalc_light_cities.txt', $search, $limit);
            foreach ($cities as $city => $index) {
                $arr[] = ['value' => (string)$city, 'index' => (string)$index];
            }
        }

        return $arr;
    }

}
