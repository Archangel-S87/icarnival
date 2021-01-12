;<? exit(); ?>

license = oJapX5uUk6OgmqiSnl-kplVb;
active_license = true

[database]

;Сервер базы данных
db_server = "localhost";

;Пользователь базы данных
db_user = "root";

;Пароль к базе
db_password = "root";

;Имя базы
db_name = "icarnival";

;Префикс для таблиц
db_prefix = f_;

;Кодировка базы данных
db_charset = UTF8;

;Режим SQL
db_sql_mode = " ";

;Смещение часового пояса
;db_timezone = '+04:00';

[php]
locale = 'en_US.utf8';
;locale = 'ru_RU.utf8';
;php_timezone = 'Europe/Moscow';

[smarty]
smarty_compile_check = true;
smarty_caching = 0;
smarty_cache_lifetime = 0;
smarty_debugging = true;
smarty_html_minify = true;
error_reporting = true;
 
[images]

;Использовать imagemagick для обработки изображений (вместо gd)
use_imagick = true;

;Директория оригиналов изображений
original_images_dir = files/originals/;
original_blog_images_dir = files/originals-blog/;
original_articles_images_dir = files/originals-articles/;
original_services_images_dir = files/originals-services/;

;Директория миниатюр
resized_images_dir = files/products/;
resized_blog_images_dir = files/blog/;
resized_articles_images_dir = files/articles/;
resized_services_images_dir = files/services/;

;Изображения категорий
categories_images_dir = files/categories/;

;Изображения категорий статей
articles_categories_images_dir = files/articles-categories/;

;Изображения разделов блога
blog_categories_images_dir = files/blog-categories/;

;Изображения услуг
services_categories_images_dir = files/services-categories/;

;Изображения категорий опросов
surveys_categories_images_dir = files/surveys-categories/;

;Изображения брендов
brands_images_dir = files/brands/;

;Файл изображения с водяным знаком
watermark_file = fivecms/files/watermark/watermark.png;

;Логотип
logoimg_file = files/logo/logo.png;

;Фавикон
faviconimg_file = favicon.ico;

;Баннеры
threebanners_images_dir = files/threebanners/;
banner1img_file = files/threebanners/banner1.png;
banner2img_file = files/threebanners/banner2.png;
banner3img_file = files/threebanners/banner3.png;
banner4img_file = files/threebanners/banner4.png;
bbanner1img_file = files/threebanners/bbanner1.png;
bbanner2img_file = files/threebanners/bbanner2.png;
bbanner3img_file = files/threebanners/bbanner3.png;
bbanner4img_file = files/threebanners/bbanner4.png;

;Слайды / Slides
slides_images_dir = files/slides/;

;Слайды моб. / Slides mobile 
slidesm_images_dir = files/slides-mob/;

;Модуль баннеров
banners_images_dir = files/banners/;

[files]

;Директория хранения цифровых товаров
downloads_dir = files/downloads/;

;Директория прикрекляемых файлов
cms_files_dir = files/files/;

[debug]
debug = true;

;Локалка
is_localhost = true;

;Переключиться в мобильную версию
is_mobile = false;
