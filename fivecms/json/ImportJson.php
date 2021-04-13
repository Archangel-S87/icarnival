<?php

require_once '../../api/Fivecms.php';
require_once __DIR__ . '/JsonReader/vendor/autoload.php';

use pcrov\JsonReader\JsonReader;


class ImportJson extends Fivecms
{
    /**
     * Рабочий каталог
     * @var string
     */
    private $root_dir = __DIR__;

    /**
     * Каталог хранения файлов
     * @var string
     */
    private $files_dir = 'files';

    /**
     * Сопоставление external_id и id
     * @var array
     */
    private $mapping_categories = [];

    /**
     * Сопоставление external_id и id
     * @var array
     */
    private $mapping_brands = [];

    /**
     * Сопоставление имени и id
     * @var array
     */
    private $mapping_features = [];


    public function __construct()
    {
        parent::__construct();

        // Каталог хранения файлоа
        $this->files_dir = "$this->root_dir/$this->files_dir";
    }

    public function import_categories($is_update = 1)
    {
        $reader = new JsonReader();
        $reader->open("$this->files_dir/categories.json");

        if (!$is_update) {
            $this->db->query("TRUNCATE TABLE __categories");
            $this->db->query("TRUNCATE TABLE __categories_features");
        }

        $reader->read();
        $reader->read();
        while ($reader->type() === JsonReader::OBJECT) {
            $data = $reader->value();
            if (!$data) continue;
            $this->import_category((object)$data);
            $reader->next();
        }

        $reader->close();

        return 0;
    }

    private function import_category($json)
    {
        $this->db->query("SELECT id FROM __categories WHERE external_id=? LIMIT 1", $json->external_id);
        if ($this->db->result('id')) return;

        $json->parent_id = $this->get_category_id($json->parent_external_id);
        unset($json->parent_external_id);

        $this->db->query("INSERT INTO __categories SET ?%", $json);
        $this->mapping_categories[(int)$json->external_id] = $this->db->insert_id();
    }

    public function import_brands()
    {
        $reader = new JsonReader();
        $reader->open("$this->files_dir/brands.json");

        $reader->read();
        $reader->read();
        while ($reader->type() === JsonReader::OBJECT) {
            $data = $reader->value();
            if (!$data) continue;
            $this->import_brand((object)$data);
            $reader->next();
        }

        $reader->close();

        return 0;
    }

    private function import_brand($json)
    {
        $this->db->query("SELECT id FROM __brands WHERE external_id=? LIMIT 1", $json->external_id);
        if ($this->db->result('id')) return;

        $this->db->query("INSERT INTO __brands SET ?%", $json);
        $this->mapping_brands[(int)$json->external_id] = $this->db->insert_id();
    }

    public function import_products($is_update = 1)
    {
        $reader = new JsonReader();
        $reader->open("$this->files_dir/products.json");

        if (!$is_update) {
            $this->db->query("TRUNCATE TABLE __products");
            $this->db->query("TRUNCATE TABLE __products_categories");
            $this->db->query("TRUNCATE TABLE __images");
            $this->db->query("TRUNCATE TABLE __related_products");
            $this->db->query("TRUNCATE TABLE __features");
            $this->db->query("TRUNCATE TABLE __options");
            $this->db->query("TRUNCATE TABLE __variants");
        }

        $reader->read();
        $reader->read();
        while ($reader->type() === JsonReader::OBJECT) {
            $data = $reader->value();
            if (!$data) continue;
            $this->import_product((object)$data);
            $reader->next();
        }

        $reader->close();

        return 0;
    }

    private function import_product($json)
    {
        $this->db->query("SELECT id FROM __products WHERE external_id=? LIMIT 1", $json->external_id);
        if ($this->db->result('id')) return;

        $json->brand_id = $this->get_brand_id($json->brand_external_id);
        unset($json->brand_external_id);

        $json->featured = $json->featured ? 1 : 0;
        $json->is_new = $json->is_new ? 1 : 0;
        $json->to_yandex = $json->to_yandex ? 1 : 0;

        $categories = $json->categories_external_ids;
        unset($json->categories_external_ids);

        $images = $json->images;
        unset($json->images);

        $related_products = $json->related_external_ids;
        unset($json->related_external_ids);

        $features = $json->features;
        unset($json->features);

        $variants = $json->variants;
        unset($json->variants);

        $this->db->query("INSERT INTO __products SET ?%", $json);
        $product_id = $this->db->insert_id();
        $this->db->query("UPDATE __products SET position=id WHERE id=?", $product_id);

        // Категории
        foreach ($categories as $position => $category_external_id) {
            $category_id = $this->get_category_id($category_external_id);
            $this->categories->add_product_category($product_id, $category_id, $position);
        }

        // Изображения
        foreach ($images as $image) {
            $this->products->add_image($product_id, $image);
        }

        // Связанные товары
        foreach ($related_products as $position => $related_external_id) {
            $related_product_id = $this->get_product_id($related_external_id);
            if ($related_product_id) {
                $this->products->add_related_product($product_id, $related_product_id, $position);
            }
        }

        // Характеристики
        foreach ($features as $name => $value) {
            $feature_id = $this->get_feature_id($name);
            $this->features->update_option($product_id, $feature_id, $value);
            // Добавление характеристики к категории
            foreach ($categories as $category_external_id) {
                $category_id = $this->get_category_id($category_external_id);
                $this->features->add_feature_category($feature_id, $category_id);
            }
        }

        // Варианты
        foreach ($variants as $position => $variant) {
            $variant = (object)$variant;
            $variant->product_id = $product_id;
            $variant->name = $variant->name1;
            $variant->position = $position;
            $variant->attachment = '';
            $variant->unit = $this->settings->units;
            $variant->currency_id = $this->settings->onecurrency;
            $variant->discount = 0;
            $this->variants->add_variant($variant);
        }
    }

