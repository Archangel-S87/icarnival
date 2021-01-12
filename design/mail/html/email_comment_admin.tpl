{if $comment->approved}
{$subject="Новый комментарий от `$comment->name|escape`" scope=root}
{else}
{$subject="Комментарий от `$comment->name|escape` ожидает одобрения" scope=root}
{/if}
{if $comment->approved}
<h3 style="font-weight:normal;font-family:arial;"><a href="{$config->root_url}/fivecms/index.php?module=CommentsAdmin">Новый комментарий</a> от {$comment->name|escape}</h3>
{else}
<h3 style="font-weight:normal;font-family:arial;"><a href="{$config->root_url}/fivecms/index.php?module=CommentsAdmin">Комментарий</a> от {$comment->name|escape} ожидает одобрения</h3>
{/if}

<table cellpadding="6" cellspacing="0" style="border-collapse: collapse;">
  <tr>
    <td style="padding:6px; width:170; background-color:#f0f0f0; border:1px solid #e0e0e0;font-family:arial;">
      Имя
    </td>
    <td style="padding:6px; width:330; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;">
      {$comment->name|escape}
    </td>
  </tr>
  <tr>
    <td style="padding:6px; background-color:#f0f0f0; border:1px solid #e0e0e0;font-family:arial;">
      Комментарий
    </td>
    <td style="padding:6px; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;">
      {$comment->text|escape|nl2br}
    </td>
  </tr>
  <tr>
    <td style="padding:6px; background-color:#f0f0f0; border:1px solid #e0e0e0;font-family:arial;">
      Время
    </td>
    <td style="padding:6px; width:170; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;">
      {$comment->date|date} {$comment->date|time}
    </td>
  </tr>
  <tr>
    <td style="padding:6px; width:170; background-color:#f0f0f0; border:1px solid #e0e0e0;font-family:arial;">
      Статус
    </td>
    <td style="padding:6px; width:330; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;">
      {if $comment->approved}
        Одобрен    
      {else}
        Ожидает одобрения
      {/if}
    </td>
  </tr>
 <tr>
    <td style="padding:6px; width:170; background-color:#f0f0f0; border:1px solid #e0e0e0;font-family:arial;">
      {if $comment->type == 'product'}К товару{/if}
      {if $comment->type == 'blog'}К записи{/if}
    </td>
    <td style="padding:6px; width:330; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;">
      {if $comment->type == 'product'}<a target="_blank" href="{$config->root_url}/products/{$comment->product->url}#comment_{$comment->id}">{$comment->product->name|escape}</a>{/if}
      {if $comment->type == 'blog'}<a target="_blank" href="{$config->root_url}/blog/{$comment->post->url}#comment_{$comment->id}">{$comment->post->name|escape}</a>{/if}
    </td>
  </tr>
</table>
