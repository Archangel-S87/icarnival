<style>
	{literal}
		.message {padding:8px 8px 3px 8px;}
		p {margin:0 0 10px 0;}
		.unsubscribe {padding:8px 8px 3px 8px;background-color:#efefef;display:table;width:100%;font-size:12px; color:#776b6b;border-radius:5px;}
		.unsubscribe p {margin:0 0 5px 0;}
		.unsubscribe a {font-size:12px; color:#776b6b;}
	{/literal}
</style>

<div class="message">
{if !empty($name)}
<p>{if $name|count_words > 2}{$name|escape|strstr:' ':false|ltrim:' '}{elseif $name|count_words == 2}{$name|escape|strstr:' ':true|rtrim:' '}{elseif $name|count_words == 1}{$name|escape}{/if}, {$settings->mails_hello}</p>
{else}
<p>{$settings->mails_hello_noname}</p>
{/if}
{if !empty($message)}{$message}{/if}
</div>
<br />
<div class="unsubscribe">
<p>Вы получили это письмо, т.к. интересовались товарами/услугами сайта {$settings->site_name}</p>
<p>В любой момент вы можете отписаться, пройдя по ссылке:</p>
<p><a href="{$config->root_url}/user/login?unsubscribe={$mail}">{$config->root_url}/user/login?unsubscribe={$mail}</a></p>
</div>

