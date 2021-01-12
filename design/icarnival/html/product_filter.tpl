{if $products|count>0}
                      <div class="col-item"><b>Сортировать по:</b></div>
                      <div class="col-item"> 
                        <select class="form__input form__input--square form__input--size-40"  onchange="clicker(this);">
									<option value="{url sort=position page=null}" {if $sort=='position'}selected{/if}>порядку</option>
									<option value="{url sort=priceup page=null}" {if $sort=='priceup'}selected{/if}>цене &#8593;</option>
									<option value="{url sort=pricedown page=null}" {if $sort=='pricedown'}selected{/if}>цене &#8595;</option>
									<option value="{url sort=name page=null}" {if $sort=='name'}selected{/if}>названию</option>
									<option value="{url sort=date page=null}" {if $sort=='date'}selected{/if}>дате</option>
									<option value="{url sort=stock page=null}" {if $sort=='stock'}selected{/if}>остатку</option>
									<option value="{url sort=views page=null}" {if $sort=='views'}selected{/if}>популярности</option>
									<option value="{url sort=rating page=null}" {if $sort=='rating'}selected{/if}>рейтингу</option>
                        </select>
                      </div>		
{/if}
