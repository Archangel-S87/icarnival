{* Вкладки *}
{capture name=tabs}
	{if in_array('surveys_categories', $manager->permissions)}<li><a href="{url module=SurveysCategoriesAdmin page=null keyword=null}">{$tr->surveys_categories|escape}</a></li>{/if}
	<li><a href="index.php?module=SurveysAdmin">{$tr->surveys|escape}</a></li>
	<li class="active"><a href="index.php?module=SurveysAdmin">{$tr->participants|escape}</a></li>
{/capture}
{$meta_title = "{$tr->participants|escape} - {$post->name}" scope=root}
<h1>{$post->name|escape}</h1>

{$poll_types = [ 1=>$tr->vote, 2=>$tr->done_task]}
{$vote_types = [ 1=>$tr->one_variant, 2=>$tr->several_variants, 3=>$tr->stared, 4=>$tr->promo_code]}

<div class="participants_annotation">{$post->annotation}</div>
<div style="display:table;clear:both;margin-bottom:15px;">{$tr->take_part|escape}:</div>
<table id="participants_table" style="width: 100%;">
	<thead>
		<tr>
			<th>id</th>
			<th>Email</th>
			<th>{$tr->person_name|escape}</th>
			<th>{$tr->phone|escape}</th>
			<th>{$tr->points|escape}</th>
			<th>{$tr->date|escape}</th>
			<th>{$tr->answer_type|escape}: {$vote_types[$post->vote_type]})</th>
		</tr>
	</thead>
	<tbody>
		{foreach $rows as $row}
		<tr>
			<td><a href="index.php?module=UserAdmin&id={$row->user_id}">{$row->user_id}</a></td>
			<td>{$row->email}</td>
			<td>{$row->name}</td>
			<td style="white-space:nowrap;">{$row->phone}</td>
			<td>{$row->balance|round}</td>
			<td>{$row->ts|date}{* {$row->ts|time}*}</td>
			<td>{$row->value}</td>
		</tr>
		{/foreach}
	</tbody>
</table>
