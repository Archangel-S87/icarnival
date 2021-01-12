<script language="javascript" type="text/javascript" src="design/js/tinymce/tinymce.min.js"></script>
<script language="javascript">
tinymce.init({ 
    selector: "textarea.editor_large,textarea.editor_small",
    language : "{$admin_lang}",
	relative_urls : false,
	remove_script_host : false, // true to cut domen name
	convert_urls : true,
	verify_html: false,
	remove_linebreaks : false,
	entity_encoding: 'raw', // do not convert space into nbsp 
	spellchecker_languages : "+Russian=ru,+English=en",
    content_css: "/fivecms/design/css/localstyle.css",
    block_formats : "Paragraph=p;Div=div;Header 1=h1;Header 2=h2;Header 3=h3",
    fontsize_formats : "10px 11px 12px 13px 14px 15px 16px 17px 18px 20px 22px 24px 26px 28px 30px 32px",
    extended_valid_elements : 'img[*],script[*],style[*],iframe[*],div[*],span[*],p[*],table[*],tr[*],td[*],th[*],embed[*],object[*],svg[*],path[*],list[*],ul[*],li[*],form[*],input[*],select[*],option[*],textarea[*],video[*]',
    valid_children : '+body[style]',
  	style_formats_autohide: true,
  	style_formats_merge: false,
  	image_class_list: [
  		{ title: 'image default', value: 'image-default'},
    	{ title: 'image real-size', value: 'image-real-size'},
    	{ title: 'image half-width', value: 'image-half-width'}
  	],
  	link_class_list: [
  		{ title: 'default link', value: 'defaultlink'},
    	{ title: 'blue link', value: 'bluelink'},
    	{ title: 'none link', value: 'nonelink'}
  	],
    plugins: [
        "advlist autolink lists link image charmap hr anchor pagebreak",
        "searchreplace visualblocks visualchars code",
        "media nonbreaking save table contextmenu directionality",
        "template paste textcolor colorpicker textpattern responsivefilemanager importcss"
   	],
   menubar: 'edit insert view format table',
   toolbar1: "code | undo redo | cut copy paste pastetext removeformat | bold italic underline strikethrough | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent ",
   toolbar2: "| responsivefilemanager | link unlink anchor | image media | forecolor backcolor | styleselect | formatselect | fontsizeselect",
   image_advtab: true ,
   indentation : '20px',
   indent_use_margin: true,
   external_filemanager_path:"/fivecms/design/js/filemanager/",
   filemanager_title:"Responsive Filemanager" ,
   external_plugins: { "filemanager" : "../../../../fivecms/design/js/filemanager/plugin.min.js"},
		setup : function(ed) { 
		if(typeof set_meta == 'function')
		{ 
			ed.on('keyUp', function() { 
    			set_meta();
			});
			ed.on('change', function() { 
    			set_meta();
			});
		}
	}
	});
	function myCustomGetContent( id ) { 
		if( typeof tinymce != "undefined" ) { 
			var editor = tinymce.get( id );
			if( editor && editor instanceof tinymce.Editor ) { 
				return editor.getContent({ format : 'text'}).substr(0, 512);
			} else { 
				return  jQuery('textarea[name='+id+']').val().replace(/(<([^>]+)>)/ig," ").replace(/(\&nbsp;)/ig," ").replace(/^\s+|\s+$/g, '').substr(0, 512);
			}
		}
		return '';
	}
</script>