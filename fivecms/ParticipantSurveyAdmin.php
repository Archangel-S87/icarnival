<?PHP

require_once 'api/Fivecms.php';

class ParticipantSurveyAdmin extends Fivecms
{
    public function fetch()
    {
        $post->id = $this->request->get('id', 'integer');
        $post     = $this->surveys->get_survey(intval($post->id));
        if(empty($post)) {
        	return false;
        }
	 
	    $images = $this->surveys->get_images(array('post_id' => $post->id));
	    $fields = $this->surveys->get_fields(array('survey_id' => $post->id));
	    
        $this->design->assign('post', $post);
        $this->design->assign('images', $images);
        $this->design->assign('fields', $fields);

        $rows = array();
        $this->db->query("SELECT sr.user_id, u.name, u.email, u.phone, u.balance, sr.ts, sf.name AS value
                         FROM __surveys_results AS sr 
                         INNER JOIN __users AS u ON sr.user_id = u.id
                         LEFT JOIN __surveys_fields AS sf ON sr.field_id = sf.id
                         WHERE sr.survey_id=?
                         GROUP BY sr.id
                         ", $post->id);
        $rows = $this->db->results();

        $this->design->assign('rows', $rows);
        return $this->design->fetch('participant_survey.tpl');
    }
}
