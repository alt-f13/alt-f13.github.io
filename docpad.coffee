# The DocPad Configuration File
# It is simply a CoffeeScript Object which is parsed by CSON
docpadConfig = {

	# =================================
	# Template Data
	# These are variables that will be accessible via our templates
	# To access one of these within our templates, refer to the FAQ: https://github.com/bevry/docpad/wiki/FAQ

	templateData:

		# Specify some site properties
		site:
			# The production url of our website
			url: "http://cm-spb.ru"
			outPath: './output'


			# Here are some old site urls that you would like to redirect from
			oldUrls: [
				'www.cm-spb.ru',
				'www.plm-spb.ru'
			]

			# The default title of our website
			title: "Колледж метрополитена"

			# The website description (for SEO)
			description: """
			             Cанкт-петербургское государственное бюджетное профессиональное образовательное учреждение колледж метрополитена
			             				"""

			# The website keywords (for SEO) separated by commas
			keywords: """
			          колледж, образование, санкт-петербург, спб, метрополитен, работа, обучение, профессия, будущее
			          """

			# The website author's name
			author: "Galyamin.d.d"

			# The website author's email
			email: "Galyamin.d.d@gmail.com"

			# Styles
			styles: [
				#"/styles/twitter-bootstrap.css"
				"//netdna.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css"
				"//blueimp.github.io/Gallery/css/blueimp-gallery.min.css"
				#"/css/bootstrap-image-gallery.css"
				#"/css/demo.css"
				#"/css/kube.css"
				#"/css/tree.css"
				#	"/css/landing-page.css"
				#	"/css/icons.css"
				"http://fonts.googleapis.com/css?family=Buenard:700"
					#"/css/diamonds.css"
					"/css/blueimp-gallery.css"
					"/css/blueimp-gallery-indicator.css"
					"/css/blueimp-gallery-video.css"
				"/css/index.css"
					"//cdnjs.cloudflare.com/ajax/libs/flexboxgrid/6.3.1/flexboxgrid.min.css"

			]

			# Scripts
			scripts: [
				#"//cdnjs.cloudflare.com/ajax/libs/jquery/1.10.2/jquery.min.js"
				#"//cdnjs.cloudflare.com/ajax/libs/modernizr/2.6.2/modernizr.min.js"
				#"/vendor/twitter-bootstrap/dist/js/bootstrap.min.js"
				"//netdna.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"
				"//blueimp.github.io/Gallery/js/jquery.blueimp-gallery.min.js"
				#"/js/bootstrap-image-gallery.js"
				"/js/tree.js"
				"/js/uhpv-full.min.js"
				"http://pupunzi.com/mb.components/mb.YTPlayer/demo/inc/jquery.mb.YTPlayer.js"
				"/js/jquery.diamonds.js"
				"/js/date.js"
				"https://rawgit.com/kimmobrunfeldt/progressbar.js/1.0.0/dist/progressbar.js"
				#"/js/jquery.knob.min.js"
				"/js/jquery.vide.js"
				"/bower_components/jquery-textfill/source/jquery.textfill.min.js"
			]



		# -----------------------------
		# Helper Functions

		# Get the prepared site/document title
		# Often we would like to specify particular formatting to our page's title
		# we can apply that formatting here
		getPreparedTitle: ->
			# if we have a document title, then we should use that and suffix the site's title onto it
			if @document.title
				"#{@document.title} | #{@site.title}"
			# if our document does not have it's own title, then we should just use the site's title
			else
				@site.title

		# Get the prepared site/document description
		getPreparedDescription: ->
			# if we have a document description, then we should use that, otherwise use the site's description
			@document.description or @site.description

		# Get the prepared site/document keywords
		getPreparedKeywords: ->
			# Merge the document keywords with the site keywords
			@site.keywords.concat(@document.keywords or []).join(', ')


	# =================================
	# Collections
	# These are special collections that our website makes available to us

	collections:
		menu: (database) ->
			database.findAllLive({menutitle: $exists: true}, [pageOrder:1,menutitle:1])
		menu2: (database) ->
			database.findAllLive({menu2title: $exists: true}, [pageOrder:1,menu2title:1])
		posts: (database) ->
			database.findAllLive({layout:$has:'post'}, [date:-1])
		faces: (database) ->
			database.findAllLive({layout:$has:'faces'}, [lastname:1])
		contacts: (database) ->
			database.findAllLive({layout:$has:'contacts'}, [order:1])
		gallery: (database) ->
			database.findAllLive({layout:$has:'gallery'})


	# =================================
	# Plugins

#		getIndex: ->
#			@getCollection('html').findOne(url: '/')?.toJSON()
	getArticles: ->
		@getCollection('html').findAllLive(type:'post',[ date:-1])
	getLinks: ->
		@getCollection('html').findAllLive(type: 'link',[name:1])

	plugins:
    sitemap:
      cachetime: 600000
      changefreq: 'weekly'
    	priority: 0.5
    	filePath: 'sitemap.xml'
		,

		#
			# 	ghpages:
			#   	deployBranch: 'master'
			#   	deployRemote: 'pages'
		#
		# 	downloader:
		# 		downloads: [
		# 			{
		# 				name: 'Bootstrap'
		# 				path: 'src/files/vendor/twitter-bootstrap'
		# 				url: 'https://codeload.github.com/twbs/bootstrap/tar.gz/master'
		# 				tarExtractClean: true
		# 			}
		# 		]
		#




	#thumbnails:
		#imageMagick: true




	# =================================
	# DocPad Events

	# Here we can define handlers for events that DocPad fires
	# You can find a full listing of events on the DocPad Wiki
	events:

		# Server Extend
		# Used to add our own custom routes to the server before the docpad routes are added
		serverExtend: (opts) ->
			# Extract the server from the options
			{server} = opts
			docpad = @docpad

			# As we are now running in an event,
			# ensure we are using the latest copy of the docpad configuraiton
			# and fetch our urls from it
			latestConfig = docpad.getConfig()
			oldUrls = latestConfig.templateData.site.oldUrls or []
			newUrl = latestConfig.templateData.site.url

			# Redirect any requests accessing one of our sites oldUrls to the new site url
			server.use (req,res,next) ->
				if req.headers.host in oldUrls
					res.redirect(newUrl+req.url, 301)
				else
					next()
}


# Export our DocPad Configuration
module.exports = docpadConfig
