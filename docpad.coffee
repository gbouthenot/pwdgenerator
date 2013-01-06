# The DocPad Configuration File
# It is simply a CoffeeScript Object which is parsed by CSON
docpadConfig = {

    # =================================
    # DocPad Configuration

    # Change the port DocPad uses from the default 9778 to 8080
    port: 9778


    # =================================
    # Template Data
    # These are variables that will be accessible via our templates

    templateData:

        # Specify some site properties
        site:
            # The production url of our website
            url: "http://website.com"

            # The default title of our website
            title: "Password generator"

            # The website description (for SEO)
            description: """
                """

            # The website keywords (for SEO) separated by commas
            keywords: """
                """


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
    # Plugins

    # Enable Unlisted Plugins
    # If set to false (defaults to true), we will only enable plugins that have been explicitly set to true inside enabledPlugins
    enabledUnlistedPlugins: true

    # Enabled Plugins
    enabledPlugins:
        # Disable the Pokemon Plugin
        pokemon: false

        # Enable the Digimon Plugin
        # Unless, enableUnlistedPlugins is set to false, all plugins are enabled by default
        digimon: true

    # Configure Plugins
    # Should contain the plugin short names on the left, and the configuration to pass the plugin on the right
    plugins:
        handlebars:
            precompileOpts:
                wrapper: "default"

        # Enable NIB within the Stylus Plugin
        stylus:
            useNib: true


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

    # =================================
    # Environments

    environments:
        development:
            outPath: "out/"
            enabledPlugins:
                uglify: false
        static:
            outPath: "out/"
            enabledPlugins:
                uglify: true
        public:
            outPath: "public/"
            enabledPlugins:
                uglify: true

}

# Export our DocPad Configuration
module.exports = docpadConfig
