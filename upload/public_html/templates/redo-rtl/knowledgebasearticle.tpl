{*
 **********************************************************
 * Developed by: Team Theme Metro
 * Website: http://www.thememetro.com
 **********************************************************
*}

<div>
	<a href="#" class="pull-right" onclick="window.print();return false"><i class="fa fa-print bigger-150"></i></a>
	<h2 class="no-margin-top">{$kbarticle.title}</h2>
	<div class="clearfix"></div>
</div>


{if $kbarticle.voted}{include file="$template/includes/alert.tpl" type="success" msg="{lang key="knowledgebaseArticleRatingThanks"}" textcenter=true}{/if}

<p>
    {$kbarticle.text}
</p>

<div class="space-16"></div>

<ul class="kb-article-details">
    {if $kbarticle.tags }<li><i class="fa fa-tag"></i> {$kbarticle.tags}</li>{/if}
    <li><i class="fa fa-star"></i> {$kbarticle.useful} {$LANG.knowledgebaseratingtext}</li>
</ul>
<div class="clearfix"></div>

<div class="space-8"></div>


<div class="hidden-print">

    <div class="well light">
		<form action="{routePath('knowledgebase-article-view', {$kbarticle.id}, {$kbarticle.urlfriendlytitle})}" method="post">
			<input type="hidden" name="useful" value="vote">
			{if $kbarticle.voted}{$LANG.knowledgebaserating}{else}{$LANG.knowledgebasehelpful}{/if}
			{if $kbarticle.voted}
				{$kbarticle.useful} {$LANG.knowledgebaseratingtext} ({$kbarticle.votes} {$LANG.knowledgebasevotes})
			{else}
				<button type="submit" name="vote" value="yes" class="btn btn-primary"><i class="fa fa-thumbs-o-up"></i> {$LANG.knowledgebaseyes}</button>
				<button type="submit" name="vote" value="no" class="btn  btn-default"><i class="fa fa-thumbs-o-down"></i> {$LANG.knowledgebaseno}</button>
			{/if}
		</form>
			
    </div>

    
</div>

<div class="space-24"></div>

{if $kbarticles}
    <div class="kb-also-read">
        <h4 class="bolder">{$LANG.knowledgebasealsoread}</h4>
        <div class="kbarticles">
            {foreach key=num item=kbarticle from=$kbarticles}
                <div>
                    <a href="{routePath('knowledgebase-article-view', {$kbarticle.id}, {$kbarticle.urlfriendlytitle})}">
                        <i class="glyphicon glyphicon-file"></i> {$kbarticle.title}
                    </a>
                    <p>{$kbarticle.article|truncate:100:"..."}</p>
                </div>
            {/foreach}
        </div>
    </div>
{/if}