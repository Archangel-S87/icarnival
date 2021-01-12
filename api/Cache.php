<?php

/**
 * Класс обертка memcached 
 */

require_once('Fivecms.php');

class Cache extends Fivecms
{
    public function __construct()
    {
        $this->init();
    }

    public $mem;

	private $configuration = [
        'host' => '127.0.0.1',
        'port' => 11211,
        'lifeTimeCache' => 86400,
    ];
    /**
     * Флаг типа используемого расширения PHP
     * True - memcache
     * False - memcached
     */
    private $isMemcached = false;

    public function init()
    {
		if($this->settings->cache_type == 1) 
			$cache_type = 'memcached';
		else
    		$cache_type = 'memcache';
    		
        $this->isMemcached = $this->isMemcachedUse();
        if (!extension_loaded($cache_type)) {
            throw new Exception("Php extension {$cache_type} not found. Please install the memcache extension.");
        }
        $this->isMemcached ? $this->mem = new Memcached() : $this->mem = new Memcache();
        $this->mem->addServer($this->configuration['host'], $this->configuration['port']);
    }

    public function get($stringKey)
    {
        if($this->mem != null)
            $result = $this->mem->get($this->stringToHash($stringKey));
		
        if(!empty($result))
            return $result;
        else
            return false;
    }

    /**
     * Помещает значение в кеш по ключу
     * @param string $stringKey ключ
     * @param $value Результирующий набор (набор данных, которые необходимо положить в кеш)
     * @param $lifeCache время жизни кеша
     */
    public function set($stringKey, $value)
    {
    	if($this->settings->cache_time > 0)
    		$lifeCache = $this->settings->cache_time;
    	else
    		$lifeCache = $this->configuration['lifeTimeCache'];
    		
        if ($this->isMemcached) {
            $this->mem->set($this->stringToHash($stringKey), $value, $lifeCache);
        } else {
            $this->mem->set($this->stringToHash($stringKey), $value, 0, $lifeCache); // Для сжатия замените 0 на MEMCACHE_COMPRESSED
        }
    }

    /**
     * Удаляет значение из памяти по ключу
     * @var string $stringKey attribute labels
     */
    public function del($stringKey)
    {
        $this->mem->delete($this->stringToHash($stringKey));
    }

    /**
     * Аннулирует все существующие записи в кеше
     * @var integer $delay Период времени, по истечению которого произвести полную очистку кеша
     * @return true or false
     */
    public function clearall($delay = 0)
    {
        $this->mem->flush();
    }

    /**
     * Из обычной строки в md5 hash
     * @var string $stringKey - Ключ
     */
    private function stringToHash($stringKey)
    {
    	// уникализируем хэш по домену
    	$stringKey = $this->config->root_url.$stringKey;
    	if ($this->isMemcached)
        	return md5('key'.$stringKey);
		else
        	return md5($stringKey);
    }
    
    /**
     * Проверяет используется ли PHP расширение memcached
     */
    private function isMemcachedUse()
    {
        if($this->settings->cache_type == 1)
            return true;
    }
}
