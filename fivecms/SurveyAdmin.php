<?PHP

require_once 'api/Fivecms.php';

class SurveyAdmin extends Fivecms
{
    public function fetch()
    {
        $images = array();
        $fields = array();

        if ($this->request->method('post')) {
            $post->id   = $this->request->post('id', 'integer');
            $post->name = $this->request->post('name');
            $post->date = date('Y-m-d', strtotime($this->request->post('date')));

            $post->visible     = $this->request->post('visible', 'boolean');
            $post->category_id = $this->request->post('category_id', 'integer');

            $post->url              = $this->request->post('url', 'string');
            $post->meta_title       = $this->request->post('meta_title');
            $post->meta_keywords    = $this->request->post('meta_keywords');
            $post->meta_description = $this->request->post('meta_description');

            $post->annotation = $this->request->post('annotation');
            $post->text       = $this->request->post('body');
            $post->poll_type  = $this->request->post('poll_type');
            $post->vote_type  = $this->request->post('vote_type');
            $post->points     = $this->request->post('points');

            if ($this->request->post('fields')) {
                foreach ($this->request->post('fields') as $n => $va) {
                    foreach ($va as $i => $v) {
                        if (empty($fields[$i])) {
                            $fields[$i] = new \stdClass();
                        }
                        $fields[$i]->$n = $v;
                    }
                }
            }

            if (($a = $this->surveys->get_survey($post->url)) && $a->id != $post->id) {
                $this->design->assign('message_error', 'url_exists');
                $images = $this->surveys->get_images(array('post_id' => $post->id));
            } else {
                if (empty($post->id)) {
                    $post->id = $this->surveys->add_survey($post);
                    $post     = $this->surveys->get_survey($post->id);
                    $this->design->assign('message_success', 'added');
                } else {
                    $this->surveys->update_survey($post->id, $post);
                    $post = $this->surveys->get_survey($post->id);
                    $this->design->assign('message_success', 'updated');
                }

                 if (is_array($fields)) {
                 	$fields_ids = array();

                    foreach ($fields as $index=>&$field) {

                        if (!empty($field->id)) {
                            $this->surveys->update_field($field->id, $field);
                        } else {
                            $field->survey_id = $post->id;
                          
                            $field->id = $this->surveys->add_field($field);
                        }
                        $field = $this->surveys->get_field($field->id);
                        
                        if (!empty($field->id)) {
                             $fields_ids[] = $field->id;
                        }
                    }

                    // Удалить непереданные варианты
                    $current_fields = $this->surveys->get_fields(array('survey_id'=>$post->id));
                    foreach ($current_fields as $current_field) {
                        if (!in_array($current_field->id, $fields_ids)) {
                            $this->surveys->delete_field($current_field->id);
                        }
                    }

                    // Отсортировать 
                    asort($fields_ids);
                    $i = 0;
                    foreach ($fields_ids as $fields_id) {
                        $this->surveys->update_field($fields_ids[$i], array('position'=>$fields_id));
                        $i++;
                    }
                 	
                 }



                // Óäàëåíèå èçîáðàæåíèé
                $images         = (array) $this->request->post('images');
                $current_images = $this->surveys->get_images(array('post_id' => $post->id));
                foreach ($current_images as $image) {
                    if (!in_array($image->id, $images)) {
                        $this->surveys->delete_image($image->id);
                    }

                }

                // Ïîðÿäîê èçîáðàæåíèé
                if ($images = $this->request->post('images')) {
                    $i = 0;
                    foreach ($images as $id) {
                        $this->surveys->update_image($id, array('position' => $i));
                        $i++;
                    }
                }
                // Çàãðóçêà èçîáðàæåíèé
                if ($images = $this->request->files('images')) {
                    for ($i = 0; $i < count($images['name']); $i++) {
                        if ($image_name = $this->image->upload_image($images['tmp_name'][$i], $images['name'][$i])) {
                            $this->surveys->add_image($post->id, $image_name);
                        } else {
                            $this->design->assign('error', 'error uploading image');
                        }
                    }
                }
                $images = $this->surveys->get_images(array('post_id' => $post->id));

            }
        } else {
            $post->id = $this->request->get('id', 'integer');
            $post     = $this->surveys->get_survey(intval($post->id));

            if ($post && $post->id) {

                $images = $this->surveys->get_images(array('post_id' => $post->id));
                $fields = $this->surveys->get_fields(array('survey_id' => $post->id));
            }

        }

        if (empty($post->date)) {
            $post->date = date($this->settings->date_format, time());
        }

        $this->design->assign('post_images', $images);

        $this->design->assign('post', $post);
        $this->design->assign('fields', $fields);

        // ÐšÐ°Ñ‚ÐµÐ³Ð¾Ñ€Ð¸Ð¸
        $surveys_categories = $this->surveys_categories->get_surveys_categories_tree();
        $this->design->assign('surveys_categories', $surveys_categories);

        return $this->design->fetch('survey.tpl');
    }
}
