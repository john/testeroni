WMD: The Wysiwym Markdown Editor
================================

Introduction
------------

This is a branch of wmd for ChiperSoft Systems, forked from the [Open Library](http://github.com/openlibrary/wmd) branch of WMD, which was forked from the [Stackoverflow branch](http://github.com/derobins/wmd).

Major Changes from Open Library Revision
-------------

* Removed top level frame pollution, forcing WMD to run only in its own document.
* Removed the automatic conversion from Markdown to HTML when the form is submitted.
* Removed the automatic addition of http:// to image urls, preventing the entry of relative addresses.
* Bug fixes

How to use
----------

	<html>
	    <head>
	        <title>WMD Example</title>
        
	        <link rel="stylesheet" type="text/css" href="wmd.css"/>
	        <script type="text/javascript" src="wmd.js"></script>
	        <script type="text/javascript" src="showdown.js"></script>
	    </head>
	    <body>
	        <h1>WMD Example</h1>

	        <div>
	            <div id="notes-button-bar"></div>
	            <textarea id="notes"></textarea>
	            <div id="notes-preview"></div>
				<input type="text" name="copy_html" value="" id="copy_html">
	        </div>

	        <script type="text/javascript">
	            setup_wmd({
	                input: "notes",
	                button_bar: "notes-button-bar",
	                preview: "notes-preview",
					output: "copy_html"
	            });
	        </script>
	    </body>
	</html>

License
-------

WMD Editor is licensed under [MIT License](http://github.com/chipersoft/wmd/raw/master/License.txt).


