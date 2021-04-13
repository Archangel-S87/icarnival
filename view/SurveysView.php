<?PHP

require_once 'View.php';

class SurveysView extends View
{
    public function fetch()
    {
        $url = $this->request->get('survey_url', 'string');
        
        // Surveys categories
		$this->design->assign('surveys_categories', $this->surveys_categories->get_surveys_categories_tree());

        // Если указан адрес поста,
        if (!empty($url)) {
            return $this->fetch_survey($url);
        } else {
            return $this->fetch_surveys($url);
        }
    }

    // стр голосования
    private function fetch_survey($url)
    {
        // Выбираем пост из базы
        $survey = $this->surveys->get_survey($url);

        // Если не найден - ошибка
        if (!$survey || (!$survey->visible && empty($_SESSION['admin']))) {
            return false;
        }
        
        // Выводим текущую категорию
		$cat = $this->surveys_categories->get_surveys_category(intval($survey->category_id));
		$this->design->assign('category', $cat);
        
        $survey->fields = array();
        foreach ($this->surveys->get_fields(array('survey_id' => $survey->id)) as $field) {
            $survey->fields[$field->id] = $field;
        }

        $this->db->query("SELECT count(*)=0 as is_actual FROM __surveys_results WHERE user_id=? AND survey_id=? LIMIT 1", $this->user->id, $survey->id);
        $survey->is_actual = $this->db->result('is_actual');

        if ($this->request->method('post') && $survey->is_actual) {

            if ($this->request->post('code_submit')) {
                // Промо код
                $pcode = trim($this->request->post('pcode'));

                // нужно его проверить в БД
                $this->db->query("SELECT id FROM __surveys_fields WHERE survey_id=? AND name=? LIMIT 1", $survey->id, $pcode);
                $field_id = $this->db->result('id');

                if (empty($pcode)) {
                    $this->design->assign('error', 'empty_pcode');
                } elseif ($field_id) {

                    $this->user->balance += $survey->points;
                    // обновляем баланс
                    $this->users->update_user($this->user->id, array('balance' => $this->user->balance));

                    // запоминаем что проголосовал
                    $this->db->query("INSERT INTO __surveys_results SET ?%", array('user_id' => $this->user->id, 'survey_id' => $survey->id, 'field_id' => $field_id));

                    $this->design->assign('error', 'success_code');

                } else {
                    $this->design->assign('error', 'error_code');
                }

            } elseif ($this->request->post('vote_submit')) {

                if ($poll = $this->request->post('radio', 'integer')) {
                    $this->user->balance += $survey->points;
                    // обновляем баланс
                    $this->users->update_user($this->user->id, array('balance' => $this->user->balance));
                    // запоминаем что проголосовал
                    $this->db->query("INSERT INTO __surveys_results SET ?%", array('user_id' => $this->user->id, 'survey_id' => $survey->id, 'field_id' => $poll));
                    $this->design->assign('error', 'success_vote');
                } elseif ($polls = $this->request->post('checkbox')) {
                    $this->user->balance += $survey->points;
                    // обновляем баланс
                    $this->users->update_user($this->user->id, array('balance' => $this->user->balance));
                    foreach ($polls as $poll) {
                        // запоминаем что проголосовал
                        $this->db->query("INSERT INTO __surveys_results SET ?%", array('user_id' => $this->user->id, 'survey_id' => $survey->id, 'field_id' => $poll));
                    }
                    $this->design->assign('error', 'success_vote');
                } else {
                    $this->design->assign('error', 'empty_poll');
                }
            } elseif ($this->request->post('starts_submit')) {
            	if ($stars = $this->request->post('stars', 'integer')) {
            		
                    $this->user->balance += $survey->points;
                    // обновляем баланс
                    $this->users->update_user($this->user->id, array('balance' => $this->user->balance));

                    $this->db->query("INSERT INTO __surveys_results SET ?%", array('user_id' => $this->user->id, 'survey_id' => $survey->id, 'field_id' => $stars));
                    $this->design->assign('error', 'success_vote');
                } else {
                    $this->design->assign('error', 'empty_stars');
                }
            }

        }

        $this->design->assign('survey', $survey);

        // Мета-теги
        $this->design->assign('meta_title', $survey->meta_title);
        $this->design->assign('meta_keywords', $survey->meta_keywords);
        $this->design->assign('meta_description', $survey->meta_description);
        
		$this->setHeaderLastModify($survey->last_modify, 2592000);  // expires 2592000 - month
		
        return $this->design->fetch('survey.tpl');
    }

