{$meta_title = "robots.txt" scope=root}

<h1>robots.txt</h1>

{capture name=tabs}
	{if in_array('promo', $manager->permissions)}<li><a href="index.php?module=PromoAdmin">{$tr->seo|escape}</a></li>{/if}
	{if in_array('products', $manager->permissions)}
	<li><a href="index.php?module=MetadataPagesAdmin">{$tr->md_redirect|escape}</a></li>
	<li><a href="index.php?module=LinksAdmin">{$tr->metadata_filter|escape}</a></li>
	{/if}
	<li class="active"><a href="index.php?module=RobotsAdmin">robots.txt</a></li>
{/capture}

{if isset($message_error)}
<!-- Системное сообщение -->
<div class="message message_error">
	<span class="text">
	{if $message_error == 'write_error'}{$tr->write_error|escape}
	{else}{$message_error}{/if}
	</span>
</div>
<!-- Системное сообщение (The End)-->
{/if}

{if isset($message_success)}
<!-- Системное сообщение -->
<div class="message message_success">
	<span class="text">
	{if $message_success == 'updated'}{$tr->updated|escape}
	{else}{$message_success}{/if}
	</span>
</div>
<!-- Системное сообщение (The End)-->
{/if}

<div class="row">
    <div class="col-lg-12 col-md-12">
        <div class="boxed fn_toggle_wrap min_height_230px">
            <form method="post">
                <input type=hidden name="session_id" value="{$smarty.session.id}">
                <textarea id="robots" class="settings_robots_area" name="robots">{$robots_txt|escape}</textarea>
                <div class="row">
                    <div class="col-lg-12 col-md-12">
						<input style="float:left;margin-top:15px;" class="button_green button_save" type="submit" name="save" value="{$tr->save|escape}" />
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>

<link rel="stylesheet" href="design/js/codemirror/lib/codemirror.css">
<script src="design/js/codemirror/lib/codemirror.js"></script>

<script src="design/js/codemirror/mode/css/css.js"></script>
<script src="design/js/codemirror/addon/selection/active-line.js"></script>

{literal}
    <style type="text/css">

        .CodeMirror{
            font-family:'Arial';
            margin-bottom:10px;
            border:1px solid #c0c0c0;
            background-color: #ffffff;
            height: auto;
            min-height: 100px;
            width:100%;
        }
        .CodeMirror-scroll
        {
            overflow-y: hidden;
            overflow-x: auto;
        }
    </style>
{/literal}

{literal}
    <script>
        var editor = CodeMirror.fromTextArea(document.getElementById("robots"), {
            mode: "mixed",
            lineNumbers: true,
            styleActiveLine: true,
            matchBrackets: false,
            enterMode: 'keep',
            indentWithTabs: false,
            indentUnit: 2,
            tabMode: 'classic'
        });
    </script>
{/literal}
