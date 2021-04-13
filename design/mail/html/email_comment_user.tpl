{$subject="Администратор магазина оставил ответ на Ваш комментарий" scope=root}

<h3 style="font-weight:normal;font-family:arial;">Ваш комментарий получил ответ администратора</h3>

<br />На ваш комментарий
{if $comment->type == 'product'}
к товару <a target="_blank" href="{$config->root_url}/products/{$comment->product->url}#comment_{$comment->id}">{$comment->product->name|escape}</a>
{elseif $comment->type == 'blog'}
к статье <a target="_blank" href="{$config->root_url}/blog/{$comment->post->url}#comment_{$comment->id}">{$comment->post->name|escape}</a>
{/if}
от {$comment->date|date} {$comment->date|time} с текстом:<br /><br />
"{$comment->text|escape|nl2br}"<br /><br />
получен официальный ответ:<br /><br />
{$comment->otvet|escape|nl2br}<br /><br />
Посмотреть
{if $comment->type == 'product'}
<a target="_blank" href="{$config->root_url}/products/{$comment->product->url}#comment_{$comment->id}">комментарий к товару</a>
{elseif $comment->type == 'blog'}
<a target="_blank" href="{$config->root_url}/blog/{$comment->post->url}#comment_{$comment->id}">комментарий к статье</a>
{/if}
или перейти к "<a href="{$config->root_url}">{$settings->site_name|escape}</a>"