    // Отображение списка постов
    private function fetch_surveys()
    {

        $filter   = array();

		//is actual hide
        //$filter['is_actual'] = $this->user->id;
		//is actual end

        // GET-Параметры
        $category_url = $this->request->get('category', 'string');

        // Выберем текущую категорию
        if (!empty($category_url)) {
            $category = $this->surveys_categories->get_surveys_category((string) $category_url);
            if (empty($category) || (!$category->visible && empty($_SESSION['admin']))) {
                return false;
            }

            $this->design->assign('category', $category);

            $filter['category_id'] = $category->children;
        }

        $keyword = $this->request->get('keyword', 'string');
        if (!empty($keyword)) {
            $this->design->assign('keyword', $keyword);
            $filter['keyword'] = $keyword;
        }

		//is actual sort
		if(isset($this->user->id))
			$filter['sort_is_actual_for'] = $this->user->id;
		//is actual end

        // Сортировка товаров, сохраняем в сесси, чтобы текущая сортировка оставалась для всего сайта
        if ($sort = $this->request->get('surveys_sort', 'string')) {
            $_SESSION['surveys_sort'] = $sort;
        }

        if (!empty($_SESSION['surveys_sort'])) {
            $filter['sort'] = $_SESSION['surveys_sort'];
        } else {
            $filter['sort'] = 'position';
        }

        $this->design->assign('sort', $filter['sort']);

        // Количество постов на 1 странице
        if($this->design->is_mobile_browser())
			$items_per_page = $this->settings->mob_products_num;
		else
			$items_per_page = 20;

        // Выбираем только видимые посты
        $filter['visible'] = 1;

        // Текущая страница в постраничном выводе
        $current_page = $this->request->get('page', 'integer');

        // Если не задана, то равна 1
        $current_page = max(1, $current_page);
        $this->design->assign('current_page_num', $current_page);

        // Вычисляем количество страниц
        $posts_count = $this->surveys->count_surveys($filter);

        // Показать все страницы сразу
        if ($this->request->get('page') == 'all') {
            $items_per_page = $posts_count;
        }

        $pages_num = ceil($posts_count / $items_per_page);
        $this->design->assign('total_pages_num', $pages_num);
        $this->design->assign('total_posts_num', $posts_count);

        $filter['page']  = $current_page;
        $filter['limit'] = $items_per_page;

        // Выбираем статьи из базы
        $posts = $this->surveys->get_surveys($filter);
		
		//is actual 
		if(isset($this->user->id)){
			foreach ($posts as $post) {
				$this->db->query("SELECT count(*)=0 as is_actual FROM __surveys_results WHERE user_id=? AND survey_id=? LIMIT 1", $this->user->id, $post->id);
				$post->is_actual = $this->db->result('is_actual');
			}
		}
		//is actual end

        // Передаем в шаблон
        $this->design->assign('posts', $posts);

        // Устанавливаем мета-теги в зависимости от запроса
        if (isset($this->page->url) && $this->page->url == 'surveys') 
        {
            $this->design->assign('meta_title', $this->page->meta_title);
            $this->design->assign('meta_keywords', $this->page->meta_keywords);
            $this->design->assign('meta_description', $this->page->meta_description);

			$this->db->query("SELECT c.last_modify FROM __surveys_categories c");
			$last_modify = $this->db->results('last_modify');
			$last_modify[] = $this->page->last_modify;
			$this->setHeaderLastModify(max($last_modify), 604800);  // expires 604800 - week
		}
		elseif($this->page)
		{
			$this->design->assign('meta_title', $this->page->meta_title);
			$this->design->assign('meta_keywords', $this->page->meta_keywords);
			$this->design->assign('meta_description', $this->page->meta_description);
			$this->setHeaderLastModify($this->page->last_modify, 2592000); // expires 2592000 - month
        } 
        elseif (isset($category)) {
            $this->design->assign('meta_title', $category->meta_title);
            $this->design->assign('meta_keywords', $category->meta_keywords);
            $this->design->assign('meta_description', $category->meta_description);
            $this->setHeaderLastModify($category->last_modify, 604800);  // expires 604800 - week
        }
		
        $body = $this->design->fetch('surveys.tpl');

        return $body;
    }
}
