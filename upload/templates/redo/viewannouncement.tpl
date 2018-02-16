{*
 **********************************************************
 * Developed by: Team Theme Metro
 * Website: http://www.thememetro.com
 **********************************************************
*}


{$text}

<br />
<br />

<p><i class="fa fa-calendar text-success"></i>  &nbsp;{$timestamp|date_format:"%A, %B %e, %Y"}</p>

<div class="well no-padding-bottom">
	<div class="row">
{if $twittertweet}
		<div class="col-sm-2 text-left">
			<div class="tweetbutton" style="display:inline-block;"><a href="https://twitter.com/share" class="twitter-share-button" data-via="{$twitterusername}">Tweet</a><script type="text/javascript" src="//platform.twitter.com/widgets.js"></script></div>
		</div>
{/if}
{if $facebookrecommend}
		<div class="col-sm-8 text-center">
			{literal}<script>(function(d, s, id) { var js, fjs = d.getElementsByTagName(s)[0]; if (d.getElementById(id)) return; js = d.createElement(s); js.id = id; js.src = "//connect.facebook.net/en_US/all.js#xfbml=1"; fjs.parentNode.insertBefore(js, fjs); }(document, 'script', 'facebook-jssdk'));</script>{/literal}
			<div class="fb-like" data-href="{fqdnRoutePath('announcement-view', $id, $urlfriendlytitle)}" data-send="true" data-width="450" data-show-faces="true" data-action="recommend"></div>
		</div>
{/if}
{if $googleplus1}
		<div class="col-sm-2 text-right">
			<g:plusone data-size="small"></g:plusone>
			{literal}<script type="text/javascript">(function() { var po = document.createElement('script'); po.type = 'text/javascript'; po.async = true; po.src = 'https://apis.google.com/js/plusone.js'; var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(po, s); })();</script>{/literal}
		</div>
{/if}
	</div>
</div>

{if $facebookcomments}
    <br />
    <br />
    {literal}
    <div id="fb-root">
    </div>
    <script>(function(d, s, id) {
        var js, fjs = d.getElementsByTagName(s)[0];
        if (d.getElementById(id)) {return;}
        js = d.createElement(s); js.id = id;
        js.src = "//connect.facebook.net/en_US/all.js#xfbml=1";
        fjs.parentNode.insertBefore(js, fjs);
        }(document, 'script', 'facebook-jssdk'));</script>
    {/literal}
    <fb:comments href="{fqdnRoutePath('announcement-view', $id, $urlfriendlytitle)}" num_posts="5" width="100%"></fb:comments>
{/if}

<p>
    <a href="{routePath('announcement-index')}" class="btn btn-default">{$LANG.clientareabacklink}</a>
</p>
