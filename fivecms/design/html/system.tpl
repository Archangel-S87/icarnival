{capture name=tabs}
	{if in_array('settings', $manager->permissions)}<li><a href="index.php?module=SettingsAdmin">{$tr->settings_main|escape}</a></li>{/if}
	{if in_array('settings', $manager->permissions)}<li><a href="index.php?module=SetCatAdmin">{$tr->settings_cat|escape}</a></li>{/if}
	{if in_array('settings', $manager->permissions)}<li><a href="index.php?module=SetModAdmin">{$tr->settings_modules|escape}</a></li>{/if}
	<li class="active"><a href="index.php?module=MobsetAdmin">{$tr->system_title|escape}</a></li>
{/capture}

{$meta_title = $tr->system_title scope=root}

    <div id="onecolumn" style="margin-top:10px;">
        <div class="boxed fn_toggle_wrap">
            {*Параметры элемента*}
            <div class="toggle_body_wrap on fn_card">
               <div class="row">
                   {if $php_version}
                       <div class="col-lg-4">
                           <div class="banner_card">
                               <div class="system_header">
                                   <span class="font-weight-bold">PHP Version</span>
                               </div>
                               <div class="banner_card_block">
                                   <div class="system_information" style="font-size:18px;font-weight:700;">
                                    	{$php_version|escape}
                                   </div>
                               </div>
                           </div>
                       </div>
                   {/if}
                   {if $sql_info}
                       <div class="col-lg-4">
                           <div class="banner_card">
                               <div class="system_header">
                                   <span class="font-weight-bold">SQL</span>
                               </div>
                               <div class="banner_card_block">
                                   <div class="system_information">
                                       {foreach $sql_info as $sql_param => $sql_ver}
                                           <div>
                                               <span>{$sql_param|escape}: </span>
                                               <span>{$sql_ver|escape}</span>
                                           </div>
                                       {/foreach}
                                   </div>
                               </div>
                           </div>
                       </div>
                   {/if}
                   
                	{if $server_ip}
                       <div class="col-lg-4">
                           <div class="banner_card">
                               <div class="system_header">
                                   <span class="font-weight-bold">{$tr->system_server_ip}</span>
                               </div>
                               <div class="banner_card_block">
                                   <div class="system_information" style="font-size:18px;font-weight:700;">
                                    	{$server_ip|escape}
                                   </div>
                               </div>
                           </div>
                       </div>
                   {/if}

                   {if $ini_params}
                       <div class="col-lg-4">
                           <div class="banner_card">
                               <div class="system_header">
                                   <span class="font-weight-bold">INI params</span>
                               </div>
                               <div class="banner_card_block">
                                   <div class="system_information">
                                       {foreach $ini_params as $param_name => $param_value}
                                           <div>
                                               <span>{$param_name|escape}: </span>
                                               <span>{$param_value|escape|number_format:0:'.':' '}</span>
                                           </div>
                                       {/foreach}
                                   </div>
                               </div>
                           </div>
                       </div>
                   {/if}
                   
                   {if $current_locale}
                       <div class="col-lg-4">
                           <div class="banner_card">
                               <div class="system_header">
                                   <span class="font-weight-bold">Locale</span>
                               </div>
                               <div class="banner_card_block">
                                   <div class="system_information">
                                        <span style="font-size:18px;font-weight:700;">{$current_locale|escape}</span>
                                   </div>
                               </div>
                           </div>
                       </div>
                   {/if}

                   <div>
                       <div class="boxed boxed_attention">
                           <div class="text_box">
                               <div class="mb-1">
                                   <h2>{$tr->system_message_1|escape}</h2>
                               </div>
                               <div>
                                   <ul class="ini_params">
                                       <li>display_errors - {$tr->system_display_errors|escape}</li>
                                       <li>memory_limit - {$tr->system_memory_limit|escape}</li>
                                       <li>post_max_size - {$tr->system_post_max_size|escape}</li>
                                       <li>max_input_time - {$tr->system_max_input_time|escape}</li>
                                       <li>max_file_uploads - {$tr->system_max_file_uploads|escape}</li>
                                       <li>max_execution_time - {$tr->system_max_execution_time|escape}</li>
                                       <li>upload_max_filesize - {$tr->system_upload_max_filesize|escape}</li>
                                       <li>max_input_vars - {$tr->system_max_input_vars|escape}</li>
                                   </ul>
                               </div>
                           </div>
                       </div>
                   </div>

                   {if $all_extensions}
                       <div>
                           <div class="banner_card">
                               <div class="system_header">
                                   <span class="font-weight-bold">{$tr->system_message_3|escape}</span>
                               </div>
                               <div class="banner_card_block">
                                   <div class="system_information clearfix">
                                       {foreach $all_extensions as $ext_val}
                                           <div class="col_extentions">
                                               <div>
                                                   <span {if in_array($ext_val|lower,['curl','memcache','memcached','json','php_zip','zip','gd','mysqli','imagick','openssl','zlib','xmlreader','xmlwriter']) }style="font-weight:700;font-size:16px;"{/if}>{$ext_val|escape}{assign var='req_'|cat:$ext_val|lower value="1"}</span>
                                               </div>
                                           </div>
                                       {/foreach}
                                   </div>
                               </div>
                           </div>
                       </div>
                   {/if}
                   <div>
                       <div class="boxed boxed_attention">
                           <div class="text_box">
                               <div class="mb-1">
                                   <h2>{$tr->system_message_2|escape}:</h2>
                               </div>
                               <div>
                                   <ul class="ini_params">
                                       {if empty($req_imagick) && empty($req_gd)}<li>imagick {$tr->or|escape} gd</li>{$required_extentions = 1}{/if}
                                       {if empty($req_json)}<li>json</li>{$required_extentions = 1}{/if}
                                       {if empty($req_memcache) && empty($req_memcached)}<li>memcache {$tr->or|escape} memcached</li>{$required_extentions = 1}{/if}
                                       {if empty($req_mysqli)}<li>mysqli</li>{$required_extentions = 1}{/if}
                                       {if empty($req_curl)}<li>curl</li>{$required_extentions = 1}{/if}
                                       {if empty($req_openssl)}<li>openssl</li>{$required_extentions = 1}{/if}
                                       {if empty($req_xmlreader)}<li>XMLreader</li>{$required_extentions = 1}{/if}
                                       {if empty($req_xmlwriter)}<li>XMLwriter</li>{$required_extentions = 1}{/if}
                                       {if empty($req_zip)}<li>zip</li>{$required_extentions = 1}{/if}
                                       {if empty($req_zlib)}<li>zlib</li>{$required_extentions = 1}{/if}
                                   </ul>
                                   {if empty($required_extentions)}<p style="margin-bottom:15px;">{$tr->system_message_4}</p>{/if}
                               </div>
                           </div>
                       </div>
                   </div>
               </div>
            </div>
        </div>
    </div>

{literal}
<style>
.col-lg-4 {width:30%;min-width:290px;display:inline-block;vertical-align:top;margin-right:10px;}
.col_extentions {width:22%;min-width:165px;display:inline-block;vertical-align:top;margin-right:10px;}
.banner_card{
    margin-bottom: 20px;
    position: relative;
    display: block;
    background-color: #fff;border: 1px solid #ccc;
    border-radius:10px;
    overflow:hidden;
}

.banner_card_block{
    padding: 10px;
}
.system_header{
    color: #fff;
    background-color: #5c6590;
    font-weight: 700;
    text-transform: uppercase;
    font-size: 14px;
    padding: 8px 15px;
}
.system_information{
    min-height: 35px;
    text-align: left;
}
.system_information {line-height:20px;}
.ini_params {margin-bottom:20px;}
.ini_params li{margin-bottom:5px;}
</style>
{/literal}