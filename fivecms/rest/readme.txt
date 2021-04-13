1) REST API не является официально заявленным функционалом и предоставляется в формате "как есть".

Доступны запросы GET, POST, PUT (функционал по POST и PUT запросам см. в соответствующих файлах RestBlog.php и
RestProducts.php).

2) Для тестирования запросов используйте файл test.php

Логин/пароль администратора должны быть указаны в коде test.php:
	$request->setUsername('test');
	$request->setPassword('test');

Пример тестирования GET-запроса:

URL: http://site.ru/fivecms/rest/products/?fields=name&join=variants

и далее нажимаете "Отправить"

в поле "Response" получаете JSON-ответ от сервера.

а) Работа с товарами:

Список товаров
/products/

Список товаров по id
/products/1,2,3/

Выбор полей
/products/?fields=id,name,body,position,created и т.д. (полный список полей можно получить по запросу /products/)

Присоединение связанных данных (изображения, варианты, категории, свойства)
/products/?join=images,variants,categories,features

Сортировка
/products/?sort=name

Страница и кол-во элементов на странице
/products/?page=5&limit=10

Выборка по id категории:
/products/?category=5

Выборка по id бренда:
/products/?brand=5

б) Работа с записями блога:

Все записи блога
/blog/

Список постов по id
/blog/1,2,3/

Выбор полей
/blog/?fields=id,category,name,url,annotation,text и т.д. (полный список полей можно получить по запросу /blog/)

Присоединение связанных изображений
/blog/?join=images

Выборка по id категории:
/blog/?category=5

Сортировка
/blog/?sort=name

Страница и кол-во элементов на странице
/blog/?page=5&limit=10

в) Работа с заказами:

Все заказы
/orders/

Список заказов по id
/orders/1,2,3/

Выбор полей
/orders/?fields=id,paid,date и т.д. (полный список полей можно получить по запросу /orders/)

Присоединение товаров из заказа
/orders/?join=purchases

Страница и кол-во элементов на странице
/orders/?page=5&limit=10

Выборка по id статуса заказа
/orders/?status=1

3) Внесение изменений. Дополнительный функционал реализуется по аналогии с уже имеющимся.

У вас всего 3 файла для изменений:

RestBlog.php - блог
RestProducts.php - товары
RestOrders.php - заказы

