<?php

require_once 'Fivecms.php';

class Surveys extends Fivecms
{

    /*
     *
     * Функция возвращает пост по его id или url
     * (в зависимости от типа аргумента, int - id, string - url)
     * @param $id id или url поста
     *
     */
    public function get_survey($id)
    {
        if (is_int($id)) {
            $where = $this->db->placehold(' WHERE b.id=? ', intval($id));
        } else {
            $where = $this->db->placehold(' WHERE b.url=? ', $id);
        }

        $query = $this->db->placehold("SELECT * FROM __surveys b $where LIMIT 1");
        if ($this->db->query($query)) {
            return $this->db->result();
        } else {
            return false;
        }
    }

    /*
     *
     * Функция возвращает массив постов, удовлетворяющих фильтру
     * @param $filter
     *
     */
    public function get_surveys($filter = array())
    {
        // По умолчанию
        $limit              = 1000;
        $page               = 1;
        $post_id_filter     = '';
        $category_id_filter = '';
        $visible_filter     = '';
        $user_id_filter     = '';
        $is_actual_filter   = '';
        $keyword_filter     = '';
        $order              = 'b.position DESC';
        $posts              = array();

        if (isset($filter['limit'])) {
            $limit = max(1, intval($filter['limit']));
        }

        if (isset($filter['page'])) {
            $page = max(1, intval($filter['page']));
        }

        if (!empty($filter['id'])) {
            $post_id_filter = $this->db->placehold('AND b.id in(?@)', (array) $filter['id']);
        }

        if (!empty($filter['category_id'])) {
            $category_id_filter = $this->db->placehold('AND b.category_id in(?@)', (array) $filter['category_id']);
        }

        if (isset($filter['visible'])) {
            $visible_filter = $this->db->placehold('AND b.visible = ?', intval($filter['visible']));
        }

        if (!empty($filter['user_id'])) {
            $user_id_filter = $this->db->placehold('AND (SELECT 1 FROM __surveys_results AS sr WHERE sr.survey_id=b.id AND sr.user_id=? LIMIT 1)', intval($filter['user_id']));
        }

        if (!empty($filter['is_actual'])) {
            $is_actual_filter = $this->db->placehold('AND (SELECT count(*)=0 FROM __surveys_results AS sr WHERE sr.survey_id=b.id AND sr.user_id=? LIMIT 1)', intval($filter['is_actual']));
        }

        if (!empty($filter['sort'])) {
            switch ($filter['sort']) {
                case 'position':
                    $order = 'b.position DESC';
                    break;
                case 'name':
                    $order = 'b.name';
                    break;
                case 'date':
                    $order = 'b.date DESC,b.id DESC';
                    break;
            }
        }

        if (!empty($filter['sort_is_actual_for'])) {
            $order = $this->db->placehold('IF((SELECT count(*)=0 FROM __surveys_results AS sr WHERE sr.survey_id=b.id AND sr.user_id=? LIMIT 1), 1, 0) DESC, ', intval($filter['sort_is_actual_for'])) . $order;
        }

        if (!empty($filter['keyword'])) {
            $keywords = explode(' ', $filter['keyword']);
            foreach ($keywords as $keyword) {
                $kw = $this->db->escape(trim($keyword));
                if ($kw !== '') {
                    $keyword_filter .= $this->db->placehold("AND (b.name LIKE '%$kw%' OR b.text LIKE '%$kw%')");
                }

            }
        }

        $sql_limit = $this->db->placehold(' LIMIT ?, ? ', ($page - 1) * $limit, $limit);

        $query = $this->db->placehold("SELECT b.id, b.category_id, b.url, b.name, b.annotation, b.text, 
		                                      b.meta_title, b.meta_keywords, b.meta_description, b.visible,
		                                      b.date, b.position, b.poll_type, b.vote_type, b.points, b.last_modify
		                                      FROM __surveys b
		                                      WHERE 1
		                                      $post_id_filter
		                                      $category_id_filter
		                                      $visible_filter
		                                      $user_id_filter
		                                      $is_actual_filter
		                                      $keyword_filter
		                                      ORDER BY $order $sql_limit");

        $this->db->query($query);
        return $this->db->results();
    }

    /*
     *
     * Функция вычисляет количество постов, удовлетворяющих фильтру
     * @param $filter
     *
     */
    public function count_surveys($filter = array())
    {
        $post_id_filter     = '';
        $category_id_filter = '';
        $visible_filter     = '';
        $user_id_filter     = '';
        $keyword_filter     = '';
        $is_actual_filter   = '';

        if (!empty($filter['id'])) {
            $post_id_filter = $this->db->placehold('AND b.id in(?@)', (array) $filter['id']);
        }

        if (!empty($filter['category_id'])) {
            $category_id_filter = $this->db->placehold('AND b.category_id in(?@)', (array) $filter['category_id']);
        }

        if (isset($filter['visible'])) {
            $visible_filter = $this->db->placehold('AND b.visible = ?', intval($filter['visible']));
        }

        if (!empty($filter['user_id'])) {
            $user_id_filter = $this->db->placehold('AND (SELECT 1 FROM __surveys_results AS sr WHERE sr.survey_id=b.id AND sr.user_id=? LIMIT 1)', intval($filter['user_id']));
        }

        if (!empty($filter['is_actual'])) {
            $is_actual_filter = $this->db->placehold('AND (SELECT count(*)=0 FROM __surveys_results AS sr WHERE sr.survey_id=b.id AND sr.user_id=? LIMIT 1)', intval($filter['is_actual']));
        }

        if (!empty($filter['keyword'])) {
            $keywords = explode(' ', $filter['keyword']);
            foreach ($keywords as $keyword) {
                $kw = $this->db->escape(trim($keyword));
                if ($kw !== '') {
                    $keyword_filter .= $this->db->placehold("AND (b.name LIKE '%$kw%' OR b.text LIKE '%$kw%')");
                }

            }
        }

        $query = "SELECT COUNT(distinct b.id) as count
		          FROM __surveys b
		          WHERE 1
		          $post_id_filter
		          $category_id_filter
		          $visible_filter
		          $user_id_filter
		          $is_actual_filter
		          $keyword_filter";

        if ($this->db->query($query)) {
            return $this->db->result('count');
        } else {
            return false;
        }

    }

    /*
     *
     * Создание поста
     * @param $post
     *
     */
    public function add_survey($post)
    {
        if (!isset($post->date)) {
            $date_query = ', date=NOW()';
        } else {
            $date_query = '';
        }

        $this->db->query($this->db->placehold("INSERT INTO __surveys SET ?% $date_query", $post));
        $id = $this->db->insert_id();
        
        // обновляем last_modify у категории 
        $this->db->query("SELECT category_id FROM __surveys WHERE id=? LIMIT 1", $id);
		$category_id = $this->db->result('category_id');
		$this->db->query("UPDATE __surveys_categories SET last_modify=NOW() WHERE id=? LIMIT 1", intval($category_id));
        // обновляем last_modify у категории end
        
        $this->db->query("UPDATE __surveys SET position=id WHERE id=?", $id);

        return $id;
    }

    /*
     *
     * Обновить пост(ы)
     * @param $post
     *
     */
    public function update_survey($id, $post)
    {
        $query = $this->db->placehold("UPDATE __surveys SET ?% , last_modify=NOW() WHERE id in(?@) LIMIT ?", $post, (array) $id, count((array) $id));
        $this->db->query($query);
        return $id;
    }

    /*
     *
     * Удалить пост
     * @param $id
     *
     */
    public function delete_survey($id)
    {
        if (!empty($id)) {
            $query = $this->db->placehold("DELETE FROM __surveys WHERE id=? LIMIT 1", intval($id));
            if ($this->db->query($query)) {
                $this->db->query("DELETE FROM __surveys_results WHERE survey_id=?", intval($id));
                $this->db->query("DELETE FROM __surveys_fields WHERE survey_id=?", intval($id));

                $query = $this->db->placehold("DELETE FROM __comments WHERE type='survey' AND object_id=? LIMIT 1", intval($id));
                if ($this->db->query($query)) {
                    return true;
                }
            }
        }
        return false;
    }

    /*
     *
     * Следующий пост
     * @param $post
     *
     */
    public function get_next_survey($id)
    {
        $this->db->query("SELECT date FROM __surveys WHERE id=? LIMIT 1", $id);
        $date = $this->db->result('date');
        $this->db->query("SELECT category_id FROM __surveys WHERE id=? LIMIT 1", $id);
        $category_id = $this->db->result('category_id');

        $this->db->query("(SELECT id FROM __surveys WHERE date=? AND id>? AND visible  ORDER BY id limit 1)
		                   UNION
		                  (SELECT id FROM __surveys WHERE date>? AND category_id=? AND visible ORDER BY date, id limit 1)",
            $date, $id, $date, $category_id);
        $next_id = $this->db->result('id');
        if ($next_id) {
            return $this->get_survey(intval($next_id));
        } else {
            return false;
        }
    }

    /*
     *
     * Предыдущий пост
     * @param $post
     *
     */
    public function get_prev_survey($id)
    {
        $this->db->query("SELECT date FROM __surveys WHERE id=? LIMIT 1", $id);
        $date = $this->db->result('date');
        $this->db->query("SELECT category_id FROM __surveys WHERE id=? LIMIT 1", $id);
        $category_id = $this->db->result('category_id');

        $this->db->query("(SELECT id FROM __surveys WHERE date=? AND id<? AND visible ORDER BY id DESC limit 1)
		                   UNION
		                  (SELECT id FROM __surveys WHERE date<? AND category_id=? AND visible ORDER BY date DESC, id DESC limit 1)",
            $date, $id, $date, $category_id);
        $prev_id = $this->db->result('id');
        if ($prev_id) {
            return $this->get_survey(intval($prev_id));
        } else {
            return false;
        }
    }

    public function get_fields($filter = array())
    {
        $fields_id_filter = '';
        $survey_id_filter = '';
        $order            = 'sf.position';

        if (!empty($filter['id'])) {
            $fields_id_filter = $this->db->placehold('AND sf.id IN( ?@ )', (array) $filter['id']);
        }

        if (!empty($filter['survey_id'])) {
            $survey_id_filter = $this->db->placehold('AND sf.survey_id IN( ?@ )', (array) $filter['survey_id']);
        }

        $query = $this->db->placehold("SELECT sf.*, ( SELECT COUNT( sr.id ) FROM __surveys_results AS sr WHERE sf.id = sr.field_id LIMIT 1) AS count
                                      FROM __surveys_fields AS sf
                                      
                                      WHERE 1
										$fields_id_filter
										$survey_id_filter
                                      ORDER BY $order");
        $this->db->query($query);
        return $this->db->results();
    }
    public function get_field($id)
    {
        if (empty($id)) {
            return false;
        }

        $query = $this->db->placehold("SELECT sf.*
                                        FROM __surveys_fields AS sf
                                        WHERE sf.id=?
                                        LIMIT 1", intval($id));
 
        $this->db->query($query);
        return $this->db->result();
    }
    public function update_field($id, $field)
    {
        $query = $this->db->placehold('UPDATE __surveys_fields SET ?% WHERE id=? LIMIT 1', $field, intval($id));
        $this->db->query($query);
        return $id;
    }

    public function add_field($field)
    {
        $query = $this->db->placehold('INSERT INTO __surveys_fields SET ?%', $field);
        $this->db->query($query);
        
        return $this->db->insert_id();
    }

    public function delete_field($id)
    {
        if (!empty($id)) {
            $this->db->query('DELETE FROM __surveys_fields WHERE id = ? LIMIT 1', intval($id));
        }
    }
}
