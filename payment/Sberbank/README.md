# Модуль оплаты Сбербанк Интернет Эквайринг для Fivecms

### Особенности
* Передача корзины товаров (кассовый чек 54-ФЗ)
* Поддержка ФФД 1.05
* Если оплата не прошла или прошла с ошибкой, оплату можно повторить, хоть спустя 20 дней...
* Работает через REST
* Одноэтапная оплата


### Требования:
* php 5.6 и выше
* curl
* Fivecms



### Установка модуля:
1. Просто распаковать архив с файлами модуля по адресу `/payment/Sberbank/`
2. В админ-панели добавить новый способ оплаты `Сбербанк-Эквайринг`
3. Настроить модуль в соответствии с вашими требованиями

### Настройка:
* `Передавать данные для печати чека (54-ФЗ)` - товары в заказе. Так-же нужно включить ФФД 1.05 в Кассе и Сбербанк-админке

### Установка "Разный НДС для товаров":
1. Копируем файл `/payment/Sberbank/_sql_taxType_install.php` в корень сайта
2. Идем по адресу `http://ИМЯ_ВАШЕГО_САЙТА/_sql_taxType_install.php`
3. Открываем файл `/api/Products.php`
4. Ищем функции `get_products` и `get_product`
5. Ищем в этих функциях `p.visible,` и после добавляем `p.taxType,`
6. Открываем файл `/fivecms/design/html/product.tpl`, ищем `Параметры страницы`
7. Добавляем в этот блок: 
    ```
    <select name="taxType">
        <option value='0' {if $product->taxType=='0'}selected{/if}>без НДС</option>
        <option value='1' {if $product->taxType=='1'}selected{/if}>НДС по ставке 0%</option>
        <option value='2' {if $product->taxType=='2'}selected{/if}>НДС чека по ставке 10%</option>
        <option value='3' {if $product->taxType=='3'}selected{/if}>НДС чека по ставке 18%</option>
        <option value='4' {if $product->taxType=='4'}selected{/if}>НДС чека по расчетной ставке 10/110</option>
        <option value='5' {if $product->taxType=='5'}selected{/if}>НДС чека по расчетной ставке 18/118</option>
        <option value='6' {if $product->taxType=='6'}selected{/if}>НДС чека по ставке 20%</option>
        <option value='7' {if $product->taxType=='7'}selected{/if}>НДС чека по расчётной ставке 20/120</option>
    </select>
    ```
8. Открываем `/fivecms/ProductAdmin.php`
9. Ищем `$product->visible = $this->request->post('visible', 'boolean');` и после добавляем `$product->taxType = $this->request->post('taxType', 'integer');`
10. В настройках платежного модуля, в пункте `Разный НДС у товаров? `, ставим `да`.


Офф. документация:
-
* https://web.rbsdev.com/dokuwiki/doku.php/integration:api:rest:requests:register_cart (наиболее актуальная)
* https://securepayments.sberbank.ru/wiki/doku.php/integration:api:rest:requests:register_cart#items
* https://developer.sberbank.ru/doc/v1/acquiring/api-basket