    public function import_users($is_update = 1)
    {
        $reader = new JsonReader();
        $reader->open("$this->files_dir/users.json");

        if (!$is_update) {
            $this->db->query("TRUNCATE TABLE __users");
        }

        $reader->read();
        $reader->read();
        while ($reader->type() === JsonReader::OBJECT) {
            $data = $reader->value();
            if (!$data) continue;
            $this->import_user((object)$data);
            $reader->next();
        }

        $reader->close();

        return 0;
    }

    private function import_user($json)
    {
        if ($this->get_user_id($json->email)) return;

        $json->group_id = 1;
        $json->phone = '';
        $json->partner_id = 0;
        $json->comment = '';
        $json->withdrawal = '';
        $json->ref_views = 0;

        $query = $this->db->placehold("INSERT INTO __users SET ?%", $json);
        $this->db->query($query);
    }

    public function import_orders($is_update = 1)
    {
        $reader = new JsonReader();
        $reader->open("$this->files_dir/orders_2.json");

        if (!$is_update) {
            $this->db->query("TRUNCATE TABLE __orders");
            $this->db->query("TRUNCATE TABLE __purchases");
        }

        $reader->read();
        $reader->read();
        while ($reader->type() === JsonReader::OBJECT) {
            $data = $reader->value();
            if (!$data) continue;
            $this->import_order((object)$data);
            $reader->next();
        }

        $reader->close();

        return 0;
    }

    private function import_order($json)
    {
        $json->user_id = $this->get_user_id($json->user_email);
        unset($json->user_email);
        $json->calc = '';

        $purchases = $json->purchases;
        unset($json->purchases);

        $query = $this->db->placehold("INSERT INTO __orders SET ?%", $json);
        $this->db->query($query);
        $order_id = $this->db->insert_id();

        foreach ($purchases as $purchase) {
            $purchase = (object)$purchase;
            $purchase->order_id = $order_id;
            $purchase->product_id = $this->get_product_id($purchase->product_external_id);
            unset($purchase->product_external_id);
            $purchase->variant_id = $this->get_variant_id($purchase->variant_external_id);
            unset($purchase->variant_external_id);
            $purchase->unit = $this->settings->units;;

            $query = $this->db->placehold("INSERT INTO __purchases SET ?%", $purchase);
            $this->db->query($query);
        }
    }

    private function get_feature_id($name)
    {
        if (isset($this->mapping_features[$name])) {
            return $this->mapping_features[$name];
        }
        $feature = ['name' => $name, 'in_filter' => 0];
        return $this->mapping_features[$name] = $this->features->add_feature($feature);
    }

    private function get_category_id($external_id)
    {
        $external_id = (int)$external_id;
        if (!$external_id) return 0;
        if (isset($this->mapping_categories[$external_id])) return $this->mapping_categories[$external_id];
        $query = $this->db->placehold("SELECT id FROM __categories WHERE external_id=? LIMIT 1", $external_id);
        $this->db->query($query);
        return $this->mapping_categories[$external_id] = (int)$this->db->result('id');
    }

    private function get_brand_id($external_id)
    {
        $external_id = (int)$external_id;
        if (!$external_id) return 0;
        if (isset($this->mapping_brands[$external_id])) return $this->mapping_brands[$external_id];
        $query = $this->db->placehold("SELECT id FROM __brands WHERE external_id=? LIMIT 1", $external_id);
        $this->db->query($query);
        return $this->mapping_brands[$external_id] = (int)$this->db->result('id');
    }

    private function get_product_id($external_id)
    {
        $external_id = (int)$external_id;
        if (!$external_id) return 0;
        $query = $this->db->placehold("SELECT id FROM __products WHERE external_id=? LIMIT 1", $external_id);
        $this->db->query($query);
        return (int)$this->db->result('id');
    }

    private function get_variant_id($external_id)
    {
        $external_id = (int)$external_id;
        if (!$external_id) return 0;
        $query = $this->db->placehold("SELECT id FROM __variants WHERE external_id=? LIMIT 1", $external_id);
        $this->db->query($query);
        return (int)$this->db->result('id');
    }

    private function get_user_id($email)
    {
        if (!$email) return 0;
        $query = $this->db->placehold("SELECT id FROM __users WHERE email=? LIMIT 1", $email);
        $this->db->query($query);
        return (int)$this->db->result('id');
    }

    private function create_path($path)
    {
        if (is_dir($path)) return;

        $parts = explode('/', $path);
        if (!is_array($parts)) return;

        if (count(explode('.', end($parts))) > 1) {
            // Проверка на файл в пути
            unset($parts[count($parts) - 1]);
        }

        $new_path = $parts[0];
        unset($parts[0]);
        foreach ($parts as $part) {
            if (!$part) continue;
            $new_path .= '/' . $part;
            if (!is_dir($new_path)) mkdir($new_path, 777);
        }
    }
}
