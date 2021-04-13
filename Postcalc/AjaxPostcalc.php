<?php

require_once '../api/Fivecms.php';
require_once 'Postcalc.php';

class AjaxPostcalc extends Fivecms
{
    /**
     * @var Postcalc
     */
    private $postcalc;

    /**
     * @var string
     */
    private $action = '';

    /**
     * @var mixed
     */
    private $response;

    public function __construct()
    {
        parent::__construct();

        $delivery_id = $this->request->get('delivery_id', 'integer');

        $delivery = $this->delivery->get_delivery($delivery_id);
        if (!$delivery) {
            $this->error('Не определён способ доставки');
        }
        $this->action = $this->request->get('action', 'string');
        if (!$this->action || !method_exists($this, $this->action)) {
            $this->error('Не определён метод');
        }

        $options = json_encode($delivery->option1);
        $this->postcalc = new Postcalc($options);

        // запуск метода
        call_user_func([$this, $this->action]);

        $this->response($this->response);
    }

    public function autocomplete()
    {
        $query = $this->request->get('query', 'string');
        $suggestions = $this->postcalc->autocomplete($query);
        $this->response = ['suggestions' => $suggestions, 'query' => $query];
    }

    /**
     * @param string $error
     */
    private function error($error)
    {
        $this->response(['error' => $error]);
    }

    /**
     * @param mixed $data
     */
    private function response($data = [])
    {
        header("Content-type: application/json; charset=UTF-8");
        header("Cache-Control: must-revalidate");
        header("Pragma: no-cache");
        header("Expires: -1");
        print json_encode($data);
        die();
    }
}

$AjaxPostcalc = new AjaxPostcalc();
