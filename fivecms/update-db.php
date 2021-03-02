<?php

error_reporting(E_ALL);
ini_set('display_startup_errors', 1);
ini_set('display_errors', '1');

require_once '../api/Fivecms.php';


class UpdateDB extends Fivecms
{
    private $tables;

    public function __construct()
    {
        parent::__construct();

        // Обновление таблицы __users
        $this->update_table_users();

        // Создание таблицы оплаты в сбере
        //$this->create_table_payments_sber();

        // Обновление таблицы __users
        $this->update_table_orders();

        // Обновление таблицы __delivery
        $this->update_table_delivery();

        //$this->set_users_order_payd();

        echo 0;
    }

    private function set_users_order_payd()
    {
        $count_orders = $this->orders->count_orders(['status' => 2]);
        $orders = $this->orders->get_orders(['status' => 2, 'limit' => $count_orders]);
        foreach ($orders as $order) {
            if($order->paid == 1) {
                $this->orders->set_pay($order->id);
            } elseif($order->paid == 0){
                $this->orders->unset_pay($order->id);
            }
        }
    }

    private function update_table_users()
    {
        $table_mame = 'users';

        // добавление колонок
        if (!$this->check_column('consignee', $table_mame)) {
            $this->db->query("ALTER TABLE __{$table_mame} ADD consignee TEXT DEFAULT NULL COMMENT 'грузополучатель'");
        }

        if (!$this->check_column('payer', $table_mame)) {
            $this->db->query("ALTER TABLE __{$table_mame} ADD payer TEXT DEFAULT NULL COMMENT 'плательщик'");
        }
    }

    private function update_table_orders()
    {
        $table_mame = 'orders';
        if (!$this->check_column('delivery_date', $table_mame)) {
            $this->db->query("ALTER TABLE __{$table_mame} ADD delivery_date DATETIME DEFAULT NULL COMMENT 'Ориентировочная дата доставки'");
        }

        if (!$this->check_column('phone_delivery', $table_mame)) {
            $this->db->query("ALTER TABLE __{$table_mame} ADD phone_delivery varchar(255) DEFAULT NULL COMMENT 'Телефон курьера'");
        }
    }

    private function update_table_delivery()
    {
        $table_mame = 'delivery';
        if (!$this->check_column('additional_cost', $table_mame)) {
            $this->db->query("ALTER TABLE __{$table_mame} ADD additional_cost DECIMAL(10,2) NOT NULL DEFAULT '0' COMMENT 'Дополнительная стоимость' AFTER `price2`");
        }
    }

    private function create_table_payments_sber()
    {
        $table_name = 'payments_sber';
        if ($this->check_table($table_name)) return;
        $table_name = $this->config->db_prefix . $table_name;
        $this->db->query("CREATE TABLE {$table_name} (`id` INT(11) NOT NULL AUTO_INCREMENT, `order_id` INT(11) NOT NULL, `trial` TINYINT(2) NOT NULL COMMENT 'orderId магазина в системе банка', `order_sber` VARCHAR(64) NOT NULL, `date_create` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, PRIMARY KEY (`id`), UNIQUE (`order_sber`)) ENGINE = MyISAM COMMENT = 'Оплата в сбере';");
    }

    private function create_table_shops()
    {
        if ($this->check_table('shops')) return;
        $table_name = $this->config->db_prefix . 'shops';
        $this->db->query("CREATE TABLE {$table_name} (`id` INT(11) NOT NULL AUTO_INCREMENT, `name` VARCHAR(30) NULL DEFAULT NULL, `address` VARCHAR(200) NULL DEFAULT NULL, `external_id` VARCHAR(74) NOT NULL, PRIMARY KEY (`id`)) ENGINE = MyISAM;");
    }

    private function update_table_variants()
    {
        if (!$this->check_column('shop_id', 'variants')) {
            $this->db->query("ALTER TABLE __variants ADD shop_id INT(4) NOT NULL");
        }
        if (!$this->check_column('no_bonus', 'variants')) {
            $this->db->query("ALTER TABLE __variants ADD no_bonus TINYINT(1) NOT NULL DEFAULT '0' AFTER `discount_date`");
        }
    }

    private function check_table($table_name)
    {
        $table_name = $this->config->db_prefix . $table_name;

        if (!$this->tables) {
            $this->db->query("SHOW TABLES");
            $this->tables = $this->db->results();
        }

        $find_table = false;
        foreach ($this->tables as $table) {
            $keys = get_object_vars($table);
            foreach ($keys as $name) {
                if ($name == $table_name) $find_table = true;
            }
            if ($find_table) break;
        }

        return $find_table;
    }

    private function check_index($index, $table)
    {
        $this->db->query("SHOW INDEX FROM __{$table}");
        $is = $this->db->results();

        foreach ($is as $i) {
            if ($i->Column_name == $index) return true;
        }

        return false;
    }

    private function check_column($name, $table)
    {
        $this->db->query("DESCRIBE __{$table}");
        $columns = $this->db->results();

        foreach ($columns as $column) {
            if ($column->Field == $name) return true;
        }

        return false;
    }
}

$update = new UpdateDB();
